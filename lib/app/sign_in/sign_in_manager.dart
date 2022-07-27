import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/services/auth.dart';

class SignInManager {
  SignInManager({
    required this.auth,
    required this.isLoading,
  });

  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  Future<User?> signIn(Future<User?> Function() siginInMethod) async {
    try {
      isLoading.value = true;
      return await siginInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<User?> signInAnonymously() async => signIn(auth.signInAnonymously);

  Future<User?> signInWithGoogle() async => signIn(auth.signInWithGoogle);

  // Future<User?> signInWithEmailAndPassword(String email, String password) {}
  // Future<User?> createUserWithEmailAndPassword(String email, String password) {}
  // Future<void> signOut() {}
}
