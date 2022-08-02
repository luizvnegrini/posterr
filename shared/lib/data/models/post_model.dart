import '../../shared.dart';

class PostModel {
  final int id;
  final String? text;
  final UserModel? author;
  final PostTypeModel type;
  final PostModel? relatedPost;

  PostModel.original({
    required this.id,
    required this.text,
    required this.author,
    required this.type,
  }) : relatedPost = null;

  PostModel.repost({
    required this.id,
    required this.relatedPost,
  })  : text = null,
        type = PostTypeModel.repost,
        author = null;

  PostModel.quote({
    required this.id,
    required this.text,
    required this.relatedPost,
    required this.author,
  }) : type = PostTypeModel.quote;

  Post toEntity() {
    switch (type) {
      case PostTypeModel.post:
        return Post.original(
          id: id,
          text: text,
          author: author?.toEntity(),
          type: type.toEntity(),
        );
      case PostTypeModel.quote:
        return Post.quote(
          id: id,
          text: text,
          relatedPost: relatedPost?.toEntity(),
          author: author?.toEntity(),
        );
      case PostTypeModel.repost:
        return Post.quote(
          id: id,
          text: text,
          relatedPost: relatedPost?.toEntity(),
          author: author?.toEntity(),
        );
      default:
        throw UnimplementedError();
    }
  }

  factory PostModel.fromEntity({
    required Post entity,
  }) {
    switch (entity.type) {
      case PostType.post:
        return PostModel.original(
          id: entity.id,
          text: entity.text,
          author: UserModel.fromEntity(entity: entity.author!),
          type: entity.type.fromEntity(),
        );
      case PostType.quote:
        return PostModel.quote(
          id: entity.id,
          text: entity.text,
          relatedPost: PostModel.fromEntity(entity: entity.relatedPost!),
          author: UserModel.fromEntity(entity: entity.author!),
        );
      case PostType.repost:
        return PostModel.repost(
          id: entity.id,
          relatedPost: PostModel.fromEntity(entity: entity),
        );
      default:
        throw UnimplementedError();
    }
  }
}
