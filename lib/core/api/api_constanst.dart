import 'package:flutter_dotenv/flutter_dotenv.dart';

class APIConstants {
  static const String baseUrl = "https://api.github.com";
  static const String user = "$baseUrl/users/{username}";
  static const String userFollowers = "$user/followers";
  static const String userFollowing = "$user/following";
  static const String userRepositories = "$user/repos";
  static String githubToken = dotenv.env['GITHUB_TOKEN'] ?? "Personal access tokens";
  //https://github.com/settings/tokens -> Personal access tokens -> Generate new token -> repo -> Generate token -> copy token

  static String demo(String username) {
    return user.replaceFirst("{username}", username);
  }
}
