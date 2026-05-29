import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileRepository {
  UserProfileRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  Future<void> saveCurrentUserProfile({
    required String fullName,
    required int age,
    required String gender,
    required double height,
    required double weight,
    required String healthHistory,
    required String lifestyleHabits,
  }) async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      debugPrint('[ProfileSave] Failed: FirebaseAuth.currentUser is null.');
      throw const UserProfileException(
        'No authenticated user found. Please login again.',
      );
    }

    try {
      final userDocument = _firestore.collection('users').doc(user.uid);
      debugPrint('[ProfileSave] Writing profile to users/${user.uid}');

      await userDocument.set({
        'fullName': fullName,
        'email': user.email ?? '',
        'age': age,
        'gender': gender,
        'height': height,
        'weight': weight,
        'healthHistory': healthHistory,
        'lifestyleHabits': lifestyleHabits,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('[ProfileSave] Success: users/${user.uid} saved.');
    } on FirebaseException catch (error) {
      debugPrint(
        '[ProfileSave] FirebaseException ${error.code}: ${error.message}',
      );
      throw UserProfileException(
        error.message ?? 'Unable to save profile. Please try again.',
      );
    } catch (_) {
      debugPrint('[ProfileSave] Unknown error while saving profile.');
      throw const UserProfileException(
        'Something went wrong while saving your profile.',
      );
    }
  }
}

class UserProfileException implements Exception {
  const UserProfileException(this.message);

  final String message;

  @override
  String toString() => message;
}

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepository();
});
