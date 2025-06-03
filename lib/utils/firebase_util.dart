// lib/utils/firebase_util.dart
import 'package:firebase_auth/firebase_auth.dart';

Future<String?> getCurrentUserId() async {
  final user = FirebaseAuth.instance.currentUser;
  return user?.uid;
}
