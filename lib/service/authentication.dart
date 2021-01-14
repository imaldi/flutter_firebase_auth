import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_auth/model/user.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<User> getCurrentUser();
  void sendEmailVerification();
  Future<void> signOut();
  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User> getCurrentUser() async {
    User user = _firebaseAuth.currentUser;
    return user;
  }

  // auth change user stream
  Stream<UserModel> get user {
    return _firebaseAuth
        .authStateChanges()
        // .onAuthStateChanged
        //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  UserModel _userFromFirebaseUser(User user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  @override
  Future<bool> isEmailVerified() async {
    User user = _firebaseAuth.currentUser;
    return user.emailVerified;
  }

  @override
  sendEmailVerification() {
    User user = _firebaseAuth.currentUser;
    user.sendEmailVerification();
  }

  @override
  Future<String> signIn(String email, String password) async {
    User user = (await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password)) as User;
    return user.uid;
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future<String> signUp(String email, String password) async {
    User user = (await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password)) as User;
    return user.uid;
  }
}
