import 'package:flutter/material.dart';

class ProfessorDashboard extends StatelessWidget {
  final void Function(String screen) onNavigate;
  final void Function(int eventId) onViewEvent;

  const ProfessorDashboard({
    Key? key,
    required this.onNavigate,
    required this.onViewEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final upcomingEvents = [
      {
        'id': 1,
        'title': 'Flutter Workshop',
        'date': 'Dec 28, 2025',
        'time': '2:00 PM',
        'location': 'Room 301',
        'registered': 45,
        'capacity': 50,
      },
      {
        'id': 2,
        'title': 'Web Dev Bootcamp',
        'date': 'Dec 30, 2025',
        'time': '10:00 AM',
        'location': 'Lab A',
        'registered': 30,
        'capacity': 35,
      },
    ];

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
                        backgroundImage: AssetImage('assets/logo.png'),
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
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E8FF),
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
                    const Text(
                      'Welcome back, Professor! 👨‍🏫',
                      style: TextStyle(
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
                      onPressed: () => onNavigate('create-event'),
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
                    '8',
                    'Total Events',
                    Icons.event,
                    const Color(0xFF7C3AED),
                  ),
                  const SizedBox(width: 12),
                  _statCard(
                    '156',
                    'Students',
                    Icons.people,
                    const Color(0xFF6366F1),
                  ),
                  const SizedBox(width: 12),
                  _statCard(
                    '2',
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
                    onPressed: () => onNavigate('events'),
                    child: const Text('See all'),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              ...upcomingEvents.map((event) {
                final progress = event['registered']! / event['capacity'];

                return GestureDetector(
                  onTap: () => onViewEvent(event['id'] as int),
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
                            Text(event['location'] as String),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${event['registered']} / ${event['capacity']} registered',
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

              _activityItem(
                Icons.people,
                '5 new registrations for Flutter Workshop',
                '2 hours ago',
                const Color(0xFF7C3AED),
              ),
              _activityItem(
                Icons.event,
                'Web Dev Bootcamp starting tomorrow',
                '1 day ago',
                const Color(0xFF6366F1),
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
            Text(label, style: const TextStyle(fontSize: 12)),
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
                Text(time, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension on Object {
  operator /(Object? other) {}
}
