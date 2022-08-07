import '../../shared.dart';

class User {
  final int id;
  final String username;
  List<Post> posts;
  final DateTime joinedDate;

  User({
    required this.id,
    required this.username,
    required this.joinedDate,
    List<Post>? posts,
  }) : posts = posts ?? <Post>[];

  void updatePosts(List<Post> posts) => this.posts = posts;
}
