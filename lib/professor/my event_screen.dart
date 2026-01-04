import 'package:flutter/material.dart';

class ProfessorMyEventsScreen extends StatefulWidget {
  final Function(int) onViewEvent;
  final Function(int) onNavigate;

  const ProfessorMyEventsScreen({
    Key? key,
    required this.onViewEvent,
    required this.onNavigate,
  }) : super(key: key);

  @override
  State<ProfessorMyEventsScreen> createState() =>
      _ProfessorMyEventsScreenState();
}

class _ProfessorMyEventsScreenState extends State<ProfessorMyEventsScreen> {
  String _filter = 'all';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _events = [
    {
      'id': 1,
      'title': 'Flutter Workshop',
      'description': 'Master Flutter development with hands-on projects',
      'date': 'Dec 28, 2025',
      'time': '2:00 PM',
      'location': 'Room 301',
      'registered': 45,
      'capacity': 50,
      'status': 'upcoming',
      'image':
          'https://images.unsplash.com/photo-1736066330610-c102cab4e942?w=800&q=80',
    },
    {
      'id': 2,
      'title': 'Web Dev Bootcamp',
      'description': 'Build modern web apps with React & Node.js',
      'date': 'Dec 30, 2025',
      'time': '10:00 AM',
      'location': 'Lab A',
      'registered': 30,
      'capacity': 35,
      'status': 'upcoming',
      'image':
          'https://images.unsplash.com/photo-1606761568499-6d2451b23c66?w=800&q=80',
    },
    {
      'id': 3,
      'title': 'AI Workshop Series',
      'description': 'Introduction to Machine Learning and AI',
      'date': 'Dec 20, 2025',
      'time': '3:00 PM',
      'location': 'Main Hall',
      'registered': 50,
      'capacity': 50,
      'status': 'past',
      'image':
          'https://images.unsplash.com/photo-1716703435453-a7733d600d68?w=800&q=80',
    },
  ];

  List<Map<String, dynamic>> get _filteredEvents {
    if (_filter == 'all') return _events;
    return _events.where((e) => e['status'] == _filter).toList();
  }

  int get _upcomingCount =>
      _events.where((e) => e['status'] == 'upcoming').length;
  int get _pastCount => _events.where((e) => e['status'] == 'past').length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 48, 20, 100),
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFA855F7), Color(0xFF6366F1)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFA855F7).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Events',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage all your created events',
                      style: TextStyle(fontSize: 14, color: Colors.purple[100]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search events...',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF9CA3AF),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFA855F7),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 16),

              // Filter Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('all', 'All Events (${_events.length})'),
                    const SizedBox(width: 8),
                    _buildFilterChip('upcoming', 'Upcoming ($_upcomingCount)'),
                    const SizedBox(width: 8),
                    _buildFilterChip('past', 'Past ($_pastCount)'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Events List
              ..._filteredEvents.map(
                (event) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildEventCard(event),
                ),
              ),

              const SizedBox(height: 16),

              // Create New Event Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFA855F7), Color(0xFF6366F1)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFA855F7).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => widget.onNavigate(2),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
                      shadowColor: const Color.fromARGB(0, 223, 222, 225),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Create New Event',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _filter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _filter = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFA855F7) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFFE5E7EB),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFA855F7).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    final registered = event['registered'] as int;
    final capacity = event['capacity'] as int;
    final percentage = (registered / capacity * 100).round();

    return Container(
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
          // Event Image
          GestureDetector(
            onTap: () => widget.onViewEvent(event['id']),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    event['image'],
                    height: 128,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 128,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported, size: 48),
                      );
                    },
                  ),
                ),
                Container(
                  height: 128,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.5),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: event['status'] == 'upcoming'
                          ? const Color(0xFFD1FAE5)
                          : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      event['status'] == 'upcoming' ? 'Active' : 'Completed',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: event['status'] == 'upcoming'
                            ? const Color(0xFF10B981)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => widget.onViewEvent(event['id']),
                  child: Text(
                    event['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  event['description'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 12),

                // Event Details
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _buildDetailChip(Icons.calendar_today, event['date']),
                    _buildDetailChip(Icons.access_time, event['time']),
                    _buildDetailChip(Icons.location_on, event['location']),
                  ],
                ),
                const SizedBox(height: 12),

                // Registration Progress
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.people,
                          size: 14,
                          color: Color(0xFF6B7280),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$registered/$capacity registered',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '$percentage%',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: registered / capacity,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFE5E7EB),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFA855F7),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Handle edit
                        },
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Edit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF3E8FF),
                          foregroundColor: const Color(0xFFA855F7),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 8),
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
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Icon(Icons.delete, size: 16),
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

  Widget _buildDetailChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF6B7280)),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
