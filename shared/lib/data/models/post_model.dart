import '../../shared.dart';

class PostModel {
  final int id;
  final String? text;
  final int authorId;
  final PostTypeModel type;
  final int? relatedPostId;
  final DateTime creationDate;

  PostModel.original({
    required this.id,
    required this.authorId,
    required this.text,
    required this.creationDate,
  })  : relatedPostId = null,
        type = PostTypeModel.post;

  PostModel.repost({
    required this.id,
    required this.relatedPostId,
    required this.authorId,
    required this.creationDate,
  })  : text = null,
        type = PostTypeModel.repost;

  PostModel.quote({
    required this.id,
    required this.text,
    required this.relatedPostId,
    required this.authorId,
    required this.creationDate,
  }) : type = PostTypeModel.quote;

  // Post toEntity() {
  //   switch (type) {
  //     case PostTypeModel.post:
  //       return Post.original(
  //         id: id,
  //         authorId: authorId,
  //         text: text,
  //         creationDate: creationDate,
  //       );
  //     case PostTypeModel.quote:
  //       return Post.quote(
  //         id: id,
  //         text: text,
  //         relatedPostId: relatedPostId,
  //         authorId: authorId,
  //         creationDate: creationDate,
  //       );
  //     case PostTypeModel.repost:
  //       return Post.repost(
  //         id: id,
  //         authorId: authorId,
  //         relatedPostId: relatedPostId,
  //         creationDate: creationDate,
  //       );
  //     default:
  //       throw UnimplementedError();
  //   }
  // }

  factory PostModel.fromEntity(
    Post entity,
  ) {
    switch (entity.type) {
      case PostType.post:
        return PostModel.original(
          id: entity.id,
          authorId: entity.author.id,
          text: entity.text,
          creationDate: entity.creationDate,
        );
      case PostType.quote:
        return PostModel.quote(
          id: entity.id,
          text: entity.text,
          relatedPostId: entity.relatedPost!.id,
          authorId: entity.author.id,
          creationDate: entity.creationDate,
        );
      case PostType.repost:
        return PostModel.repost(
          id: entity.id,
          authorId: entity.author.id,
          relatedPostId: entity.relatedPost!.id,
          creationDate: entity.creationDate,
        );
      default:
        throw UnimplementedError();
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'authorId': authorId,
        'text': text,
        'relatedPostId': relatedPostId,
        'type': type.toJson(),
        'creationDate': creationDate.toIso8601String(),
      };

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final type = (json['type'] as String).fromJsonToPostTypeModel();

    switch (type) {
      case PostTypeModel.post:
        return PostModel.original(
          id: json['id'],
          authorId: json['authorId'],
          text: json['text'],
          creationDate: DateTime.parse(json['creationDate']),
        );
      case PostTypeModel.quote:
        return PostModel.quote(
          id: json['id'],
          text: json['text'],
          relatedPostId: json['relatedPostId'],
          creationDate: DateTime.parse(json['creationDate']),
          authorId: json['authorId'],
        );
      case PostTypeModel.repost:
        return PostModel.repost(
          id: json['id'],
          authorId: json['authorId'],
          creationDate: DateTime.parse(json['creationDate']),
          relatedPostId: json['relatedPostId'],
        );
      default:
        throw UnimplementedError();
    }
  }
}
