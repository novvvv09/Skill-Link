import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfessorDashboard extends StatefulWidget {
  final void Function(String screen) onNavigate;
  final void Function(int eventId) onViewEvent;

  const ProfessorDashboard({
    Key? key,
    required this.onNavigate,
    required this.onViewEvent,
  }) : super(key: key);

  @override
  State<ProfessorDashboard> createState() => _ProfessorDashboardState();
}

class _ProfessorDashboardState extends State<ProfessorDashboard> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  String _professorName = 'Professor';
  int _totalEvents = 0;
  int _totalStudents = 0;
  int _upcomingEvents = 0;
  List<Map<String, dynamic>> _events = [];
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
          .doc(_currentUser.uid)
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
          .where('createdBy', isEqualTo: _currentUser.uid)
          .orderBy('date', descending: false)
          .get();

      // Count unique students registered for professor's events
      Set<String> uniqueStudents = {};
      List<Map<String, dynamic>> eventsList = [];

      for (var eventDoc in eventsSnapshot.docs) {
        Map<String, dynamic> data = eventDoc.data() as Map<String, dynamic>;

        // Get registrations for this event
        QuerySnapshot registrations = await FirebaseFirestore.instance
            .collection('events')
            .doc(eventDoc.id)
            .collection('registrations')
            .get();

        for (var reg in registrations.docs) {
          uniqueStudents.add(reg.id);
        }

        int registeredCount = registrations.docs.length;
        int capacity = data['capacity'] ?? 50;

        eventsList.add({
          'id': eventDoc.id,
          'title': data['title'] ?? 'Untitled Event',
          'date': data['date'] ?? 'TBD',
          'time': data['time'] ?? 'TBD',
          'location': data['location'] ?? 'TBD',
          'registered': registeredCount,
          'capacity': capacity,
        });
      }

      setState(() {
        _totalEvents = eventsSnapshot.docs.length;
        _totalStudents = uniqueStudents.length;
        _upcomingEvents = eventsList.length; // You can add date filtering here
        _events = eventsList.take(2).toList(); // Show only first 2 events
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
          padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: Color(0xFF7C3AED),
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Professor Portal',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF3E8FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications,
                          color: Color(0xFF7C3AED),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// WELCOME CARD
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, $_professorName! 👨‍🏫',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Manage your events and engage with students',
                      style: TextStyle(color: Color(0xFFEDE9FE)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => widget.onNavigate('create-event'),
                      icon: const Icon(Icons.add),
                      label: const Text('Create New Event'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color(0xFF7C3AED),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// QUICK STATS
              Row(
                children: [
                  _statCard(
                    _totalEvents.toString(),
                    'Total Events',
                    Icons.event,
                    const Color(0xFF7C3AED),
                  ),
                  const SizedBox(width: 12),
                  _statCard(
                    _totalStudents.toString(),
                    'Students',
                    Icons.people,
                    const Color(0xFF6366F1),
                  ),
                  const SizedBox(width: 12),
                  _statCard(
                    _upcomingEvents.toString(),
                    'Upcoming',
                    Icons.schedule,
                    const Color(0xFF10B981),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              /// UPCOMING EVENTS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Upcoming Events',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  TextButton(
                    onPressed: () => widget.onNavigate('events'),
                    child: const Text('See all'),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (_events.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: const Center(
                    child: Column(
                      children: [
                        Icon(Icons.event_busy, size: 48, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          'No events yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Create your first event to get started',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ..._events.map((event) {
                  final registered = event['registered'] as int;
                  final capacity = event['capacity'] as int;
                  final progress = capacity > 0 ? registered / capacity : 0.0;

                  return GestureDetector(
                    onTap: () {
                      // Convert string ID to int for compatibility
                      // You might need to adjust this based on your event ID structure
                      widget.onViewEvent(1);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event['title'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 14),
                              const SizedBox(width: 4),
                              Text(event['time'] as String),
                              const SizedBox(width: 12),
                              const Icon(Icons.location_on, size: 14),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  event['location'] as String,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$registered / $capacity registered',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 6),
                          LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: const AlwaysStoppedAnimation(
                              Color(0xFF7C3AED),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),

              const SizedBox(height: 24),

              /// RECENT ACTIVITY
              const Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 12),

              if (_events.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: const Center(
                    child: Text(
                      'No recent activity',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                _activityItem(
                  Icons.event,
                  'You have ${_events.length} upcoming events',
                  'Just now',
                  const Color(0xFF7C3AED),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _activityItem(IconData icon, String text, String time, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
