import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'signup_screen.dart';
import 'main_screen.dart';
import '../widgets/common/auth_background.dart';
import '../widgets/common/slide_in_animation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed';
      if (e.code == 'user-not-found')
        message = 'No user found for that email.';
      else if (e.code == 'wrong-password')
        message = 'Wrong password provided.';
      else if (e.message != null) message = e.message!;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return; // User cancelled
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign-in failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- NEW: Function to handle the forgot password logic ---
  Future<void> _handleForgotPassword() async {
    final email = _usernameController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter your email to reset password.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Password reset link sent to your email.')),
      );
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'An error occurred.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: AuthBackground(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SlideInAnimation(
                delay: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.lockOpen,
                        color: isDarkMode ? Colors.white : Colors.black,
                        size: 28),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        "Welcome Back!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.orbitron(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                          shadows: [
                            Shadow(
                                blurRadius: 10.0,
                                color: theme.colorScheme.primary
                                    .withAlpha((255 * 0.5).round()))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              SlideInAnimation(
                delay: 400,
                child: TextFormField(
                  controller: _usernameController,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  decoration: _buildInputDecoration(
                      theme, "Username or Email", Icons.person_outline),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please enter your username or email'
                      : null,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_passwordFocusNode),
                ),
              ),
              const SizedBox(height: 16),
              SlideInAnimation(
                delay: 500,
                child: TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  obscureText: !_isPasswordVisible,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  decoration: _buildInputDecoration(
                          theme, "Password", Icons.lock_outline)
                      .copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: theme.iconTheme.color
                              ?.withAlpha((255 * 0.7).round())),
                      onPressed: () => setState(
                          () => _isPasswordVisible = !_isPasswordVisible),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty)
                      return 'Please enter your password';
                    if (v.length < 6)
                      return 'Password must be at least 6 characters long';
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleLogin(),
                ),
              ),
              // --- NEW: "Forgot Password" Button ---
              SlideInAnimation(
                delay: 550,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _handleForgotPassword,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SlideInAnimation(
                delay: 600,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ))
                      : const Text("Login",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 24),
              SlideInAnimation(
                delay: 700,
                child: Column(
                  children: [
                    Text("Or login using",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _socialButton(theme, FontAwesomeIcons.google),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SlideInAnimation(
                delay: 800,
                child: TextButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SignUpScreen())),
                  child: Text("Don't have an account? Sign Up",
                      style: TextStyle(color: theme.colorScheme.primary)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(
      ThemeData theme, String label, IconData prefixIcon) {
    final isDarkMode = theme.brightness == Brightness.dark;
    final fillColor =
        isDarkMode ? Colors.black.withOpacity(0.2) : theme.colorScheme.surface;

    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
          color: theme.colorScheme.onSurface.withAlpha((255 * 0.7).round())),
      filled: true,
      fillColor: fillColor,
      prefixIcon: Icon(prefixIcon,
          color: theme.colorScheme.onSurface.withAlpha((255 * 0.7).round())),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.green),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.green, width: 2.0),
      ),
      border: InputBorder.none,
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
      ),
    );
  }

  Widget _socialButton(ThemeData theme, IconData icon) {
    final isDarkMode = theme.brightness == Brightness.dark;
    final bgColor =
        isDarkMode ? Colors.black.withOpacity(0.2) : theme.colorScheme.surface;

    return IconButton(
      onPressed: icon == FontAwesomeIcons.google ? _handleGoogleSignIn : null,
      icon: FaIcon(
        icon,
        size: 24,
        color: theme.colorScheme.onSurface,
      ),
      style: IconButton.styleFrom(
        backgroundColor: bgColor,
        side: BorderSide(color: theme.dividerColor),
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
