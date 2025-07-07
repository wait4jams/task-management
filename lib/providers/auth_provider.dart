import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  bool get isAuthenticated => user != null;

  Future<void> signup(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = result.user;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message); // ✅ Pass readable message
    } catch (e) {
      throw Exception("Unknown error: $e");
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = result.user;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message); // ✅ Proper error message
    } catch (e) {
      throw Exception("Unknown error: $e");
    }
  }

  void logout() {
    _auth.signOut();
    user = null;
    notifyListeners();
  }
}
