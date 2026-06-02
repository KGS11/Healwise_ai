import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/auth_service.dart';

class ProfilePlaceholderScreen extends StatefulWidget {
  const ProfilePlaceholderScreen({
    super.key,
    required this.userName,
    required this.languageName,
  });

  final String userName;
  final String languageName;

  @override
  State<ProfilePlaceholderScreen> createState() => _ProfilePlaceholderScreenState();
}

class _ProfilePlaceholderScreenState extends State<ProfilePlaceholderScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  
  bool _isEditing = false;
  String _age = '28';
  String _bloodGroup = 'O+';
  String _activityLevel = 'Active (Yoga 4x/week)';
  String _wellnessGoal = 'Stress Relief & Natural Healing';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName.isEmpty ? 'Wellness Friend' : widget.userName);
    _emailController = TextEditingController(text: 'friend@healwise.ai');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveProfileSettings() {
    setState(() {
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile details updated successfully locally.'),
        backgroundColor: Color(0xFF0F766E),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.primary;

    return SafeArea(
      child: Consumer(
        builder: (context, ref, _) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              // User header card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: primaryColor,
                            child: Text(
                              _nameController.text.isEmpty ? 'H' : _nameController.text[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_isEditing)
                                  TextField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Full Name',
                                      isDense: true,
                                    ),
                                  )
                                else
                                  Text(
                                    _nameController.text,
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: const Color(0xFF12342F),
                                    ),
                                  ),
                                const SizedBox(height: 6),
                                if (_isEditing)
                                  TextField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      labelText: 'Email Address',
                                      isDense: true,
                                    ),
                                  )
                                else
                                  Text(
                                    _emailController.text,
                                    style: const TextStyle(
                                      color: Color(0xFF647067),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                if (_isEditing) {
                                  _saveProfileSettings();
                                } else {
                                  setState(() {
                                    _isEditing = true;
                                  });
                                }
                              },
                              icon: Icon(_isEditing ? Icons.check_circle_outline : Icons.edit_outlined),
                              label: Text(_isEditing ? 'Save Settings' : 'Edit Profile'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Chip(
                            avatar: const Icon(Icons.language, size: 16),
                            label: Text(widget.languageName),
                            backgroundColor: const Color(0xFFF1F5F9),
                            side: BorderSide.none,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Personal Health Metrics Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personal Health Details',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF12342F),
                        ),
                      ),
                      const SizedBox(height: 14),
                      _ProfileDetailRow(
                        icon: Icons.cake_outlined,
                        label: 'Age',
                        value: _isEditing ? null : '$_age years',
                        onChanged: (val) => _age = val,
                        initialValue: _age,
                      ),
                      const _ProfileDivider(),
                      _ProfileDetailRow(
                        icon: Icons.bloodtype_outlined,
                        label: 'Blood Group',
                        value: _isEditing ? null : _bloodGroup,
                        onChanged: (val) => _bloodGroup = val,
                        initialValue: _bloodGroup,
                      ),
                      const _ProfileDivider(),
                      _ProfileDetailRow(
                        icon: Icons.directions_run_outlined,
                        label: 'Activity Level',
                        value: _isEditing ? null : _activityLevel,
                        onChanged: (val) => _activityLevel = val,
                        initialValue: _activityLevel,
                      ),
                      const _ProfileDivider(),
                      _ProfileDetailRow(
                        icon: Icons.spa_outlined,
                        label: 'Wellness Goal',
                        value: _isEditing ? null : _wellnessGoal,
                        onChanged: (val) => _wellnessGoal = val,
                        initialValue: _wellnessGoal,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Account options
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Management',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF12342F),
                        ),
                      ),
                      const SizedBox(height: 14),
                      ListTile(
                        leading: const Icon(Icons.sync_outlined, color: Colors.blue),
                        title: const Text('Cloud Data Sync', style: TextStyle(fontWeight: FontWeight.w700)),
                        subtitle: const Text('Automatically upload reports & yoga logs'),
                        trailing: Switch(
                          value: true,
                          onChanged: (_) {},
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.red.shade800,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            try {
                              await ref.read(authServiceProvider).signOut();
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Sign out failed: $e')),
                              );
                            }
                          },
                          icon: const Icon(Icons.logout),
                          label: const Text('Sign Out Account'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileDetailRow extends StatelessWidget {
  const _ProfileDetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.initialValue,
  });

  final IconData icon;
  final String label;
  final String? value;
  final ValueChanged<String> onChanged;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0F766E), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF647067),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                if (value != null)
                  Text(
                    value!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF12342F),
                      fontSize: 14,
                    ),
                  )
                else
                  TextFormField(
                    initialValue: initialValue,
                    onChanged: onChanged,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 6),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileDivider extends StatelessWidget {
  const _ProfileDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 16, color: Color(0xFFE2E8E5));
  }
}
