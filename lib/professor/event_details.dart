import 'package:flutter/material.dart';

class EventDetailsScreen extends StatefulWidget {
  final int eventId;
  final Function(int) onNavigate;

  const EventDetailsScreen({
    Key? key,
    required this.eventId,
    required this.onNavigate,
  }) : super(key: key);

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock event data
  final Map<String, dynamic> _event = {
    'title': 'Flutter Workshop',
    'description':
        'Master Flutter development with hands-on projects. This comprehensive workshop will cover everything from basics to advanced concepts including state management, animations, and API integration. Participants will build a complete mobile application.',
    'date': 'Dec 28, 2025',
    'time': '2:00 PM - 5:00 PM',
    'location': 'Room 301, CS Building',
    'registered': 45,
    'capacity': 50,
    'status': 'upcoming',
    'category': 'Workshop',
    'image':
        'https://images.unsplash.com/photo-1736066330610-c102cab4e942?w=800&q=80',
  };

  final List<Map<String, String>> _attendees = [
    {
      'id': '1',
      'name': 'John Smith',
      'email': 'john.smith@university.edu',
      'registeredDate': 'Dec 20, 2025',
      'year': '3rd Year',
    },
    {
      'id': '2',
      'name': 'Emma Wilson',
      'email': 'emma.wilson@university.edu',
      'registeredDate': 'Dec 21, 2025',
      'year': '2nd Year',
    },
    {
      'id': '3',
      'name': 'Michael Brown',
      'email': 'michael.brown@university.edu',
      'registeredDate': 'Dec 21, 2025',
      'year': '4th Year',
    },
    {
      'id': '4',
      'name': 'Sophia Davis',
      'email': 'sophia.davis@university.edu',
      'registeredDate': 'Dec 22, 2025',
      'year': '3rd Year',
    },
    {
      'id': '5',
      'name': 'James Miller',
      'email': 'james.miller@university.edu',
      'registeredDate': 'Dec 22, 2025',
      'year': '2nd Year',
    },
    {
      'id': '6',
      'name': 'Olivia Garcia',
      'email': 'olivia.garcia@university.edu',
      'registeredDate': 'Dec 23, 2025',
      'year': '1st Year',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registered = _event['registered'] as int;
    final capacity = _event['capacity'] as int;
    final percentage = (registered / capacity * 100).round();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 48, 20, 100),
                child: Column(
                  children: [
                    // Back Button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () => widget.onNavigate(1),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.arrow_back,
                              size: 20,
                              color: Color(0xFFA855F7),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Back to My Events',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFA855F7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Event Image
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.network(
                            _event['image'],
                            height: 192,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 192,
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 48,
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          height: 192,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD1FAE5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _event['status'] == 'upcoming'
                                      ? 'Active'
                                      : 'Completed',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF10B981),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _event['title'],
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _event['category'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Quick Actions
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Handle edit
                            },
                            icon: const Icon(Icons.edit, size: 16),
                            label: const Text('Edit Event'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFA855F7),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            // Handle delete
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFEE2E2),
                            foregroundColor: const Color(0xFFEF4444),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Icon(Icons.delete, size: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Tabs
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: const Color(0xFFA855F7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: const Color(0xFF6B7280),
                        tabs: [
                          const Tab(text: 'Event Details'),
                          Tab(text: 'Attendees ($registered)'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Tab Content
                    SizedBox(
                      height: 600,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildDetailsTab(registered, capacity, percentage),
                          _buildAttendeesTab(registered),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsTab(int registered, int capacity, int percentage) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Description
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF3F4F6)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _event['description'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Event Information
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF3F4F6)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Event Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  Icons.calendar_today,
                  'Date',
                  _event['date'],
                  const Color(0xFFF3E8FF),
                  const Color(0xFFA855F7),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.access_time,
                  'Time',
                  _event['time'],
                  const Color(0xFFE0E7FF),
                  const Color(0xFF6366F1),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.location_on,
                  'Location',
                  _event['location'],
                  const Color(0xFFDCEEFE),
                  const Color(0xFF3B82F6),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Registration Stats
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF3F4F6)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Registration Status',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Registered Students',
                      style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                    ),
                    Text(
                      '$registered/$capacity',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: registered / capacity,
                    minHeight: 12,
                    backgroundColor: const Color(0xFFE5E7EB),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFA855F7),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '$registered',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFA855F7),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Registered',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '${capacity - registered}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Available',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '$percentage%',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6366F1),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Full',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendeesTab(int registered) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Export Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download, size: 16),
                  label: const Text('Export List'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF374151),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.email, size: 16),
                  label: const Text('Email All'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF3E8FF),
                    foregroundColor: const Color(0xFFA855F7),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Attendees List
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF3F4F6)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                ..._attendees.asMap().entries.map((entry) {
                  final index = entry.key;
                  final attendee = entry.value;
                  return Column(
                    children: [
                      if (index > 0)
                        const Divider(height: 1, color: Color(0xFFF3F4F6)),
                      _buildAttendeeItem(attendee),
                    ],
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Show More
          if (registered > 6)
            TextButton(
              onPressed: () {},
              child: Text('Show all $registered attendees'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFA855F7),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    Color bgColor,
    Color iconColor,
  ) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttendeeItem(Map<String, String> attendee) {
    final initials = attendee['name']!.split(' ').map((n) => n[0]).join('');

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFA855F7), Color(0xFF6366F1)],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attendee['name']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  attendee['email']!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                attendee['year']!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFA855F7),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                attendee['registeredDate']!,
                style: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
