import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/data/firebase_service/firestore.dart';
import 'package:instagram/data/firebase_service/storage.dart';
import '../../screens/home.dart';
import '../../util/exception.dart';

class Authentication {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> Login({
    required String email,
    required String password,
    required BuildContext context, // Add BuildContext to use for navigation
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()), // Replace with your home screen widget
      );
    } on FirebaseException catch (e) {
      throw exceptions(e.message.toString());
    }
  }

  Future<void> Signup({
    required String email,
    required String password,
    required String passwordConfirme,
    required String username,
    required String bio,
    required File profile,
    required BuildContext context, // Add BuildContext to use for navigation
  }) async {
    String URL;
    try {
      if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty && bio.isNotEmpty && passwordConfirme.isNotEmpty) {
        if (password == passwordConfirme) {
          await _auth.createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

          if (profile != File('')) {
            URL = await StorageMethod().uploadImageToStorage('Profile', profile);
          } else {
            URL = '';
          }

          await Firebase_Firestore().CreateUser(
            email: email,
            username: username,
            bio: bio,
            profile: URL == '' ? 'https://firebasestorage.googleapis.com/v0/b/instagram-93c56.appspot.com/o/Screenshot%202024-01-17%20205622.png?alt=media&token=5f24c127-25c0-4ed9-b127-402d58b37b97' : URL,
          );

          // Navigate to the home screen after successful signup
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()), // Replace with your home screen widget
          );
        } else {
          throw exceptions('Password and confirm password should be same');
        }
      } else {
        throw exceptions('Enter all the fields');
      }
    } on FirebaseException catch (e) {
      throw exceptions(e.message.toString());
    }
  }
}
