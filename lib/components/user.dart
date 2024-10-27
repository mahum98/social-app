class User {
  String? ID;
  String email;
  String username;
  String? profilePictureUrl; // Can be null if user hasn't uploaded a PFP

  User({
    this.ID,
    required this.email,
    required this.username,
    this.profilePictureUrl, // Optional
  });
}