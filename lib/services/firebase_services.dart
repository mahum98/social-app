import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class UsersCollection {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');


  // Checks if the email exists in usersCollection
  Future<bool> isEmailInUsersCollection({required String email}) async {
    QuerySnapshot querySnapshot =
        await usersCollection.where("email", isEqualTo: email).get();
    return querySnapshot.docs.isNotEmpty;
  }

  // Checks if the username exists in usersCollection
  Future<bool> isUsernameInUsersCollection({required String username}) async {
    QuerySnapshot querySnapshot =
        await usersCollection.where("username", isEqualTo: username).get();
    return querySnapshot.docs.isNotEmpty;
  }
  Future<void> updateUserProfile(String userId, String profilePictureUrl) async {
    try {
      await usersCollection.doc(userId).update({
        "profile_picture": profilePictureUrl,
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
  List<Map<String, dynamic>> searchedUsers = [];
  try {
  // Replace with your Firestore query
  var snapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('username', isEqualTo: query) // Adjust your query here
      .get();

  for (var doc in snapshot.docs) {
  searchedUsers.add({
  'id': doc.id, // Ensure the ID is added here
  'username': doc['username'],
  'email': doc['email'],
  'profile_picture': doc['profilePictureUrl'], // Adjust if needed
  });
  }
  } catch (e) {
  print('Error fetching users: $e');
  }
  return searchedUsers;
  }

  // Adds user information to Firestore, including profile picture URL
  Future<void> addUserInfo({
    required String userId,
    required String userEmail,
    required String userName,
    required String profilePicture, // URL is optional
  }) async {
    try {
      await usersCollection.doc(userId).set({
        "email": userEmail,
        "username": userName,
        "profile_picture": profilePicture?? 'assets/avatar.png',
      });
    } catch (e) {
      print("Error adding user info: $e");
    }
  }
}

// class ChatsCollection {
//   final CollectionReference chatsCollection =
//       FirebaseFirestore.instance.collection("chats");

//   // Creates a chat collection
//   Future<void> createChat({
//     required String chatName,
//     required String chatID,
//   }) async {
//     try {
//       await chatsCollection.doc(chatID).set({
//         "chatName": chatName,
//         "timeStamp": Timestamp.now(),
//       });
//     } catch (e) {
//       print("Error creating chat: $e");
//     }
//   }

//   // Retrieves chat collection snapshots
//   Stream<QuerySnapshot> getChatCollectionSnapshot() {
//     return chatsCollection.orderBy("timeStamp", descending: true).snapshots();
//   }

//   // Fetches username by email from UsersCollection
//   Future<String> getUsernameByEmail(String email) async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection("users")
//           .where("email", isEqualTo: email)
//           .get();

//       if (querySnapshot.docs.isNotEmpty) {
//         return querySnapshot.docs.first['username'] ?? 'Unknown';
//       }
//     } catch (e) {
//       print("Error fetching username: $e");
//     }
//     return 'Unknown';
//   }

//   // Sends a message in a specific chat
//   Future<void> sendMessage({
//     required String chatID,
//     required String content,
//     required String sender,
//     required List<String> read,
//     required String username,
//     required String profilePictureUrl,
//   }) async {
//     try {
//       await chatsCollection.doc(chatID).collection("messages").add({
//         'content': content,
//         'sender': sender,
//         'read': read,
//         'username': username,
//         'profilePictureUrl': profilePictureUrl,
//         'timeStamp': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       print("Error sending message: $e");
//     }
//   }

//   // Reads messages from a specific chat
//   Stream<QuerySnapshot> readMessages({required String chatID}) {
//     return chatsCollection
//         .doc(chatID)
//         .collection("messages")
//         .orderBy("timeStamp")
//         .snapshots();
//   }

//   // Updates the timestamp of a chat
//   Future<void> updateTimeStamp({required String chatID}) async {
//     try {
//       await chatsCollection.doc(chatID).update({
//         "timeStamp": Timestamp.now(),
//       });
//     } catch (e) {
//       print("Error updating timestamp: $e");
//     }
//   }

//   // Updates the read status of a message
//   Future<void> updateMessageReadStatus({
//     required String chatID,
//     required String messageID,
//     required List<String> readBy,
//   }) async {
//     try {
//       await chatsCollection
//           .doc(chatID)
//           .collection("messages")
//           .doc(messageID)
//           .update({"read": readBy});
//     } catch (e) {
//       print("Error updating message read status: $e");
//     }
//   }

//   // Fetches the last message in a chat by chatID
//   Future<DocumentSnapshot?> lastMessageByChatID(
//       {required String chatID}) async {
//     try {
//       QuerySnapshot querySnapshot = await chatsCollection
//           .doc(chatID)
//           .collection("messages")
//           .orderBy("timeStamp", descending: true)
//           .limit(1)
//           .get();

//       if (querySnapshot.docs.isNotEmpty) {
//         return querySnapshot.docs.first;
//       }
//     } catch (e) {
//       print("Error fetching last message: $e");
//     }
//     return null;
//   }
// }
