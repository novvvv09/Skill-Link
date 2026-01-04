import 'package:flutter/material.dart';

class ProfessorProfileScreen extends StatelessWidget {
  final VoidCallback onLogout;

  const ProfessorProfileScreen({Key? key, required this.onLogout})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final professor = {
      'name': ' Erica Sinclair',
      'title': 'Associate Professor',
      'department': 'Computer Science',
      'email': 'e.sinclair.114567.tc@umindanao.edu.ph',
      'phone': '+1 (555) 123-4567',
      'office': 'CS Building, Room AVR',
      'joinDate': 'September 2025',
      'totalEvents': 24,
      'activeEvents': 10,
      'totalStudents': 156,
    };

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
                      'Profile',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage your account settings',
                      style: TextStyle(fontSize: 14, color: Colors.purple[100]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Profile Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFF3F4F6)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Profile Header
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar with online indicator
                        Stack(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/logo.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[200],
                                      child: const Icon(
                                        Icons.person,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // Name and Title
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                professor['name'] as String,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                professor['title'] as String,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFA855F7),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                professor['department'] as String,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Stats Grid
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3E8FF),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '${professor['totalEvents']}',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFA855F7),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Events Created',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0E7FF),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '${professor['activeEvents']}',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6366F1),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Active Events',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCEEFE),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '${professor['totalStudents']}',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3B82F6),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Total Students',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Contact Information
                    _buildContactItem(
                      Icons.email,
                      'Email',
                      professor['email'] as String,
                      const Color(0xFFA855F7),
                    ),
                    const SizedBox(height: 12),
                    _buildContactItem(
                      Icons.phone,
                      'Phone',
                      professor['phone'] as String,
                      const Color(0xFFA855F7),
                    ),
                    const SizedBox(height: 12),
                    _buildContactItem(
                      Icons.business,
                      'Office',
                      professor['office'] as String,
                      const Color(0xFFA855F7),
                    ),
                    const SizedBox(height: 12),
                    _buildContactItem(
                      Icons.calendar_today,
                      'Member Since',
                      professor['joinDate'] as String,
                      const Color(0xFFA855F7),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Settings Menu
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
                    _buildSettingsItem(
                      Icons.person,
                      'Edit Profile',
                      const Color(0xFFDCEEFE),
                      const Color(0xFF3B82F6),
                    ),
                    const Divider(height: 1, color: Color(0xFFF3F4F6)),
                    _buildSettingsItem(
                      Icons.notifications,
                      'Notifications',
                      const Color(0xFFDCEEFE),
                      const Color(0xFF3B82F6),
                    ),
                    const Divider(height: 1, color: Color(0xFFF3F4F6)),
                    _buildSettingsItem(
                      Icons.lock,
                      'Privacy & Security',
                      const Color(0xFFDCEEFE),
                      const Color(0xFF3B82F6),
                    ),
                    const Divider(height: 1, color: Color(0xFFF3F4F6)),
                    _buildSettingsItem(
                      Icons.emoji_events,
                      'Achievements',
                      const Color(0xFFDCEEFE),
                      const Color(0xFF3B82F6),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Logout Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onLogout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFEE2E2),
                    foregroundColor: const Color(0xFFEF4444),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // App Info
              const Column(
                children: [
                  Text(
                    'SkillLink v1.0.0',
                    style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '© 2025 CS Professor Hub. All rights reserved.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(
    IconData icon,
    String label,
    String value,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF111827),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    IconData icon,
    String title,
    Color bgColor,
    Color iconColor,
  ) {
    return InkWell(
      onTap: () {
        // Handle settings navigation
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF111827),
                ),
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }
}
