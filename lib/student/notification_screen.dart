import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsScreen extends StatefulWidget {
  final String role; // 'student' or 'professor'
  final VoidCallback onBack;
  final Function(String) onNavigate;

  const NotificationsScreen({
    Key? key,
    required this.role,
    required this.onBack,
    required this.onNavigate,
  }) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  List<NotificationItem> _notifications = [];
  bool _isLoading = true;
  int _todayEvents = 0;
  int _todayBadges = 0;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _loadTodaySummary();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload notifications every time this screen is opened
    _loadNotifications();
    _loadTodaySummary();
  }

  Future<void> _loadNotifications() async {
    if (_currentUser == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final notificationsSnapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where('userId', isEqualTo: _currentUser.uid)
          .orderBy('createdAt', descending: true)
          .limit(20)
          .get();

      final notifications = notificationsSnapshot.docs.map((doc) {
        final data = doc.data();
        final timestamp = data['createdAt'] as Timestamp?;
        return NotificationItem(
          id: doc.id,
          type: data['type'] ?? 'general',
          title: data['title'] ?? 'Notification',
          description: data['description'] ?? '',
          time: _formatTime(timestamp),
          unread: data['unread'] ?? true,
        );
      }).toList();

      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading notifications: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadTodaySummary() async {
    if (_currentUser == null) return;

    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final todayTimestamp = Timestamp.fromDate(today);

      if (widget.role == 'student') {
        // Count upcoming events student is registered for
        final eventsSnapshot = await FirebaseFirestore.instance
            .collection('events')
            .where('status', isEqualTo: 'active')
            .get();

        int upcomingEvents = 0;
        for (var eventDoc in eventsSnapshot.docs) {
          final registrationDoc = await FirebaseFirestore.instance
              .collection('events')
              .doc(eventDoc.id)
              .collection('registrations')
              .doc(_currentUser.uid)
              .get();

          if (registrationDoc.exists) {
            upcomingEvents++;
          }
        }

        setState(() {
          _todayEvents = upcomingEvents;
          _todayBadges = 5; // Can be calculated from achievements
        });
      } else {
        // Count new registrations today for professor
        final eventsSnapshot = await FirebaseFirestore.instance
            .collection('events')
            .where('createdBy', isEqualTo: _currentUser.uid)
            .get();

        int newRegistrations = 0;
        int activeEvents = 0;

        for (var eventDoc in eventsSnapshot.docs) {
          final eventData = eventDoc.data();
          if (eventData['status'] == 'active') {
            activeEvents++;
          }

          final registrationsSnapshot = await FirebaseFirestore.instance
              .collection('events')
              .doc(eventDoc.id)
              .collection('registrations')
              .where('registeredAt', isGreaterThanOrEqualTo: todayTimestamp)
              .get();

          newRegistrations += registrationsSnapshot.docs.length;
        }

        setState(() {
          _todayEvents = newRegistrations;
          _todayBadges = activeEvents;
        });
      }
    } catch (e) {
      print('Error loading summary: $e');
    }
  }

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return 'Recently';

    final now = DateTime.now();
    final date = timestamp.toDate();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} mins ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  Future<void> _markAllAsRead() async {
    if (_currentUser == null) return;

    try {
      final batch = FirebaseFirestore.instance.batch();

      for (var notif in _notifications.where((n) => n.unread)) {
        final docRef = FirebaseFirestore.instance
            .collection('notifications')
            .doc(notif.id);
        batch.update(docRef, {'unread': false});
      }

      await batch.commit();

      setState(() {
        _notifications = _notifications.map((n) {
          return NotificationItem(
            id: n.id,
            type: n.type,
            title: n.title,
            description: n.description,
            time: n.time,
            unread: false,
          );
        }).toList();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All notifications marked as read'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
      }
    } catch (e) {
      print('Error marking as read: $e');
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notificationId)
          .update({'unread': false});

      setState(() {
        _notifications = _notifications.map((n) {
          if (n.id == notificationId) {
            return NotificationItem(
              id: n.id,
              type: n.type,
              title: n.title,
              description: n.description,
              time: n.time,
              unread: false,
            );
          }
          return n;
        }).toList();
      });
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isStudent = widget.role == 'student';
    final gradientColors = isStudent
        ? [const Color(0xFF3B82F6), const Color(0xFF9333EA)]
        : [const Color(0xFFA855F7), const Color(0xFF6366F1)];
    final bgColor = isStudent
        ? const Color(0xFFEFF6FF)
        : const Color(0xFFF3E8FF);
    final accentColor = isStudent
        ? const Color(0xFF3B82F6)
        : const Color(0xFFA855F7);

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColors),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: widget.onBack,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Notifications',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isStudent
                          ? 'Stay updated on your learning journey'
                          : 'Track your event performance and engagement',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -24),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: () async {
                          await _loadNotifications();
                          await _loadTodaySummary();
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Summary Card
                              _buildSummaryCard(isStudent, accentColor),
                              const SizedBox(height: 32),

                              // Notifications List
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Recent Activity',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF111827),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: _markAllAsRead,
                                    child: Text(
                                      'Mark all as read',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: accentColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              if (_notifications.isEmpty)
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(48),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.notifications_off,
                                          size: 64,
                                          color: Colors.grey[300],
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No notifications yet',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              else
                                ..._notifications.map((notif) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: _buildNotificationCard(
                                      notif,
                                      isStudent,
                                    ),
                                  );
                                }),

                              // Archive Button
                              if (_notifications.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Color(0xFFE5E7EB),
                                      width: 2,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'View Notification Archive',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF9CA3AF),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(bool isStudent, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.track_changes, size: 16, color: accentColor),
              const SizedBox(width: 8),
              Text(
                'TODAY\'S SUMMARY',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isStudent ? 'Events' : 'Registrations',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            isStudent ? '$_todayEvents' : '+$_todayEvents',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isStudent
                                  ? const Color(0xFFDCEEFE)
                                  : const Color(0xFFD1FAE5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              isStudent ? 'Upcoming' : 'New',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isStudent
                                    ? const Color(0xFF3B82F6)
                                    : const Color(0xFF10B981),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isStudent ? 'Badges' : 'Active Events',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '$_todayBadges',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3E8FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFA855F7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notif, bool isStudent) {
    return InkWell(
      onTap: () {
        if (notif.unread) {
          _markAsRead(notif.id);
        }
        _handleNotificationClick(notif);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notif.unread
              ? const Color(0xFFEFF6FF).withOpacity(0.3)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notif.unread
                ? const Color(0xFFDCEEFE)
                : const Color(0xFFF3F4F6),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getIconBgColor(notif.type),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getIconData(notif.type),
                size: 20,
                color: _getIconColor(notif.type),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notif.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: notif.unread
                                ? const Color(0xFF111827)
                                : const Color(0xFF6B7280),
                          ),
                        ),
                      ),
                      if (notif.unread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF3B82F6),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notif.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 10,
                        color: Color(0xFF9CA3AF),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        notif.time,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF9CA3AF),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String type) {
    switch (type) {
      case 'event':
        return Icons.calendar_today;
      case 'achievement':
        return Icons.emoji_events;
      case 'feedback':
        return Icons.message;
      case 'milestone':
        return Icons.trending_up;
      case 'registration':
        return Icons.people;
      case 'deadline':
        return Icons.error_outline;
      case 'project':
        return Icons.code;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconBgColor(String type) {
    switch (type) {
      case 'achievement':
        return const Color(0xFFFEF3C7);
      case 'event':
        return const Color(0xFFDCEEFE);
      case 'feedback':
        return const Color(0xFFD1FAE5);
      case 'milestone':
        return const Color(0xFFF3E8FF);
      case 'registration':
        return const Color(0xFFE0E7FF);
      case 'deadline':
        return const Color(0xFFFEE2E2);
      case 'project':
        return const Color(0xFFFEF3C7);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'achievement':
        return const Color(0xFFD97706);
      case 'event':
        return const Color(0xFF3B82F6);
      case 'feedback':
        return const Color(0xFF10B981);
      case 'milestone':
        return const Color(0xFFA855F7);
      case 'registration':
        return const Color(0xFF6366F1);
      case 'deadline':
        return const Color(0xFFEF4444);
      case 'project':
        return const Color(0xFFD97706);
      default:
        return const Color(0xFF6B7280);
    }
  }

  void _handleNotificationClick(NotificationItem notif) {
    final isStudent = widget.role == 'student';

    if (isStudent) {
      switch (notif.type) {
        case 'event':
          widget.onNavigate('events');
          break;
        case 'achievement':
          widget.onNavigate('certificates');
          break;
        case 'feedback':
        case 'project':
          widget.onNavigate('projects');
          break;
        default:
          widget.onBack();
      }
    } else {
      switch (notif.type) {
        case 'registration':
        case 'deadline':
          widget.onNavigate('events');
          break;
        case 'milestone':
        case 'feedback':
          widget.onNavigate('dashboard');
          break;
        default:
          widget.onBack();
      }
    }
  }
}

class NotificationItem {
  final String id;
  final String type;
  final String title;
  final String description;
  final String time;
  final bool unread;

  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.time,
    required this.unread,
  });
}
