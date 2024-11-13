import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class GoogleSignInProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      // Ensure the user is signed out from Google before attempting sign-in
      await _googleSignIn.signOut();

      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // If the user cancels the sign-in (i.e., googleUser is null), stop the process
      if (googleUser == null) {
        print("Google Sign-In was cancelled by the user.");
        _showSignInCancelledMessage(context); // Optionally show a message
        return null;
      }

      // Obtain the Google authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential using the tokens
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase using the Google credentials
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Return the signed-in Firebase user
      return userCredential.user;
    } catch (e) {
      print('Error during Google Sign-In: $e');
      _showSignInErrorMessage(context); // Optionally show an error message
      return null;
    }
  }

  // Show a message when sign-in is cancelled
  void _showSignInCancelledMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Sign-In cancelled.")),
    );
  }

  // Show a message when there's an error
  void _showSignInErrorMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("An error occurred during sign-in. Please try again.")),
    );
  }
}
