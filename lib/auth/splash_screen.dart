import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SplashScreen({super.key, required this.onComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _dotsController;

  final String _text = "SkillLink";

  @override
  void initState() {
    super.initState();

    // Logo animation controller
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();

    // Loading dots controller
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    // Navigate after splash duration
    Timer(const Duration(milliseconds: 3500), widget.onComplete);
  }

  Widget _buildAnimatedLetter(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + (index * 100)),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1 - value) * 20),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Text(
        _text[index],
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF3B82F6), // blue-500
              Color(0xFF2563EB), // blue-600
              Color(0xFF7C3AED), // purple-600
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Logo
            ScaleTransition(
              scale: CurvedAnimation(
                parent: _logoController,
                curve: Curves.elasticOut,
              ),
              child: RotationTransition(
                turns: Tween<double>(
                  begin: -0.5,
                  end: 0,
                ).animate(_logoController),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 32),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'logo.png', // <-- register in pubspec.yaml
                      width: 128,
                      height: 128,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            // Animated Text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_text.length, (index) {
                return _buildAnimatedLetter(index);
              }),
            ),

            const SizedBox(height: 16),

            // Tagline
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 800),
              builder: (context, value, child) {
                return Opacity(opacity: value, child: child);
              },
              child: const Text(
                "Connect. Learn. Grow.",
                style: TextStyle(
                  color: Color(0xFFBFDBFE),
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Loading Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _dotsController,
                  builder: (context, child) {
                    final double value =
                        (_dotsController.value + index * 0.2) % 1;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(
                          0.5 + (0.5 * (1 - value)),
                        ),
                        shape: BoxShape.circle,
                      ),
                      transform: Matrix4.identity()..scale(1 + value * 0.5),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
