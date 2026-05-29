// File: lib/features/auth/domain/auth_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';

class AuthService {
  AuthService({
    required AuthRepository authRepository,
    FirebaseFirestore? firestore,
  })  : _authRepository = authRepository,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final AuthRepository _authRepository;
  final FirebaseFirestore _firestore;

  // Stream of User auth state changes
  Stream<User?> get authStateChanges => FirebaseAuth.instance.authStateChanges();

  // Get current authenticated user
  User? get currentUser => _authRepository.getCurrentUser();

  // Sign up with Email and Password
  Future<UserCredential> signUpWithEmail(String email, String password) {
    return _authRepository.signUpWithEmail(email, password);
  }

  // Login with Email and Password
  Future<UserCredential> loginWithEmail(String email, String password) {
    return _authRepository.loginWithEmail(email, password);
  }

  // Sign in with Google
  Future<UserCredential> signInWithGoogle() {
    return _authRepository.signInWithGoogle();
  }

  // Sign Out
  Future<void> signOut() {
    return _authRepository.signOut();
  }

  // Business Logic: Check if the user has completed their profile setup in Firestore
  Future<bool> isProfileComplete(String uid) async {
    try {
      final docRef = _firestore.collection('users').doc(uid);
      final docSnap = await docRef.get();
      return docSnap.exists;
    } catch (e) {
      // In case of error (e.g. permission or network), default to false to be safe
      return false;
    }
  }
}

// --- Riverpod Providers ---

// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// Provider for AuthService wrapping AuthRepository
final authServiceProvider = Provider<AuthService>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthService(authRepository: repository);
});

// StreamProvider that exposes the Firebase User authStateChanges stream
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});
