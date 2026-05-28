import 'package:flutter/material.dart';

import 'auth_copy.dart';
import 'profile_setup_screen.dart';
import 'signup_screen.dart';
import 'widgets/auth_action_footer.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.languageName});

  final String languageName;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;

  AuthCopy get _copy => AuthCopy(widget.languageName);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ProfileSetupScreen(languageName: widget.languageName),
      ),
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
                      FilledButton.icon(
                        onPressed: _submit,
                        icon: const Icon(Icons.login),
                        label: Text(_copy.loginButton),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: _continueDemo,
                        icon: const Icon(Icons.person_outline),
                        label: Text(_copy.continueAsGuest),
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
