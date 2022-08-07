import '../../shared.dart';

class Post {
  final int id;
  final String? text;
  final User author;
  final PostType type;
  final Post? relatedPost;
  final DateTime creationDate;

  Post.original({
    required this.id,
    required this.text,
    required this.author,
    required this.creationDate,
  })  : relatedPost = null,
        type = PostType.post;

  Post.repost({
    required this.id,
    required this.relatedPost,
    required this.author,
    required this.creationDate,
  })  : text = null,
        type = PostType.repost;

  Post.quote({
    required this.id,
    required this.text,
    required this.relatedPost,
    required this.author,
    required this.creationDate,
  }) : type = PostType.quote;
}
