import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatefulWidget {
  final Function(String) onSelectRole;

  const RoleSelectionScreen({Key? key, required this.onSelectRole})
    : super(key: key);

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _titleController;
  late AnimationController _studentController;
  late AnimationController _professorController;
  late AnimationController _footerController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _titleSlide;
  late Animation<double> _titleOpacity;
  late Animation<Offset> _studentSlide;
  late Animation<double> _studentOpacity;
  late Animation<Offset> _professorSlide;
  late Animation<double> _professorOpacity;
  late Animation<double> _footerOpacity;

  @override
  void initState() {
    super.initState();

    // Logo animation
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _logoScale = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(_logoController);

    // Title animation
    _titleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _titleController, curve: Curves.easeOut));
    _titleOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_titleController);

    // Student card animation
    _studentController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _studentSlide =
        Tween<Offset>(begin: const Offset(-0.2, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: _studentController, curve: Curves.easeOut),
        );
    _studentOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_studentController);

    // Professor card animation
    _professorController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _professorSlide =
        Tween<Offset>(begin: const Offset(0.2, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: _professorController, curve: Curves.easeOut),
        );
    _professorOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_professorController);

    // Footer animation
    _footerController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _footerOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_footerController);

    // Start animations in sequence
    _startAnimations();
  }

  void _startAnimations() async {
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _titleController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _studentController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _professorController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _footerController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _titleController.dispose();
    _studentController.dispose();
    _professorController.dispose();
    _footerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 812,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEFF6FF), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                ScaleTransition(
                  scale: _logoScale,
                  child: FadeTransition(
                    opacity: _logoOpacity,
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(48),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(48),
                        child: Image.asset(
                          'logo.png', // Replace with your logo asset
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                SlideTransition(
                  position: _titleSlide,
                  child: FadeTransition(
                    opacity: _titleOpacity,
                    child: Column(
                      children: [
                        const Text(
                          'Welcome to SkillLink',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Choose your role to continue',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                // Role Cards
                Column(
                  children: [
                    // Student Card
                    SlideTransition(
                      position: _studentSlide,
                      child: FadeTransition(
                        opacity: _studentOpacity,
                        child: _RoleCard(
                          title: "I'm a Student",
                          subtitle: 'Access events, projects, and certificates',
                          icon: Icons.school,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                          ),
                          borderColor: const Color(0xFF3B82F6),
                          onTap: () => widget.onSelectRole('student'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Professor Card
                    SlideTransition(
                      position: _professorSlide,
                      child: FadeTransition(
                        opacity: _professorOpacity,
                        child: _RoleCard(
                          title: "I'm a Professor",
                          subtitle: 'Manage events and student activities',
                          icon: Icons.people,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFA855F7), Color(0xFF9333EA)],
                          ),
                          borderColor: const Color(0xFFA855F7),
                          onTap: () => widget.onSelectRole('professor'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),

                // Footer
                FadeTransition(
                  opacity: _footerOpacity,
                  child: const Text(
                    'By continuing, you agree to our Terms of Service and Privacy Policy',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final Color borderColor;
  final VoidCallback onTap;

  const _RoleCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.borderColor,
    required this.onTap,
  }) : super(key: key);

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _scaleController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered ? widget.borderColor : const Color(0xFFF3F4F6),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 1.0, end: _isHovered ? 1.1 : 1.0),
                duration: const Duration(milliseconds: 200),
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: widget.gradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(widget.icon, color: Colors.white, size: 32),
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
