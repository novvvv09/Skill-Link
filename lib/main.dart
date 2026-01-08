import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:skill_link/UI/role_selection.dart';
import 'package:skill_link/auth/log-in_screen.dart';
import 'package:skill_link/auth/splash_screen.dart';
import 'package:skill_link/professor/create_event_screen.dart';
import 'package:skill_link/professor/my_event_screen.dart';
import 'package:skill_link/professor/professor_profile.dart';
import 'package:skill_link/student/event_screen.dart';
import 'package:skill_link/student/notification_screen.dart';
import 'package:skill_link/student/project_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_link/utils/responsive_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase Initialized');
  } catch (e) {
    debugPrint('❌ Firebase Error: $e');
  }

  runZonedGuarded(
    () {
      runApp(const MyApp());
    },
    (error, stackTrace) {
      debugPrint('🔥 App Error: $error\n$stackTrace');
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skill Link',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF3B82F6),
        fontFamily: 'Inter',
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xFF3B82F6),
          foregroundColor: Colors.white,
        ),
      ),
      home: const AppEntry(),
    );
  }
}

class AppEntry extends StatefulWidget {
  const AppEntry({Key? key}) : super(key: key);

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showSplash = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return SplashScreen(onComplete: () {});
    }
    return RoleSelectionScreen(
      onSelectRole: (role) {
        try {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => LoginScreen(
                role: role,
                onLogin: () {
                  _handleLogin(context, role);
                },
              ),
            ),
          );
        } catch (e) {
          debugPrint('Error: $e');
        }
      },
    );
  }

  void _handleLogin(BuildContext context, String role) {
    try {
      if (role == 'student') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const StudentHomeScreen()),
        );
      } else if (role == 'professor') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ProfessorHomeScreen()),
        );
      }
    } catch (e) {
      debugPrint('Navigation Error: $e');
    }
  }
}

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({Key? key}) : super(key: key);

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isSmall = ResponsiveUtil.isSmallScreen(context);

    final screens = [
      const StudentDashboard(),
      const EventsScreen(),
      const ProjectsPage(),
      const StudentProfileScreen(),
    ];

    return Scaffold(
      body: SafeArea(child: screens[_currentIndex]),
      bottomNavigationBar: isSmall
          ? BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (i) => setState(() => _currentIndex = i),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: const Color(0xFF3B82F6),
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.event),
                  label: 'Events',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.work),
                  label: 'Projects',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            )
          : null,
    );
  }
}

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  late User? _user;
  String _name = 'Student';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .get();
        if (doc.exists && mounted) {
          setState(() {
            _name = (doc['fullName'] ?? 'Student').toString().split(' ')[0];
          });
        }
      } catch (e) {
        debugPrint('Error loading user: $e');
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Dashboard',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NotificationsScreen(
                          role: 'student',
                          onBack: _onNotificationBack,
                          onNavigate: _onNotificationNavigate,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Welcome, $_name! 👋',
                style: const TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 30),
              _buildCard('0', 'Events', Icons.event),
              const SizedBox(height: 12),
              _buildCard('0', 'Projects', Icons.work),
              const SizedBox(height: 12),
              _buildCard('0', 'Certificates', Icons.card_membership),
            ],
          ),
        ),
      ),
    );
  }

  void _onNotificationBack() => Navigator.pop(context);
  void _onNotificationNavigate(String screen) => Navigator.pop(context);

  Widget _buildCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF3B82F6)),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Color(0xFF6B7280))),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfessorHomeScreen extends StatefulWidget {
  const ProfessorHomeScreen({Key? key}) : super(key: key);

  @override
  State<ProfessorHomeScreen> createState() => _ProfessorHomeScreenState();
}

class _ProfessorHomeScreenState extends State<ProfessorHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      ProfessorMyEventsScreen(
        onViewEvent: _onViewEvent,
        onNavigate: _onNavigate,
      ),
      CreateEventScreen(onNavigate: (i) => setState(() => _currentIndex = i)),
      ProfessorProfileScreen(
        onLogout: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const AppEntry()),
          (route) => false,
        ),
      ),
    ];

    return Scaffold(
      body: SafeArea(child: screens[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF3B82F6),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Create'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  void _onViewEvent(String eventId) {
    debugPrint('Viewing event: $eventId');
  }

  void _onNavigate(int index) {
    setState(() => _currentIndex = index);
  }
}

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Profile Screen')));
  }
}
