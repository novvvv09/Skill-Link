import 'package:flutter/material.dart';
import 'event_registration_modal.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedType = 'all';

  final List<Event> _events = mockEvents;

  List<Event> get _filteredEvents {
    return _events.where((event) {
      final matchesSearch =
          event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesType = _selectedType == 'all' || event.type == _selectedType;
      return matchesSearch && matchesType;
    }).toList();
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'workshop':
        return const Color(0xFF3B82F6);
      case 'hackathon':
        return const Color(0xFFA855F7);
      case 'seminar':
        return const Color(0xFF10B981);
      case 'networking':
        return const Color(0xFFF97316);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Color _getTypeBackgroundColor(String type) {
    switch (type) {
      case 'workshop':
        return const Color(0xFFDCEEFE);
      case 'hackathon':
        return const Color(0xFFF3E8FF);
      case 'seminar':
        return const Color(0xFFD1FAE5);
      case 'networking':
        return const Color(0xFFFFEDD5);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  void _showRegistrationModal(Event event) {
    showDialog(
      context: context,
      builder: (context) => EventRegistrationModal(event: event),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 48, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tech Events',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Discover and register for upcoming tech events',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Search and Filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Search Bar
                  TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search events...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF9CA3AF),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFF3B82F6),
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Filter Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.filter_list,
                        color: Color(0xFF9CA3AF),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFF3B82F6),
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All Types')),
                      DropdownMenuItem(
                        value: 'workshop',
                        child: Text('Workshop'),
                      ),
                      DropdownMenuItem(
                        value: 'hackathon',
                        child: Text('Hackathon'),
                      ),
                      DropdownMenuItem(
                        value: 'seminar',
                        child: Text('Seminar'),
                      ),
                      DropdownMenuItem(
                        value: 'networking',
                        child: Text('Networking'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value ?? 'all';
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Events List
            Expanded(
              child: _filteredEvents.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: _filteredEvents.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildEventCard(_filteredEvents[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    final isEventFull = event.registered >= event.capacity;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
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
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.network(
              event.imageUrl,
              height: 192,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 192,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported, size: 48),
                );
              },
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type Badge and Capacity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getTypeBackgroundColor(event.type),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        event.type[0].toUpperCase() + event.type.substring(1),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getTypeColor(event.type),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.people,
                          size: 16,
                          color: Color(0xFF6B7280),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${event.registered}/${event.capacity}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Title
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  event.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 16),

                // Event Details
                Column(
                  children: [
                    _buildDetailRow(
                      Icons.calendar_today,
                      _formatDate(event.date),
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow(Icons.access_time, event.time),
                    const SizedBox(height: 8),
                    _buildDetailRow(Icons.location_on, event.location),
                  ],
                ),
                const SizedBox(height: 16),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: isEventFull
                        ? null
                        : () => _showRegistrationModal(event),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEventFull
                          ? const Color(0xFFD1D5DB)
                          : const Color(0xFF3B82F6),
                      foregroundColor: isEventFull
                          ? const Color(0xFF6B7280)
                          : Colors.white,
                      disabledBackgroundColor: const Color(0xFFD1D5DB),
                      disabledForegroundColor: const Color(0xFF6B7280),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isEventFull ? 'Event Full' : 'Register Now',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF6B7280)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No events found matching your criteria',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Mock Data
final mockEvents = [
  Event(
      id: '1',
      title: 'AI & Machine Learning Workshop',
      type: 'workshop',
      date: '2025-01-15',
      time: '10:00 AM - 4:00 PM',
      location: 'Computer Lab A',
      description: 'Learn the fundamentals of AI and ML with hands-on projects',
      imageUrl:
          'https://images.unsplash.com/photo-1555255707-c07966088b7b?w=800&q=80',
    )
    ..capacity = 50
    ..registered = 32
    ..organizer = 'CS Department',
  Event(
      id: '2',
      title: 'Annual Hackathon 2025',
      type: 'hackathon',
      date: '2025-01-20',
      time: '9:00 AM - 9:00 PM',
      location: 'Main Auditorium',
      description: '24-hour coding challenge with prizes worth \$10,000',
      imageUrl:
          'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=800&q=80',
    )
    ..capacity = 100
    ..registered = 78
    ..organizer = 'Tech Club',
  Event(
      id: '3',
      title: 'Web Development Bootcamp',
      type: 'workshop',
      date: '2025-01-18',
      time: '2:00 PM - 6:00 PM',
      location: 'Online',
      description: 'Master React, Node.js, and modern web technologies',
      imageUrl:
          'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=800&q=80',
    )
    ..capacity = 80
    ..registered = 45
    ..organizer = 'Code Academy',
  Event(
      id: '4',
      title: 'Tech Career Fair',
      type: 'networking',
      date: '2025-01-25',
      time: '11:00 AM - 5:00 PM',
      location: 'Student Center',
      description: 'Meet recruiters from top tech companies',
      imageUrl:
          'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&q=80',
    )
    ..capacity = 200
    ..registered = 156
    ..organizer = 'Career Services',
  Event(
      id: '5',
      title: 'Cybersecurity Seminar',
      type: 'seminar',
      date: '2025-01-22',
      time: '3:00 PM - 5:00 PM',
      location: 'Lecture Hall B',
      description:
          'Learn about the latest security threats and defense strategies',
      imageUrl:
          'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=800&q=80',
    )
    ..capacity = 60
    ..registered = 28
    ..organizer = 'InfoSec Society',
  Event(
      id: '6',
      title: 'Cloud Computing Summit',
      type: 'seminar',
      date: '2025-01-28',
      time: '1:00 PM - 4:00 PM',
      location: 'Conference Room',
      description: 'Explore AWS, Azure, and Google Cloud Platform',
      imageUrl:
          'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800&q=80',
    )
    ..capacity = 40
    ..registered = 35
    ..organizer = 'Cloud Computing Club',
];

// Extended Event Model with additional properties
extension EventExtension on Event {
  set capacity(int value) => _capacity = value;
  set registered(int value) => _registered = value;
  set organizer(String value) => _organizer = value;

  int get capacity => _capacity;
  int get registered => _registered;
  String get organizer => _organizer;
}

int _capacity = 0;
int _registered = 0;
String _organizer = '';
