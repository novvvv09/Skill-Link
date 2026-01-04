import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isStudent = role == 'student';

    final notifications = isStudent
        ? _studentNotifications
        : _professorNotifications;
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
                            onPressed: onBack,
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Summary Card
                      _buildSummaryCard(isStudent, accentColor),
                      const SizedBox(height: 32),

                      // Notifications List
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            onPressed: () {},
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

                      ...notifications.asMap().entries.map((entry) {
                        // ignore: unused_local_variable
                        final index = entry.key;
                        final notif = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildNotificationCard(notif, isStudent),
                        );
                      }),

                      // Archive Button
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFFE5E7EB),
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
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
                            isStudent ? '2' : '+20',
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
                            isStudent ? '5' : '3',
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
      onTap: () => _handleNotificationClick(notif),
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
      default:
        return const Color(0xFF6B7280);
    }
  }

  void _handleNotificationClick(NotificationItem notif) {
    final isStudent = role == 'student';

    if (isStudent) {
      switch (notif.type) {
        case 'event':
          onNavigate('events');
          break;
        case 'achievement':
          onNavigate('certificates');
          break;
        case 'feedback':
        case 'project':
          onNavigate('projects');
          break;
        default:
          onBack();
      }
    } else {
      switch (notif.type) {
        case 'registration':
        case 'deadline':
          onNavigate('events');
          break;
        case 'milestone':
        case 'feedback':
          onNavigate('dashboard');
          break;
        default:
          onBack();
      }
    }
  }
}

class NotificationItem {
  final int id;
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

final _studentNotifications = [
  NotificationItem(
    id: 1,
    type: 'achievement',
    title: 'New Achievement Earned!',
    description:
        'Great job! You earned the "React Master" badge for completing the bootcamp.',
    time: '2 hours ago',
    unread: true,
  ),
  NotificationItem(
    id: 2,
    type: 'event',
    title: 'Upcoming Workshop',
    description: 'Reminder: The "AI Workshop" starts in 1 hour in Room 301.',
    time: '1 hour ago',
    unread: true,
  ),
  NotificationItem(
    id: 3,
    type: 'feedback',
    title: 'Project Feedback Received',
    description:
        'Professor Smith left comments on your "Alpha E-commerce" project.',
    time: '5 hours ago',
    unread: false,
  ),
  NotificationItem(
    id: 4,
    type: 'event',
    title: 'Event Update',
    description: 'The "Flutter Workshop" location has been changed to Lab C.',
    time: '1 day ago',
    unread: false,
  ),
];

final _professorNotifications = [
  NotificationItem(
    id: 1,
    type: 'registration',
    title: 'New Event Registrations',
    description: '20 new students registered for the "CS Hackathon 2026".',
    time: '30 mins ago',
    unread: true,
  ),
  NotificationItem(
    id: 2,
    type: 'milestone',
    title: 'Major Milestone Reached!',
    description:
        'Your events have reached 500+ total student attendees this semester.',
    time: '4 hours ago',
    unread: true,
  ),
  NotificationItem(
    id: 3,
    type: 'deadline',
    title: 'Grading Deadline Reminder',
    description:
        'Reminder: Please approve final project submissions by 5 PM today.',
    time: '6 hours ago',
    unread: true,
  ),
  NotificationItem(
    id: 4,
    type: 'feedback',
    title: 'Student Question',
    description:
        'A student asked a question regarding the "Web Dev Bootcamp" requirements.',
    time: '1 day ago',
    unread: false,
  ),
];
