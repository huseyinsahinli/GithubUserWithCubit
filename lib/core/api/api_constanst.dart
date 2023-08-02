class APIConstants {
  static const String baseUrl = "https://api.github.com";
  static const String user = "$baseUrl/users/{username}";
  static const String userFollowers = "$user/followers";
  static const String userFollowing = "$user/following";
  static const String userRepositories = "$user/repos";

  static String demo(String username) {
    return user.replaceFirst("{username}", username);
  }
}
