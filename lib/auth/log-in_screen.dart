import 'package:flutter/material.dart';
import 'package:skill_link/auth/sign-up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  final String role; // 'student' or 'professor'
  final VoidCallback onLogin;

  const LoginScreen({Key? key, required this.role, required this.onLogin})
    : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPassword = false;
  bool _rememberMe = false;
  bool _isLoading = false; // ADD THIS

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // ... existing initState, dispose code ...

  // ADD THIS METHOD - Firebase Login
  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Sign in with Firebase
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        // Success! Call the onLogin callback
        if (mounted) {
          widget.onLogin();
        }
      } on FirebaseAuthException catch (e) {
        // Handle Firebase errors
        String errorMessage = 'incorrect email or password, try again!';

        if (e.code == 'user-not-found') {
          errorMessage = 'No user found with this email';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Invalid email address';
        } else if (e.code == 'user-disabled') {
          errorMessage = 'This account has been disabled';
        }

        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
          );
        }
      } catch (e) {
        // Handle other errors
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An error occurred, Please try again later.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  bool get _isStudent => widget.role == 'student';

  List<Color> get _gradientColors => _isStudent
      ? [const Color(0xFF3B82F6), const Color(0xFF9333EA)]
      : [const Color(0xFFA855F7), const Color(0xFF6366F1)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF9FAFB), Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // Logo and Title
                  _buildHeader(),
                  const SizedBox(height: 24),

                  // Role Badge
                  _buildRoleBadge(),
                  const SizedBox(height: 24),

                  // Login Form
                  SlideTransition(
                    position: _slideAnimation,
                    child: _buildLoginForm(),
                  ),
                  const SizedBox(height: 24),

                  // Terms and Privacy
                  _buildTermsText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SignUpScreen(
                  role: widget.role,
                  onSignUp: () => widget.onLogin(),
                  onBackToLogin: () => Navigator.pop(context),
                ),
              ),
            );
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Sign up',
            style: TextStyle(
              color: Color(0xFF3B82F6),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset('logo.png', fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'SkillLink',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Welcome back',
          style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }

  Widget _buildRoleBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: _gradientColors),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _gradientColors[0].withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        _isStudent ? 'Student Login' : 'Professor Login',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email Input
            _buildEmailField(),
            const SizedBox(height: 20),

            // Password Input
            _buildPasswordField(),
            const SizedBox(height: 20),

            // Remember Me & Forgot Password
            _buildRememberMeRow(),
            const SizedBox(height: 20),

            // Sign In Button
            _buildSignInButton(),
            const SizedBox(height: 16),

            // Sign Up Link
            _buildSignUpLink(),
            const SizedBox(height: 24),

            // Divider
            _buildDivider(),
            const SizedBox(height: 24),

            // Social Login Buttons
            _buildSocialButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email Address',
          style: TextStyle(
            color: Color(0xFF374151),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'your.email@university.edu',
            prefixIcon: const Icon(
              Icons.mail_outline,
              color: Color(0xFF9CA3AF),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            color: Color(0xFF374151),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: !_showPassword,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: Color(0xFF9CA3AF),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _showPassword ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF9CA3AF),
              ),
              onPressed: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRememberMeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                activeColor: const Color(0xFF3B82F6),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Remember me',
              style: TextStyle(color: Color(0xFF374151), fontSize: 14),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            // Handle forgot password
          },
          child: const Text(
            'Forgot password?',
            style: TextStyle(color: Color(0xFF3B82F6), fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: _gradientColors),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: _gradientColors[0].withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Sign In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Or continue with',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildSocialButton(
            'Google',
            'icons/Google_logo.png', // You'll need to add this asset
            onTap: () {
              // Handle Google login
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSocialButton(
            'Facebook',
            'icons/Google_logo.png', // You'll need to add this asset
            onTap: () {
              // Handle Facebook login
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(
    String label,
    String iconPath, {
    required VoidCallback onTap,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            width: 20,
            height: 20,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                label == 'Google' ? Icons.g_mobiledata : Icons.facebook,
                size: 20,
                color: label == 'Google'
                    ? const Color(0xFF4285F4)
                    : const Color(0xFF1877F2),
              );
            },
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF374151),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 12),
          children: [
            const TextSpan(text: 'By signing in, you agree to our '),
            WidgetSpan(
              child: GestureDetector(
                onTap: () {
                  // Handle Terms of Service tap
                },
                child: const Text(
                  'Terms of Service',
                  style: TextStyle(color: Color(0xFF3B82F6), fontSize: 12),
                ),
              ),
            ),
            const TextSpan(text: ' and '),
            WidgetSpan(
              child: GestureDetector(
                onTap: () {
                  // Handle Privacy Policy tap
                },
                child: const Text(
                  'Privacy Policy',
                  style: TextStyle(color: Color(0xFF3B82F6), fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
