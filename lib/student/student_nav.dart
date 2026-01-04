import 'package:flutter/material.dart';

class StudentNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onNavigate;

  const StudentNav({
    Key? key,
    required this.currentIndex,
    required this.onNavigate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onNavigate,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF3B82F6), // blue
      unselectedItemColor: Colors.grey,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Events',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Projects'),
      ],
    );
  }
}
