class UserModel {
  String email;
  String username;
  String bio;
  String profile;
  List following;
  List followers;

  UserModel(this.bio, this.email, this.followers, this.following, this.profile,
      this.username);
}
