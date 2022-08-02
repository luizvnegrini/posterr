import '../../shared.dart';

class Post {
  final int id;
  final String? text;
  final User? author;
  final PostType type;
  final Post? relatedPost;

  Post.original({
    required this.id,
    required this.text,
    required this.author,
    required this.type,
  }) : relatedPost = null;

  Post.repost({
    required this.id,
    required this.relatedPost,
  })  : text = null,
        type = PostType.repost,
        author = null;

  Post.quote({
    required this.id,
    required this.text,
    required this.relatedPost,
    required this.author,
  }) : type = PostType.quote;
}
