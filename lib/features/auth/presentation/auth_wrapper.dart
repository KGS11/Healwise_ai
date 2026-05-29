// File: lib/features/auth/presentation/auth_wrapper.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/navigation/main_navigation_screen.dart';
import '../../language/presentation/language_selection_screen.dart';
import '../domain/auth_service.dart';
import 'profile_setup_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Handle Firebase initialization or stream errors gracefully by redirecting to language selection
        if (snapshot.hasError) {
          debugPrint('[AuthWrapper] Auth stream error: ${snapshot.error}');
          return const LanguageSelectionScreen();
        }

        // Show progress indicator while checking authentication status
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user != null) {
          debugPrint('[AuthWrapper] Authenticated uid=${user.uid}');
          // User is authenticated. Now check if their profile setup is completed in Firestore.
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get(),
            builder: (context, profileSnapshot) {
              if (profileSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (profileSnapshot.hasData && profileSnapshot.data!.exists) {
                // Profile exists, extract details and navigate to Home (MainNavigationScreen)
                final data =
                    profileSnapshot.data!.data() as Map<String, dynamic>?;
                final name = data?['fullName'] as String? ?? 'Wellness Friend';
                const language = 'English';
                debugPrint('[AuthWrapper] Profile found for uid=${user.uid}.');

                return MainNavigationScreen(
                  languageName: language,
                  userName: name,
                );
              } else {
                if (profileSnapshot.hasError) {
                  debugPrint(
                    '[AuthWrapper] Profile read failed: ${profileSnapshot.error}',
                  );
                } else {
                  debugPrint(
                    '[AuthWrapper] No profile found for uid=${user.uid}.',
                  );
                }
                // Authenticated but profile is not completed. Redirect to Profile Setup.
                return const ProfileSetupScreen(languageName: 'English');
              }
            },
          );
        } else {
          // Not logged in. Redirect to language selection (which leads to LoginScreen).
          return const LanguageSelectionScreen();
        }
      },
    );
  }
}
