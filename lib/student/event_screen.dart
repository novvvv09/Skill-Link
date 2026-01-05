import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'event_registration_modal.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  String _searchQuery = '';
  String _selectedType = 'all';
  bool _isLoading = true;
  List<Map<String, dynamic>> _events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() => _isLoading = true);

    try {
      // Fetch all active events from Firestore
      QuerySnapshot eventSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .orderBy('date', descending: false)
          .get();

      List<Map<String, dynamic>> events = [];

      for (var doc in eventSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        events.add({
          'id': doc.id,
          'title': data['title'] ?? 'Untitled Event',
          'description': data['description'] ?? 'No description',
          'category': data['category'] ?? 'workshop',
          'date': data['date'] ?? '',
          'time': data['time'] ?? '',
          'location': data['location'] ?? 'TBD',
          'capacity': data['capacity'] ?? 50,
          'registeredCount': data['registeredCount'] ?? 0,
          'professorName': data['professorName'] ?? 'Unknown',
          'createdBy': data['createdBy'] ?? '',
          'imageUrl':
              data['imageUrl'] ??
              'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&q=80',
        });
      }

      setState(() {
        _events = events;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading events: $e');
      setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> get _filteredEvents {
    return _events.where((event) {
      final matchesSearch =
          event['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event['description'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
      final matchesType =
          _selectedType == 'all' || event['category'] == _selectedType;
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

  void _showRegistrationModal(Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => EventRegistrationDialog(
        event: event,
        onRegistered: () {
          // Reload events after registration
          _loadEvents();
        },
      ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tech Events',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Discover and register for upcoming events',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _loadEvents,
                        color: const Color(0xFF3B82F6),
                      ),
                    ],
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredEvents.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _loadEvents,
                      child: ListView.builder(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    final int registered = event['registeredCount'] ?? 0;
    final int capacity = event['capacity'] ?? 50;
    final isEventFull = registered >= capacity;

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
              event['imageUrl'] ??
                  'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&q=80',
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
                        color: _getTypeBackgroundColor(event['category']),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        event['category'][0].toUpperCase() +
                            event['category'].substring(1),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getTypeColor(event['category']),
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
                          '$registered/$capacity',
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
                  event['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 8),

                // Professor Name
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 16,
                      color: Color(0xFFA855F7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'By ${event['professorName']}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFFA855F7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  event['description'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),

                // Event Details
                Column(
                  children: [
                    _buildDetailRow(
                      Icons.calendar_today,
                      _formatDate(event['date']),
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow(Icons.access_time, event['time']),
                    const SizedBox(height: 8),
                    _buildDetailRow(Icons.location_on, event['location']),
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
            _searchQuery.isNotEmpty || _selectedType != 'all'
                ? 'No events found matching your criteria'
                : 'No events available yet',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          if (_searchQuery.isEmpty && _selectedType == 'all') ...[
            const SizedBox(height: 8),
            Text(
              'Check back later for upcoming events',
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return 'TBD';

    try {
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
    } catch (e) {
      return dateString;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Registration Dialog
class EventRegistrationDialog extends StatelessWidget {
  final Map<String, dynamic> event;
  final VoidCallback onRegistered;

  const EventRegistrationDialog({
    Key? key,
    required this.event,
    required this.onRegistered,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Register for Event'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Do you want to register for "${event['title']}"?'),
          const SizedBox(height: 16),
          Text(
            'Event by: ${event['professorName']}',
            style: const TextStyle(
              color: Color(0xFFA855F7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            await _registerForEvent(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B82F6),
          ),
          child: const Text('Register'),
        ),
      ],
    );
  }

  Future<void> _registerForEvent(BuildContext context) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You must be logged in to register'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    try {
      // Check if already registered
      DocumentSnapshot regCheck = await FirebaseFirestore.instance
          .collection('events')
          .doc(event['id'])
          .collection('registrations')
          .doc(currentUser.uid)
          .get();

      if (regCheck.exists) {
        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You are already registered for this event'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // Get student info
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

      // Register student
      await FirebaseFirestore.instance
          .collection('events')
          .doc(event['id'])
          .collection('registrations')
          .doc(currentUser.uid)
          .set({
            'studentId': currentUser.uid,
            'studentName': userData?['fullName'] ?? 'Unknown Student',
            'studentEmail': userData?['email'] ?? currentUser.email,
            'registeredAt': FieldValue.serverTimestamp(),
          });

      // Update registered count
      await FirebaseFirestore.instance
          .collection('events')
          .doc(event['id'])
          .update({'registeredCount': FieldValue.increment(1)});

      // Update student's event count
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({'stats.eventsAttended': FieldValue.increment(1)});

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully registered for event!'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        onRegistered();
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
