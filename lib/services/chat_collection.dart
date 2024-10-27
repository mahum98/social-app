//
// class ChatsCollection {
//   final CollectionReference chatsCollection =
//       FirebaseFirestore.instance.collection("chats");
//
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
//
//   // Retrieves chat collection snapshots
//   Stream<QuerySnapshot> getChatCollectionSnapshot() {
//     return chatsCollection.orderBy("timeStamp", descending: true).snapshots();
//   }
//
//   // Fetches username by email from UsersCollection
//   Future<String> getUsernameByEmail(String email) async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection("users")
//           .where("email", isEqualTo: email)
//           .get();
//
//       if (querySnapshot.docs.isNotEmpty) {
//         return querySnapshot.docs.first['username'] ?? 'Unknown';
//       }
//     } catch (e) {
//       print("Error fetching username: $e");
//     }
//     return 'Unknown';
//   }
//
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
//
//   // Reads messages from a specific chat
//   Stream<QuerySnapshot> readMessages({required String chatID}) {
//     return chatsCollection
//         .doc(chatID)
//         .collection("messages")
//         .orderBy("timeStamp")
//         .snapshots();
//   }
//
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
//
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
//
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
//
//       if (querySnapshot.docs.isNotEmpty) {
//         return querySnapshot.docs.first;
//       }
//     } catch (e) {
//       print("Error fetching last message: $e");
//     }
//     return null;
//   }
// }
