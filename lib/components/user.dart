class User {
  String? ID;
  String email;
  String username;
  String? profilePicture; // Can be null if the user hasn't uploaded a PFP
  int friendCount;

  User({
    this.ID,
    required this.email,
    required this.username,
    this.profilePicture,
    this.friendCount = 0,
  });
}
