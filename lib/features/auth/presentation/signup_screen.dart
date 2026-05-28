import 'package:flutter/material.dart';

import 'auth_copy.dart';
import 'profile_setup_screen.dart';
import 'widgets/auth_action_footer.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key, required this.languageName});

  final String languageName;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;

  AuthCopy get _copy => AuthCopy(widget.languageName);

  @override
  void dispose() {
    _nameController.dispose();
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

  String? _required(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return _copy.requiredField;
    }
    return null;
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
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          children: [
            AuthHeader(
              title: _copy.signupTitle,
              subtitle: _copy.signupSubtitle,
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
                        controller: _nameController,
                        label: _copy.fullName,
                        icon: Icons.badge_outlined,
                        textInputAction: TextInputAction.next,
                        validator: _required,
                      ),
                      const SizedBox(height: 14),
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
                        icon: const Icon(Icons.person_add_alt_1_outlined),
                        label: Text(_copy.signupButton),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            AuthActionFooter(
              question: _copy.alreadyAccount,
              actionText: _copy.loginButton,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
