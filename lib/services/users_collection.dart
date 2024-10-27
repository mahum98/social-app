import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class UsersCollection {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  // Checks if the email exists in usersCollection
  Future<bool> isEmailInUsersCollection({required String email}) async {
    QuerySnapshot querySnapshot = await usersCollection.where("email", isEqualTo: email).get();
    return querySnapshot.docs.isNotEmpty;
  }

  // Checks if the username exists in usersCollection
  Future<bool> isUsernameInUsersCollection({required String username}) async {
    QuerySnapshot querySnapshot = await usersCollection.where("username", isEqualTo: username).get();
    return querySnapshot.docs.isNotEmpty;
  }

  // Updates the user's profile picture in Firestore
  Future<void> updateUserProfile(String userId, String profilePicture) async {
    try {
      await usersCollection.doc(userId).update({
        "profilePicture": profilePicture, // Use consistent field naming
      });
    } catch (e) {
      print("Error updating user profile picture: $e");
    }
  }

  // Uploads profile picture to Firebase Storage and returns the download URL
  Future<String> uploadProfilePicture(File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('profile_pics/${image.uri.pathSegments.last}');
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading profile picture: $e");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> searchByUsername(String query) async {
    List<Map<String, dynamic>> users = [];
    try {
      // Ensure correct query
      var snapshot = await usersCollection
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      for (var doc in snapshot.docs) {
        users.add({
          'id': doc.id,
          'username': doc['username'],
          'email': doc['email'],
          'profilePicture': doc['profilePicture'] ?? 'assets/avatar.png',
          'friendCount': doc['friendCount'] ?? 0, // Handle friend count
        });
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
    return users; // Return the list of users
  }

  // Adds user information to Firestore, including profile picture URL and friend count
  Future<void> addUserInfo({
    required String userId,
    required String userEmail,
    required String userName,
    required String profilePicture,
    required int friendCount,
  }) async {
    try {
      await usersCollection.doc(userId).set({
        "email": userEmail,
        "username": userName,
        "profilePicture": profilePicture,
        "friendCount": friendCount,
      });
    } catch (e) {
      print("Error adding user info: $e");
    }
  }
}
