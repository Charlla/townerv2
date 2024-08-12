import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:towner/services/auth_service.dart';
import 'package:towner/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  UserModel? _userModel;

  User? get user => _user;
  UserModel? get userModel => _userModel;

  AuthProvider() {
    _authService.user.listen((User? user) {
      _user = user;
      if (user != null) {
        // In a real app, you'd fetch the user data from Firestore here
        _userModel = UserModel(id: user.uid, email: user.email ?? '');
      } else {
        _userModel = null;
      }
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _authService.signInWithEmailAndPassword(email, password);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<void> register(String email, String password) async {
    try {
      await _authService.registerWithEmailAndPassword(email, password);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}