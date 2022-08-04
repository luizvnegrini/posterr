import '../../shared.dart';

class Post {
  final int userId;
  final String? text;
  final User? author;
  final PostType type;
  final Post? relatedPost;
  final DateTime creationDate;

  Post.original({
    required this.text,
    required this.userId,
    required this.creationDate,
  })  : relatedPost = null,
        author = null,
        type = PostType.post;

  Post.repost({
    required this.relatedPost,
    required this.userId,
    required this.creationDate,
  })  : text = null,
        type = PostType.repost,
        author = null;

  Post.quote({
    required this.text,
    required this.relatedPost,
    required this.author,
    required this.userId,
    required this.creationDate,
  }) : type = PostType.quote;
}
