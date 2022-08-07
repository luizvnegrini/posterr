import 'package:shared/domain/domain.dart';

class Profile {
  final User user;
  final List<Post> posts;
  final List<Post> reposts;
  final List<Post> quotedPosts;

  Profile({
    required this.user,
    required this.posts,
    required this.reposts,
    required this.quotedPosts,
  });
}
