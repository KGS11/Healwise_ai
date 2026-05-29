import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/navigation/main_navigation_screen.dart';
import '../domain/auth_service.dart';
import 'auth_copy.dart';
import 'profile_setup_screen.dart';
import 'signup_screen.dart';
import 'widgets/auth_action_footer.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key, required this.languageName});

  final String languageName;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;
  bool _isLoading = false;

  AuthCopy get _copy => AuthCopy(widget.languageName);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.loginWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;
      await _openNextScreenAfterLogin();
    } catch (e) {
      debugPrint('[Login] Email login failed: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithGoogle();

      if (!mounted) return;
      await _openNextScreenAfterLogin();
    } catch (e) {
      debugPrint('[Login] Google login failed: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openNextScreenAfterLogin() async {
    final authService = ref.read(authServiceProvider);
    final user = authService.currentUser;

    if (user == null) {
      debugPrint('[Login] Auth success callback but currentUser is null.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Please try again.')),
      );
      return;
    }

    debugPrint('[Login] Authenticated uid=${user.uid}');
    final isProfileComplete = await authService.isProfileComplete(user.uid);
    debugPrint(
      '[Login] Profile exists for uid=${user.uid}: $isProfileComplete',
    );

    if (!mounted) return;

    if (isProfileComplete) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => MainNavigationScreen(
            languageName: widget.languageName,
            userName: user.displayName?.trim().isNotEmpty == true
                ? user.displayName!.trim()
                : 'Wellness Friend',
          ),
        ),
        (_) => false,
      );
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => ProfileSetupScreen(languageName: widget.languageName),
      ),
      (_) => false,
    );
  }

  void _openSignup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SignupScreen(languageName: widget.languageName),
      ),
    );
  }

  void _continueDemo() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ProfileSetupScreen(languageName: widget.languageName),
      ),
    );
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return _copy.requiredField;
    }
    if (!email.contains('@') || !email.contains('.')) {
      return _copy.invalidEmail;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) {
      return _copy.requiredField;
    }
    if (password.length < 6) {
      return _copy.shortPassword;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            AuthHeader(
              title: _copy.loginTitle,
              subtitle: _copy.loginSubtitle,
              languageName: widget.languageName,
            ),
            const SizedBox(height: 28),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AuthTextField(
                        controller: _emailController,
                        label: _copy.email,
                        icon: Icons.mail_outline,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 14),
                      AuthTextField(
                        controller: _passwordController,
                        label: _copy.password,
                        icon: Icons.lock_outline,
                        obscureText: _hidePassword,
                        textInputAction: TextInputAction.done,
                        validator: _validatePassword,
                        suffixIcon: IconButton(
                          tooltip: _hidePassword
                              ? 'Show password'
                              : 'Hide password',
                          onPressed: () {
                            setState(() {
                              _hidePassword = !_hidePassword;
                            });
                          },
                          icon: Icon(
                            _hidePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                              children: [
                                FilledButton.icon(
                                  onPressed: _submit,
                                  icon: const Icon(Icons.login),
                                  label: Text(_copy.loginButton),
                                ),
                                const SizedBox(height: 10),
                                OutlinedButton.icon(
                                  onPressed: _signInWithGoogle,
                                  icon: const Icon(
                                    Icons.golf_course,
                                  ), // Custom icon for Google Sign-In
                                  label: const Text('Sign in with Google'),
                                ),
                                const SizedBox(height: 10),
                                OutlinedButton.icon(
                                  onPressed: _continueDemo,
                                  icon: const Icon(Icons.person_outline),
                                  label: Text(_copy.continueAsGuest),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            AuthActionFooter(
              question: _copy.noAccount,
              actionText: _copy.createAccount,
              onPressed: _openSignup,
            ),
            const SizedBox(height: 16),
            Text(
              _copy.medicalNote,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: const Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }
}
