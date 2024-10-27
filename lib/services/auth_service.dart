import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mad/pages/homepage.dart';
import 'package:mad/services/firebase_services.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UsersCollection _usersCollection = UsersCollection();

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    required BuildContext context, // Add context as a parameter
  }) async {
    try {
      // Step 1: Check if the username already exists
      print("Checking if username is taken...");
      bool isUsernameTaken = await _usersCollection.isUsernameInUsersCollection(
          username: username);
      if (isUsernameTaken) {
        Fluttertoast.showToast(
          msg: 'Username already taken, please choose another one.',
          toastLength: Toast.LENGTH_LONG,
        );
        print("Username already taken.");
        return;
      }
      print("Username is available.");

      // Step 2: Create a new user with Firebase Authentication
      print("Creating user with Firebase Authentication...");
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        // Use createUserWithEmailAndPassword for sign-up
        email: email,
        password: password,
      );
      print("User created with Firebase Authentication.");

      // Step 3: Set default profile picture
      String defaultProfilePicture =
          'assets/avatar.png'; // Path to default profile picture

      // Step 4: Save user info to Firestore with default profile picture
      String userId = userCredential.user!.uid;
      print("Adding user info to Firestore...");
      await _usersCollection.addUserInfo(
        userId: userId,
        userEmail: email,
        userName: username,
        profilePicture:
            defaultProfilePicture, // Use default profile picture path
      );
      print("User info added to Firestore.");

      // Step 5: Show success toast and navigate to HomePage
      Fluttertoast.showToast(
          msg: 'Signup successful!', toastLength: Toast.LENGTH_SHORT);
      print("Signup successful toast displayed.");

      // Step 6: Navigate to HomePage
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomePage()),
        (Route<dynamic> route) => false, // Remove all previous routes
      );
      print("Navigating to HomePage.");
    } on FirebaseAuthException catch (e) {
      String message = e.code == 'email-already-in-use'
          ? 'This email is already registered'
          : 'An error occurred';
      Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_LONG);
      print("FirebaseAuthException: $e");
    } catch (e) {
      print("Error during sign-up: $e");
      Fluttertoast.showToast(
          msg: 'An unexpected error occurred', toastLength: Toast.LENGTH_LONG);
    }
  }


  // // Method to update the profile picture
  // Future<void> updateProfilePicture({
  //   required String userId,
  //   required File newProfilePicture,
  // }) async {
  //   try {
  //     // Step 1: Upload the new profile picture and get the download URL
  //     print("Uploading new profile picture...");
  //     String profilePictureUrl = await _usersCollection.uploadProfilePicture(newProfilePicture);
  //     print("Profile picture uploaded.");
  //
  //     // Step 2: Update the Firestore user document with the new profile picture URL
  //     print("Updating user profile picture in Firestore...");
  //     await _usersCollection.updateUserProfile(userId, profilePictureUrl);
  //     print("User profile picture updated in Firestore.");
  //
  //     Fluttertoast.showToast(
  //       msg: 'Profile picture updated successfully!',
  //       toastLength: Toast.LENGTH_SHORT,
  //     );
  //   } catch (e) {
  //     print("Error updating profile picture: $e");
  //     Fluttertoast.showToast(
  //       msg: 'Failed to update profile picture',
  //       toastLength: Toast.LENGTH_LONG,
  //     );
  //   }
  // }
  // Login Method
  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Attempt Firebase Authentication login
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to HomePage after successful login
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomePage()));
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'No user found with this email.';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password.';
      } else {
        message = 'An error occurred during login.';
      }

      // Displaying error message
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {
      print("Error during login: $e");
    }
  }
}
