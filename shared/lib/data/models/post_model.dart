import '../../shared.dart';

class PostModel {
  final int userId;
  final String? text;
  final UserModel? author;
  final PostTypeModel type;
  final PostModel? relatedPost;
  final DateTime creationDate;

  PostModel.original({
    required this.userId,
    required this.text,
    required this.creationDate,
  })  : relatedPost = null,
        author = null,
        type = PostTypeModel.post;

  PostModel.repost({
    required this.relatedPost,
    required this.userId,
    required this.creationDate,
  })  : text = null,
        type = PostTypeModel.repost,
        author = null;

  PostModel.quote({
    required this.text,
    required this.relatedPost,
    required this.author,
    required this.userId,
    required this.creationDate,
  }) : type = PostTypeModel.quote;

  Post toEntity() {
    switch (type) {
      case PostTypeModel.post:
        return Post.original(
          userId: userId,
          text: text,
          creationDate: creationDate,
        );
      case PostTypeModel.quote:
        return Post.quote(
          userId: userId,
          text: text,
          relatedPost: relatedPost?.toEntity(),
          author: author?.toEntity(),
          creationDate: creationDate,
        );
      case PostTypeModel.repost:
        return Post.repost(
          userId: userId,
          relatedPost: relatedPost?.toEntity(),
          creationDate: creationDate,
        );
      default:
        throw UnimplementedError();
    }
  }

  factory PostModel.fromEntity(
    Post entity,
  ) {
    switch (entity.type) {
      case PostType.post:
        return PostModel.original(
          userId: entity.userId,
          text: entity.text,
          creationDate: entity.creationDate,
        );
      case PostType.quote:
        return PostModel.quote(
          userId: entity.userId,
          text: entity.text,
          relatedPost: PostModel.fromEntity(entity.relatedPost!),
          author: UserModel.fromEntity(entity.author!),
          creationDate: entity.creationDate,
        );
      case PostType.repost:
        return PostModel.repost(
          userId: entity.userId,
          relatedPost: PostModel.fromEntity(entity.relatedPost!),
          creationDate: entity.creationDate,
        );
      default:
        throw UnimplementedError();
    }
  }

  Map<String, dynamic> toJson() => {
        'author': author?.toJson(),
        'userId': userId,
        'text': text,
        'relatedPost': relatedPost?.toJson(),
        'type': type.toJson(),
        'creationDate': creationDate.toIso8601String(),
      };

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final type = (json['type'] as String).fromJsonToPostTypeModel();

    switch (type) {
      case PostTypeModel.post:
        return PostModel.original(
          userId: json['userId'],
          text: json['text'],
          creationDate: DateTime.parse(json['creationDate']),
        );
      case PostTypeModel.quote:
        return PostModel.quote(
            userId: json['userId'],
            text: json['text'],
            relatedPost: PostModel.fromJson(json['relatedPost']),
            creationDate: DateTime.parse(json['creationDate']),
            author: UserModel.fromJson(json['author']));
      case PostTypeModel.repost:
        return PostModel.repost(
          userId: json['userId'],
          creationDate: DateTime.parse(json['creationDate']),
          relatedPost: PostModel.fromJson(json['relatedPost']),
        );
      default:
        throw UnimplementedError();
    }
  }
}
