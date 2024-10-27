class Notification {
  final String notificationId; // Unique ID for this notification
  final String notificationType; // Type of notification (e.g., "friend_request", "message")
  final String relatedUserId; // ID of the user associated with this notification (e.g., the sender in case of a friend request)
  final String message; // Custom message to be displayed
  final DateTime timestamp; // Timestamp of the notification

  Notification({
    required this.notificationId,
    required this.notificationType,
    required this.relatedUserId,
    required this.message,
    required this.timestamp,
  });
}
