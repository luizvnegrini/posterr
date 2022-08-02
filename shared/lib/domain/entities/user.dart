import '../../shared.dart';

class User {
  final int id;
  final String username;
  final List<Post> posts;
  final DateTime joinedDate;

  User({
    required this.id,
    required this.username,
    required this.posts,
    required this.joinedDate,
  });
}
