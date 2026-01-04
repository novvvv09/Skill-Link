import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log-out'),
        content: const Text('Are you sure you want to log-out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              // Navigate back to splash/login screen
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: const Text(
              'Log-out',
              style: TextStyle(color: Colors.redAccent),
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
              // Header
              _buildHeader(),
              const SizedBox(height: 24),

              // Profile Header Card
              _buildProfileCard(context),
              const SizedBox(height: 24),

              // Personal Information
              _buildPersonalInfo(),
              const SizedBox(height: 24),

              // Settings Menu
              _buildSettingsMenu(),
              const SizedBox(height: 24),

              // Logout Button
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
          colors: [Color(0xFF3B82F6), Color(0xFF9333EA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
          // Profile Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar and Info
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
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
                            'Mike Wheeler',
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
                              color: Color(0xFFBFDBFE),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Edit Button
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.edit, size: 20, color: Colors.white),
                  onPressed: () {
                    // Handle edit
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Stats
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
        color: Colors.white.withOpacity(0.1),
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
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFFBFDBFE)),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoItem(
            Icons.email_outlined,
            'Email',
            'm.wheeler.144257.tc@umindanao.edu.ph',
            const Color(0xFFA855F7),
            const Color(0xFFF3E8FF),
          ),
          const SizedBox(height: 16),
          _buildInfoItem(
            Icons.phone_outlined,
            'Phone',
            '+1 (555) 123-4567',
            const Color(0xFFA855F7),
            const Color(0xFFF3E8FF),
          ),
          const SizedBox(height: 16),
          _buildInfoItem(
            Icons.location_on_outlined,
            'Location',
            'Philippines, Tagum City',
            const Color(0xFFA855F7),
            const Color(0xFFF3E8FF),
          ),
          const SizedBox(height: 16),
          _buildInfoItem(
            Icons.calendar_today_outlined,
            'Member Since',
            'January 2025',
            const Color(0xFFA855F7),
            const Color(0xFFF3E8FF),
          ),
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
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
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
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
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

  Widget _buildSettingsMenu() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFEE2E2), Color(0xFFFEE2E2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEF4444).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => _handleLogout(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.red, size: 20),
            SizedBox(width: 8),
            Text(
              'Log-out',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
