import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Color(0xFF7C3AED)), // violet
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildProfileCard(context),
              const SizedBox(height: 24),
              _buildPersonalInfo(),
              const SizedBox(height: 24),
              _buildSkillsSection(),
              const SizedBox(height: 24),
              _buildAchievements(),
              const SizedBox(height: 24),
              _buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Profile',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Manage your account and preferences',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF7C3AED)], // blue → violet
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'John Doe',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Computer Science Student',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFDCEEFE),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, size: 20, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildStatCard('12', 'Events')),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('8', 'Projects')),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('5', 'Certificates')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            ' ',
            style: TextStyle(fontSize: 12, color: Color(0xFFDCEEFE)),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFFDCEEFE)),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo() {
    return _infoContainer(
      children: [
        _buildInfoItem(
          Icons.email_outlined,
          'Email',
          'john.doe@university.edu',
          const Color(0xFF3B82F6),
          const Color(0xFFDCEEFE),
        ),
        _buildInfoItem(
          Icons.phone_outlined,
          'Phone',
          '+1 (555) 123-4567',
          const Color(0xFF7C3AED),
          const Color(0xFFF3E8FF),
        ),
        _buildInfoItem(
          Icons.location_on_outlined,
          'Location',
          'San Francisco, CA',
          const Color(0xFF3B82F6),
          const Color(0xFFDCEEFE),
        ),
        _buildInfoItem(
          Icons.calendar_today_outlined,
          'Member Since',
          'January 2024',
          const Color(0xFF7C3AED),
          const Color(0xFFF3E8FF),
        ),
      ],
      title: 'Personal Information',
    );
  }

  Widget _buildSkillsSection() {
    final skills = [
      {
        'name': 'React',
        'color': const Color(0xFF3B82F6),
        'bg': const Color(0xFFDCEEFE),
      },
      {
        'name': 'Node.js',
        'color': const Color(0xFF7C3AED),
        'bg': const Color(0xFFF3E8FF),
      },
      {
        'name': 'Python',
        'color': const Color(0xFF3B82F6),
        'bg': const Color(0xFFDCEEFE),
      },
      {
        'name': 'Machine Learning',
        'color': const Color(0xFF7C3AED),
        'bg': const Color(0xFFF3E8FF),
      },
      {
        'name': 'UI/UX Design',
        'color': const Color(0xFF3B82F6),
        'bg': const Color(0xFFDCEEFE),
      },
      {
        'name': 'Cloud Computing',
        'color': const Color(0xFF7C3AED),
        'bg': const Color(0xFFF3E8FF),
      },
    ];

    return _infoContainer(
      title: 'Skills & Interests',
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills.map((skill) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: skill['bg'] as Color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                skill['name'] as String,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: skill['color'] as Color,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAchievements() {
    return _infoContainer(
      title: 'Recent Achievements',
      children: [
        _buildAchievementItem(
          Icons.emoji_events,
          'Hackathon Winner',
          'Annual Hackathon 2025',
          const LinearGradient(colors: [Color(0xFFDCEEFE), Color(0xFFF3E8FF)]),
          const Color(0xFF3B82F6),
        ),
        _buildAchievementItem(
          Icons.code,
          'Project Showcase',
          'Featured Developer',
          const LinearGradient(colors: [Color(0xFFDCEEFE), Color(0xFFE0E7FF)]),
          const Color(0xFF3B82F6),
        ),
        _buildAchievementItem(
          Icons.emoji_events,
          'Course Completion',
          'AI & ML Workshop',
          const LinearGradient(colors: [Color(0xFFF3E8FF), Color(0xFFE0E7FF)]),
          const Color(0xFF7C3AED),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)], // violet only
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: () => _handleLogout(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoContainer({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String label,
    String value,
    Color iconColor,
    Color bgColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(
    IconData icon,
    String title,
    String subtitle,
    LinearGradient gradient,
    Color iconColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 32, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
