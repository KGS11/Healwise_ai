import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/healwise_app.dart';
import 'core/constants/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
    );
  } catch (e) {
    // Print the error so the developer knows Firebase is not configured yet,
    // but allow the app to boot and run.
    debugPrint(
      'Firebase initialization failed (likely using placeholders): $e',
    );
  }
  runApp(const ProviderScope(child: HealWiseApp()));
}
