import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:capstone2/loginSignup/screen/email_verification.dart'; // Import the EmailVerification page

class AuthMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // SignUp User
  Future<String> signupUser({
    required String email,
    required String password,
    required String name,
    required BuildContext context, // Add context to navigate
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        // Check if the email is already in use
        final signInMethods = await _auth.fetchSignInMethodsForEmail(email);
        if (signInMethods.isNotEmpty) {
          res = "Email already in use. Please check your email or use a different one.";
          return res;
        }

        // Register user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Send verification email
        if (cred.user != null) {
          await cred.user!.sendEmailVerification();
        }

        // Add user to Firestore database
        await _firestore.collection("users").doc(cred.user!.uid).set({
          'name': name,
          'uid': cred.user!.uid,
          'email': email,
          'isEmailVerified': true, // Track email verification status
          'createdAt': FieldValue.serverTimestamp(), // Track creation time
          // 'profileImage': profileImage,
        });

        // Redirect to email verification page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => EmailVerification(),
          ),
        );

        res = "success";
      } else {
        res = "Please enter all fields";
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        res = "Error: ${e.message}";
      } else {
        res = "Error: ${e.toString()}";
      }
    }
    return res;
  }

  // Log In User
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // Log the user in
        UserCredential cred = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Check if the user has verified their email
        if (!cred.user!.emailVerified) {
          res = "Please verify your email before logging in";
        } else {
          res = "success";
        }
      } else {
        res = "Please enter all fields";
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        res = "Error: ${e.message}";
      } else {
        res = "Error: ${e.toString()}";
      }
    }
    return res;
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error signing out: ${e.toString()}");
    }
  }

  // Check Email Verification Status
  Future<void> checkEmailVerification() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      user = _auth.currentUser;
      if (user!.emailVerified) {
        await _firestore.collection("users").doc(user.uid).update({
          'isEmailVerified': true,
        });
      }
    }
  }

  // Reset Password
  Future<String> resetPassword({required String email}) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty) {
        // Send password reset email
        await _auth.sendPasswordResetEmail(email: email);
        res = "Password reset email sent. Please check your inbox.";
      } else {
        res = "Please enter your email address.";
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        res = "Error: ${e.message}";
      } else {
        res = "Error: ${e.toString()}";
      }
    }
    return res;
  }
}
