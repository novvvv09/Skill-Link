import 'package:flutter/material.dart';
import 'package:skill_link/UI/role_selection.dart';
import 'package:skill_link/auth/log-in_screen.dart';
import 'package:skill_link/auth/splash_screen.dart';
import 'package:skill_link/professor/create_event_screen.dart';
import 'package:skill_link/professor/event_details.dart';
import 'package:skill_link/professor/my%20event_screen.dart';
import 'package:skill_link/professor/professor_nav.dart';
import 'package:skill_link/professor/professor_profile.dart';
import 'package:skill_link/student/event_screen.dart';
import 'package:skill_link/student/notification_screen.dart';
import 'package:skill_link/student/post_project_modal.dart';
import 'package:skill_link/student/student_profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter', // Add custom font
        useMaterial3: true,
      ),
      home: const AppNavigator(),
    );
  }
}

class AppNavigator extends StatefulWidget {
  const AppNavigator({Key? key}) : super(key: key);

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _navigateAfterSplash();
  }

  void _navigateAfterSplash() async {
    // Wait for splash screen duration (adjust based on your splash_screen.dart)
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        _showSplash = false;
      });
    }
  }

  void _handleRoleSelection(String role) {
    // Navigate to login screen with selected role
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LoginScreen(role: role, onLogin: () => _handleLogin(role)),
      ),
    );
  }

  void _handleLogin(String role) {
    // Navigate to the appropriate dashboard after successful login
    if (role == 'student') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StudentHomeScreen()),
      );
    } else if (role == 'professor') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfessorHomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return SplashScreen(onComplete: () {});
    }

    return RoleSelectionScreen(onSelectRole: _handleRoleSelection);
  }
}

// Student Home Screen with Bottom Navigation
class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({Key? key}) : super(key: key);

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const StudentDashboard(),
    const EventsScreen(), // Events screen with registration
    const ProjectsPage(), // Community projects feed
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF3B82F6),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Projects'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// Student Dashboard (Home Tab)
class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  String _userName = 'Student';
  int _eventsCount = 0;
  int _projectsCount = 0;
  int _certificatesCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    if (_currentUser == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      // Load user data
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;

        setState(() {
          _userName = userData?['fullName']?.split(' ')[0] ?? 'Student';
          _eventsCount = userData?['stats']?['eventsAttended'] ?? 0;
          _projectsCount = userData?['stats']?['projectsPosted'] ?? 0;
          _certificatesCount = userData?['stats']?['certificatesEarned'] ?? 0;
        });
      }

      // Also get total available events and projects
      await FirebaseFirestore.instance.collection('events').get();

      // ignore: unused_local_variable
      QuerySnapshot projectsSnapshot = await FirebaseFirestore.instance
          .collection('projects')
          .get();

      setState(() {
        // You can choose to show user's stats OR total available
        // Currently showing user's stats, but you can change to:
        // _eventsCount = eventsSnapshot.docs.length;
        // _projectsCount = projectsSnapshot.docs.length;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading dashboard data: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
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
              // Header with Notification
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Student Dashboard',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined),
                        color: const Color(0xFF6B7280),
                        iconSize: 28,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationsScreen(
                                role: 'student',
                                onBack: () => Navigator.pop(context),
                                onNavigate: (screen) {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEF4444),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF9333EA)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.school,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome, $_userName!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Access events, projects, and certificates',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Quick Stats
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      _eventsCount.toString(),
                      'Events',
                      Icons.event,
                      const Color(0xFF3B82F6),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      _projectsCount.toString(),
                      'Projects',
                      Icons.work,
                      const Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      _certificatesCount.toString(),
                      'Certificates',
                      Icons.card_membership,
                      const Color(0xFFA855F7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }
}

// Professor Home Screen with Custom Bottom Navigation
class ProfessorHomeScreen extends StatefulWidget {
  const ProfessorHomeScreen({Key? key}) : super(key: key);

  @override
  State<ProfessorHomeScreen> createState() => _ProfessorHomeScreenState();
}

class _ProfessorHomeScreenState extends State<ProfessorHomeScreen> {
  int _currentIndex = 0;
  int? _selectedEventId;
  bool _showingEventDetails = false;

  List<Widget> _getScreens() {
    if (_showingEventDetails && _selectedEventId != null) {
      return [
        EventDetailsScreen(
          eventId: _selectedEventId!,
          onNavigate: (index) {
            setState(() {
              _showingEventDetails = false;
              _currentIndex = index;
            });
          },
        ),
      ];
    }

    return [
      const ProfessorDashboard(),
      ProfessorMyEventsScreen(
        onViewEvent: (eventId) {
          setState(() {
            _selectedEventId = eventId;
            _showingEventDetails = true;
          });
        },
        onNavigate: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      CreateEventScreen(
        onNavigate: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      ProfessorProfileScreen(
        onLogout: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AppNavigator()),
            (route) => false,
          );
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screens = _getScreens();

    return Scaffold(
      body: Stack(
        children: [
          _showingEventDetails ? screens[0] : screens[_currentIndex],
          if (!_showingEventDetails)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ProfessorBottomNav(
                currentIndex: _currentIndex,
                onNavigate: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}

// Professor Dashboard (Home Tab)
class ProfessorDashboard extends StatefulWidget {
  const ProfessorDashboard({Key? key}) : super(key: key);

  @override
  State<ProfessorDashboard> createState() => _ProfessorDashboardState();
}

class _ProfessorDashboardState extends State<ProfessorDashboard> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  String _professorName = 'Professor';
  int _totalEvents = 0;
  int _totalStudents = 0;
  int _totalProjects = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    if (_currentUser == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      // Load user data
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        setState(() {
          _professorName = userData?['fullName']?.split(' ')[0] ?? 'Professor';
        });
      }

      // Load events created by this professor
      QuerySnapshot eventsSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('createdBy', isEqualTo: _currentUser!.uid)
          .get();

      // Count unique students registered for professor's events
      Set<String> uniqueStudents = {};
      for (var eventDoc in eventsSnapshot.docs) {
        QuerySnapshot registrations = await FirebaseFirestore.instance
            .collection('events')
            .doc(eventDoc.id)
            .collection('registrations')
            .get();

        for (var reg in registrations.docs) {
          uniqueStudents.add(reg.id);
        }
      }

      // Get total projects count
      QuerySnapshot projectsSnapshot = await FirebaseFirestore.instance
          .collection('projects')
          .get();

      setState(() {
        _totalEvents = eventsSnapshot.docs.length;
        _totalStudents = uniqueStudents.length;
        _totalProjects = projectsSnapshot.docs.length;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading dashboard data: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
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
              // Header with Notification
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Professor Dashboard',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined),
                        color: const Color(0xFF6B7280),
                        iconSize: 28,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationsScreen(
                                role: 'professor',
                                onBack: () => Navigator.pop(context),
                                onNavigate: (screen) {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEF4444),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFA855F7), Color(0xFF6366F1)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.people,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome, $_professorName!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Manage events and student activities',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Quick Stats
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      _totalEvents.toString(),
                      'Events',
                      Icons.event,
                      const Color(0xFFA855F7),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      _totalStudents.toString(),
                      'Students',
                      Icons.people,
                      const Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      _totalProjects.toString(),
                      'Projects',
                      Icons.work,
                      const Color(0xFF3B82F6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }
}
