import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/navigation/main_navigation_screen.dart';
import '../data/user_profile_repository.dart';
import 'auth_copy.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_text_field.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key, required this.languageName});

  final String languageName;

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _historyController = TextEditingController();
  final _habitsController = TextEditingController();
  String _gender = 'Prefer not to say';
  bool _isLoading = false;

  AuthCopy get _copy => AuthCopy(widget.languageName);

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    final displayName = currentUser?.displayName;
    if (displayName != null && displayName.isNotEmpty) {
      _nameController.text = displayName;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _historyController.dispose();
    _habitsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final name = _nameController.text.trim();
    final age = int.tryParse(_ageController.text.trim()) ?? 0;
    final height = double.tryParse(_heightController.text.trim()) ?? 0.0;
    final weight = double.tryParse(_weightController.text.trim()) ?? 0.0;
    final healthHistory = _historyController.text.trim();
    final lifestyleHabits = _habitsController.text.trim();

    try {
      debugPrint('[ProfileSetup] Save tapped. Validated form for "$name".');
      await ref
          .read(userProfileRepositoryProvider)
          .saveCurrentUserProfile(
            fullName: name,
            age: age,
            gender: _gender,
            height: height,
            weight: weight,
            healthHistory: healthHistory,
            lifestyleHabits: lifestyleHabits,
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully.')),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => MainNavigationScreen(
            languageName: widget.languageName,
            userName: name,
          ),
        ),
        (_) => false,
      );
    } on UserProfileException catch (error) {
      debugPrint('[ProfileSetup] Profile save failed: ${error.message}');
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (e) {
      debugPrint('[ProfileSetup] Unexpected profile save error: $e');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save profile. Please try again.'),
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

  String? _required(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return _copy.requiredField;
    }
    return null;
  }

  String? _requiredNumber(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return _copy.requiredField;
    }
    if (double.tryParse(text) == null) {
      return 'Enter a number';
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
              title: _copy.profileTitle,
              subtitle: _copy.profileSubtitle,
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
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 14),
                      AuthTextField(
                        controller: _ageController,
                        label: _copy.age,
                        icon: Icons.cake_outlined,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: _requiredNumber,
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        initialValue: _gender,
                        decoration: InputDecoration(
                          labelText: _copy.gender,
                          prefixIcon: const Icon(Icons.wc_outlined),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Prefer not to say',
                            child: Text('Prefer not to say'),
                          ),
                          DropdownMenuItem(
                            value: 'Female',
                            child: Text('Female'),
                          ),
                          DropdownMenuItem(value: 'Male', child: Text('Male')),
                          DropdownMenuItem(
                            value: 'Other',
                            child: Text('Other'),
                          ),
                        ],
                        onChanged: _isLoading
                            ? null
                            : (value) {
                                if (value == null) {
                                  return;
                                }
                                setState(() {
                                  _gender = value;
                                });
                              },
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: AuthTextField(
                              controller: _heightController,
                              label: _copy.height,
                              icon: Icons.height,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              validator: _requiredNumber,
                              enabled: !_isLoading,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AuthTextField(
                              controller: _weightController,
                              label: _copy.weight,
                              icon: Icons.monitor_weight_outlined,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              validator: _requiredNumber,
                              enabled: !_isLoading,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      AuthTextField(
                        controller: _historyController,
                        label: _copy.healthHistory,
                        icon: Icons.medical_information_outlined,
                        hintText: 'Example: mild BP, poor sleep',
                        maxLines: 2,
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 14),
                      AuthTextField(
                        controller: _habitsController,
                        label: _copy.lifestyleHabits,
                        icon: Icons.self_improvement_outlined,
                        hintText: 'Example: low water intake, late sleep',
                        maxLines: 2,
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 18),
                      _isLoading
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : FilledButton.icon(
                              onPressed: _submit,
                              icon: const Icon(Icons.check_circle_outline),
                              label: Text(_copy.saveProfile),
                            ),
                    ],
                  ),
                ),
              ),
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
