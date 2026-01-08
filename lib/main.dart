import 'package:flutter/material.dart';

void main() {
  runApp(const SkillLinkApp());
}

class SkillLinkApp extends StatelessWidget {
  const SkillLinkApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skill Link',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF3B82F6),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RoleSelectionPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF3B82F6),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.school_rounded, size: 100, color: Colors.white),
              SizedBox(height: 30),
              Text('SkillLink', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 10),
              Text('Connect. Learn. Grow.', style: TextStyle(fontSize: 16, color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [const Color(0xFF3B82F6).withOpacity(0.9), const Color(0xFF1D4ED8)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Select Your Role', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 60),
              _buildRoleButton(context, Icons.school, 'Student', const Color(0xFF3B82F6), () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage(role: 'Student')));
              }),
              const SizedBox(height: 30),
              _buildRoleButton(context, Icons.person_4, 'Professor', const Color(0xFF9333EA), () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage(role: 'Professor')));
              }),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildRoleButton(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 5))]),
        child: Column(
          children: [
            Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(15)), child: Icon(icon, size: 50, color: color)),
            const SizedBox(height: 20),
            Text(label, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  final String role;
  const LoginPage({required this.role, Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _showPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('Please enter email and password');
      return;
    }
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardPage(role: widget.role, email: _emailController.text)));
      }
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red, duration: const Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.role} Login'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text('Welcome Back', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
            const SizedBox(height: 10),
            Text('Sign in as ${widget.role.toLowerCase()}', style: const TextStyle(fontSize: 16, color: Color(0xFF6B7280))),
            const SizedBox(height: 40),
            const Text('Email', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2)),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: !_showPassword,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                prefixIcon: const Icon(Icons.lock_outlined),
                suffixIcon: IconButton(icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => _showPassword = !_showPassword)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2)),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B82F6), disabledBackgroundColor: Colors.grey.shade300, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: _isLoading
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white), strokeWidth: 2))
                    : const Text('Sign In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardPage extends StatefulWidget {
  final String role;
  final String email;
  const DashboardPage({required this.role, required this.email, Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [_buildHome(), _buildEvents(), _buildProjects(), _buildProfile()];
    return Scaffold(
      appBar: AppBar(title: const Text('SkillLink'), elevation: 0),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF3B82F6),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Projects'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome, ${widget.role}!', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
          const SizedBox(height: 8),
          Text(widget.email, style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
          const SizedBox(height: 30),
          _buildStatCard('0', 'Events', Icons.event),
          const SizedBox(height: 12),
          _buildStatCard('0', 'Projects', Icons.work),
          const SizedBox(height: 12),
          _buildStatCard('0', 'Certificates', Icons.card_membership),
        ],
      ),
    );
  }

  Widget _buildEvents() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event, size: 80, color: const Color(0xFF3B82F6).withOpacity(0.3)),
          const SizedBox(height: 20),
          const Text('Events', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
          const SizedBox(height: 10),
          Text('No events yet', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildProjects() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work, size: 80, color: const Color(0xFF3B82F6).withOpacity(0.3)),
          const SizedBox(height: 20),
          const Text('Projects', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
          const SizedBox(height: 10),
          Text('No projects yet', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(width: 120, height: 120, decoration: BoxDecoration(color: const Color(0xFF3B82F6), borderRadius: BorderRadius.circular(60)), child: const Icon(Icons.person, size: 60, color: Colors.white)),
          const SizedBox(height: 20),
          Text(widget.role, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
          const SizedBox(height: 8),
          Text(widget.email, style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const RoleSelectionPage()), (route) => false),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]),
      child: Row(
        children: [
          Container(width: 60, height: 60, decoration: BoxDecoration(color: const Color(0xFF3B82F6).withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: const Color(0xFF3B82F6), size: 32)),
          const SizedBox(width: 20),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280), fontWeight: FontWeight.w500)), const SizedBox(height: 4), Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)))]),
        ],
      ),
    );
  }
}
