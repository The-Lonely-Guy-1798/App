import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'main_screen.dart';
import '../widgets/common/auth_background.dart';
import '../widgets/common/slide_in_animation.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        if (!mounted) return;
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Verify your email'),
            content: const Text(
                'A verification link has been sent to your email. Please verify your email before logging in.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      // Optionally, sign out the user so they can't access the app until verified
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).pop(); // Go back to login screen
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Signup failed';
      if (e.code == 'email-already-in-use')
        message = 'Email already in use.';
      else if (e.code == 'invalid-email')
        message = 'Invalid email address.';
      else if (e.code == 'weak-password')
        message = 'Password is too weak.';
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

  Future<void> _handleGoogleSignUp() async {
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
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign-up failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // FIXED: Replaced onBackground with onSurface
        leading: BackButton(color: theme.colorScheme.onSurface),
      ),
      extendBodyBehindAppBar: true,
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
                    // FIXED: Replaced onBackground with onSurface
                    FaIcon(FontAwesomeIcons.lock,
                        color: theme.colorScheme.onSurface, size: 28),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        "Create an Account",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.orbitron(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          // FIXED: Replaced withOpacity with withAlpha
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
                  decoration: _buildInputDecoration(
                      theme, "Username", Icons.person_outline),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please enter a username'
                      : null,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_emailFocusNode),
                ),
              ),
              const SizedBox(height: 16),
              SlideInAnimation(
                delay: 500,
                child: TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  decoration: _buildInputDecoration(
                      theme, "Email", Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Please enter your email';
                    if (!RegExp(r".+@.+\..+").hasMatch(v))
                      return 'Please enter a valid email';
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_passwordFocusNode),
                ),
              ),
              const SizedBox(height: 16),
              SlideInAnimation(
                delay: 600,
                child: TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  obscureText: !_isPasswordVisible,
                  decoration: _buildInputDecoration(
                          theme, "Password", Icons.lock_outline)
                      .copyWith(
                    suffixIcon: _buildVisibilityToggle(
                        () => setState(
                            () => _isPasswordVisible = !_isPasswordVisible),
                        _isPasswordVisible),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty)
                      return 'Please enter a password';
                    if (v.length < 6)
                      return 'Password must be at least 6 characters';
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context)
                      .requestFocus(_confirmPasswordFocusNode),
                ),
              ),
              const SizedBox(height: 16),
              SlideInAnimation(
                delay: 700,
                child: TextFormField(
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocusNode,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: _buildInputDecoration(
                          theme, "Confirm Password", Icons.lock_outline)
                      .copyWith(
                    suffixIcon: _buildVisibilityToggle(
                        () => setState(() => _isConfirmPasswordVisible =
                            !_isConfirmPasswordVisible),
                        _isConfirmPasswordVisible),
                  ),
                  validator: (v) => (v != _passwordController.text)
                      ? 'Passwords do not match'
                      : null,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleSignUp(),
                ),
              ),
              const SizedBox(height: 24),
              SlideInAnimation(
                delay: 800,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignUp,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text("Sign Up",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 24),
              SlideInAnimation(
                delay: 900,
                child: Column(
                  children: [
                    Text("Or sign up using",
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVisibilityToggle(VoidCallback onPressed, bool isVisible) {
    // FIXED: Replaced withOpacity with withAlpha
    return IconButton(
      icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility,
          color: Theme.of(context)
              .iconTheme
              .color
              ?.withAlpha((255 * 0.7).round())),
      onPressed: onPressed,
    );
  }

  InputDecoration _buildInputDecoration(
      ThemeData theme, String label, IconData prefixIcon) {
    return InputDecoration(
      labelText: label,
      // FIXED: Replaced withOpacity with withAlpha
      labelStyle: TextStyle(
          color: theme.colorScheme.onSurface.withAlpha((255 * 0.7).round())),
      filled: true,
      fillColor: theme.colorScheme.surface,
      // FIXED: Replaced withOpacity with withAlpha
      prefixIcon: Icon(prefixIcon,
          color: theme.colorScheme.onSurface.withAlpha((255 * 0.7).round())),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.primary),
      ),
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
    return IconButton(
      onPressed: icon == FontAwesomeIcons.google ? _handleGoogleSignUp : null,
      icon: FaIcon(icon, size: 24),
      style: IconButton.styleFrom(
        backgroundColor: theme.colorScheme.surface,
        side: BorderSide(color: theme.dividerColor),
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
