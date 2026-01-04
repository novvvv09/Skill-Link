import 'package:flutter/material.dart';

class ProfessorBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavigate;

  const ProfessorBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onNavigate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Dashboard
            _buildNavItem(
              icon: Icons.dashboard,
              label: 'Dashboard',
              index: 0,
              isActive: currentIndex == 0,
              onTap: () => onNavigate(0),
            ),

            // My Events
            _buildNavItem(
              icon: Icons.calendar_today,
              label: 'My Events',
              index: 1,
              isActive: currentIndex == 1,
              onTap: () => onNavigate(1),
            ),

            // Create Event (Now aligned with other icons)
            _buildNavItem(
              icon: Icons.add_circle,
              label: 'Create',
              index: 2,
              isActive: currentIndex == 2,
              onTap: () => onNavigate(2),
              isPrimary: true, // Special styling for create button
            ),

            // Profile
            _buildNavItem(
              icon: Icons.person,
              label: 'Profile',
              index: 3,
              isActive: currentIndex == 3,
              onTap: () => onNavigate(3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isActive,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    final color = isActive ? const Color(0xFFA855F7) : const Color(0xFF9CA3AF);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isPrimary ? 28 : 24, // Slightly larger for create button
              color: isPrimary ? const Color(0xFFA855F7) : color,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isPrimary ? const Color(0xFFA855F7) : color,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
