class FriendRequest {
  final String senderId; // ID of the user who sent the friend request
  final String recipientId; // ID of the user who received the friend request
  final String senderUsername; // Username of the user who sent the request
  String status; // Status of the request: 'pending', 'accepted', 'declined'

  FriendRequest({
    required this.senderId,
    required this.recipientId,
    required this.senderUsername,
    this.status = 'pending', // Default status is 'pending'
  });

  // Method to update the status of the request
  void updateStatus(String newStatus) {
    status = newStatus;
  }
}
