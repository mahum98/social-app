import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationsPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateNotificationStatus(String notificationId) async {
    // Get the current user's ID
    String userId = _auth.currentUser!.uid;

    // Update notification status to 'read' or perform any other actions as needed
    await _firestore
        .collection('user')
        .doc(userId)
        .collection('notifications')
        .doc(notificationId)
        .update({'status': 'read'});
  }

  @override
  Widget build(BuildContext context) {
    String userId = _auth.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('user')
            .doc(userId)
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notificationData = notifications[index];
              String notificationId = notificationData.id;
              String notificationType = notificationData['notificationType'];
              DateTime timestamp =
              (notificationData['timestamp'] as Timestamp).toDate();

              return ListTile(
                title: Text(notificationType),
                subtitle: Text('Received on ${timestamp.toLocal()}'),
                trailing: IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () async {
                    await updateNotificationStatus(notificationId);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Notification marked as read'),
                    ));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
