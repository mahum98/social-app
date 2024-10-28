import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

class SearchedProfile extends StatefulWidget {
  final String userId;

  const SearchedProfile({super.key, required this.userId});

  @override
  _SearchedProfileState createState() => _SearchedProfileState();
}

class _SearchedProfileState extends State<SearchedProfile> {
  bool _isRequested = false; // Variable to track request status

  Future<Map<String, dynamic>?> _fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return null;
  }

  Future<void> _sendFriendRequest() async {
    try {
      // Get the current user's ID
      String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

      if (currentUserId == null) {
        throw Exception("No user is currently signed in.");
      }

      // Add friend request in recipient's friend_requests subcollection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('friend_requests')
          .add({
        'senderId': currentUserId,
        'timestamp': Timestamp.now(),
        'status': 'pending',
      });

      // Send notification to the recipient
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('notifications')
          .add({
        'notificationType': 'friend_request',
        'senderId': currentUserId,
        'timestamp': Timestamp.now(),
      });

      setState(() {
        _isRequested = true; // Update state when friend request is sent
      });

      Fluttertoast.showToast(
        msg: 'Friend request sent!',
        toastLength: Toast.LENGTH_SHORT,
      );
    } catch (e) {
      print("Error sending friend request: $e");
      Fluttertoast.showToast(
        msg: 'Failed to send friend request',
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future<int> _getFriendsCount() async {
    try {
      QuerySnapshot friendsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('friends')
          .get();
      return friendsSnapshot.docs.length;
    } catch (e) {
      print("Error fetching friends count: $e");
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("User not found"));
          }

          final userData = snapshot.data!;
          final String profilePictureUrl =
              userData['profile_picture'] ?? 'assets/avatar.png';
          final String username = userData['username'] ?? 'Unknown User';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: profilePictureUrl.startsWith('http')
                      ? NetworkImage(profilePictureUrl)
                      : const AssetImage('assets/avatar.png') as ImageProvider,
                ),
                const SizedBox(height: 16),
                Text(
                  username,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                FutureBuilder<int>(
                  future: _getFriendsCount(),
                  builder: (context, friendsCountSnapshot) {
                    if (friendsCountSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Text('Loading friends count...');
                    }
                    return Text(
                      'Friends: ${friendsCountSnapshot.data ?? 0}',
                      style: const TextStyle(fontSize: 18),
                    );
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isRequested
                      ? null
                      : _sendFriendRequest, // Disable if already requested
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isRequested) // Show check icon if requested
                        const Icon(Icons.check),
                      if (_isRequested) const SizedBox(width: 5),
                      Text(_isRequested
                          ? "Requested"
                          : "Add Friend"), // Change text based on state
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
