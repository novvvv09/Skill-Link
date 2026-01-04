import 'package:flutter/material.dart';

/// ------------------------------
/// Event Model
/// ------------------------------
class Event {
  final String id;
  final String title;
  final String type;
  final String date;
  final String time;
  final String location;
  final int capacity;
  final int registered;
  final String description;
  final String organizer;
  final String imageUrl;

  Event({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.time,
    required this.location,
    required this.capacity,
    required this.registered,
    required this.description,
    required this.organizer,
    required this.imageUrl,
  });
}

/// ------------------------------
/// Mock Data (same as TSX)
/// ------------------------------
final List<Event> mockEvents = [
  Event(
    id: '1',
    title: 'AI & Machine Learning Workshop',
    type: 'workshop',
    date: '2025-01-15',
    time: '10:00 AM - 4:00 PM',
    location: 'Computer Lab A',
    capacity: 50,
    registered: 32,
    description: 'Learn the fundamentals of AI and ML with hands-on projects',
    organizer: 'CS Department',
    imageUrl:
        'https://images.unsplash.com/photo-1555255707-c07966088b7b?w=800&q=80',
  ),
  Event(
    id: '2',
    title: 'Annual Hackathon 2025',
    type: 'hackathon',
    date: '2025-01-20',
    time: '9:00 AM - 9:00 PM',
    location: 'Main Auditorium',
    capacity: 100,
    registered: 78,
    description: '24-hour coding challenge with prizes worth \$10,000',
    organizer: 'Tech Club',
    imageUrl:
        'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=800&q=80',
  ),
  Event(
    id: '3',
    title: 'Web Development Bootcamp',
    type: 'workshop',
    date: '2025-01-18',
    time: '2:00 PM - 6:00 PM',
    location: 'Online',
    capacity: 80,
    registered: 45,
    description: 'Master React, Node.js, and modern web technologies',
    organizer: 'Code Academy',
    imageUrl:
        'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=800&q=80',
  ),
];

/// ------------------------------
/// Events Page (Stateful)
/// ------------------------------
class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  String searchQuery = '';
  String selectedType = 'all';
  Event? selectedEvent;

  List<Event> get filteredEvents {
    return mockEvents.where((event) {
      final matchesSearch =
          event.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          event.description.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesType = selectedType == 'all' || event.type == selectedType;

      return matchesSearch && matchesType;
    }).toList();
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'workshop':
        return Colors.blue.shade100;
      case 'hackathon':
        return Colors.purple.shade100;
      case 'seminar':
        return Colors.green.shade100;
      case 'networking':
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Color _typeTextColor(String type) {
    switch (type) {
      case 'workshop':
        return Colors.blue.shade700;
      case 'hackathon':
        return Colors.purple.shade700;
      case 'seminar':
        return Colors.green.shade700;
      case 'networking':
        return Colors.orange.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tech Events')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// ------------------------------
            /// Search Field
            /// ------------------------------
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search events...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),

            const SizedBox(height: 12),

            /// ------------------------------
            /// Filter Dropdown
            /// ------------------------------
            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.filter_list),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Types')),
                DropdownMenuItem(value: 'workshop', child: Text('Workshop')),
                DropdownMenuItem(value: 'hackathon', child: Text('Hackathon')),
                DropdownMenuItem(value: 'seminar', child: Text('Seminar')),
                DropdownMenuItem(
                  value: 'networking',
                  child: Text('Networking'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            /// ------------------------------
            /// Event List
            /// ------------------------------
            Expanded(
              child: filteredEvents.isEmpty
                  ? const Center(
                      child: Text(
                        'No events found matching your criteria',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = filteredEvents[index];
                        final isFull = event.registered >= event.capacity;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Event Image
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image.network(
                                  event.imageUrl,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// Type + Capacity
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _typeColor(event.type),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            event.type.toUpperCase(),
                                            style: TextStyle(
                                              color: _typeTextColor(event.type),
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '${event.registered}/${event.capacity}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 8),

                                    /// Title
                                    Text(
                                      event.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    /// Description
                                    Text(
                                      event.description,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    /// Date / Time / Location
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(event.date),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time, size: 16),
                                        const SizedBox(width: 6),
                                        Text(event.time),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on, size: 16),
                                        const SizedBox(width: 6),
                                        Text(event.location),
                                      ],
                                    ),

                                    const SizedBox(height: 16),

                                    /// Register Button
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: isFull
                                            ? null
                                            : () {
                                                setState(() {
                                                  selectedEvent = event;
                                                });
                                              },
                                        child: Text(
                                          isFull ? 'Event Full' : 'Register',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
