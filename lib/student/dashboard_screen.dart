import 'dart:async';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  final void Function(int index) onNavigate;

  const DashboardScreen({Key? key, required this.onNavigate}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _pageController = PageController();
  int _currentSlide = 0;
  bool _showNotification = false;
  Timer? _timer;

  final List<Map<String, dynamic>> eventSlides = [
    {
      'title': 'Flutter Workshop',
      'date': 'Dec 20, 2025',
      'time': '2:00 PM',
      'location': 'Room 301',
      'attendees': '45',
      'description': 'Master Flutter development with hands-on projects',
      'image': 'https://images.unsplash.com/photo-1761250246894-ee2314939662',
      'gradient': [Color(0xFF3B82F6), Color(0xFF7C3AED)],
    },
    {
      'title': 'Web Dev Bootcamp',
      'date': 'Dec 22, 2025',
      'time': '10:00 AM',
      'location': 'Lab A',
      'attendees': '30',
      'description': 'Build modern web apps with React & Node.js',
      'image': 'https://images.unsplash.com/photo-1763568258320-c954a19683e3',
      'gradient': [Color(0xFF10B981), Color(0xFF06B6D4)],
    },
    {
      'title': 'Hackathon 2025',
      'date': 'Dec 25, 2025',
      'time': '9:00 AM',
      'location': 'Main Hall',
      'attendees': '100+',
      'description': 'Code, compete, and win amazing prizes!',
      'image': 'https://images.unsplash.com/photo-1649451844813-3130d6f42f8a',
      'gradient': [Color(0xFFF97316), Color(0xFFEF4444)],
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      _currentSlide = (_currentSlide + 1) % eventSlides.length;
      _pageController.animateToPage(
        _currentSlide,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      CircleAvatar(radius: 24, child: Icon(Icons.school)),
                      SizedBox(width: 12),
                      Text(
                        'CS Student Hub',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {
                      setState(() {
                        _showNotification = !_showNotification;
                      });
                    },
                  ),
                ],
              ),

              if (_showNotification) ...[
                const SizedBox(height: 16),
                _buildNotificationCard(),
              ],

              const SizedBox(height: 24),

              // SLIDESHOW
              SizedBox(
                height: 260,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentSlide = index);
                  },
                  itemCount: eventSlides.length,
                  itemBuilder: (context, index) {
                    final slide = eventSlides[index];
                    return _buildEventSlide(slide);
                  },
                ),
              ),

              const SizedBox(height: 24),

              // PROJECTS
              _buildProjectsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Welcome back, Student !',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text('You have 2 upcoming events'),
        ],
      ),
    );
  }

  Widget _buildEventSlide(Map<String, dynamic> slide) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: NetworkImage(slide['image']),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: slide['gradient'],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              slide['title'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              slide['description'],
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Latest Projects',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => widget.onNavigate(2),
              child: const Text('See all'),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Text('E-Commerce App'),
        ),
      ],
    );
  }
}
