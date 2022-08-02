import '../../shared.dart';

enum PostTypeModel {
  post,
  repost,
  quote,
}

extension PostTypeModelExtension on PostTypeModel {
  PostType toEntity() {
    switch (this) {
      case PostTypeModel.post:
        return PostType.post;
      case PostTypeModel.quote:
        return PostType.quote;
      case PostTypeModel.repost:
        return PostType.repost;
      default:
        throw UnimplementedError();
    }
  }
}

extension PostTypeExtension on PostType {
  PostTypeModel fromEntity() {
    switch (this) {
      case PostType.post:
        return PostTypeModel.post;
      case PostType.quote:
        return PostTypeModel.quote;
      case PostType.repost:
        return PostTypeModel.repost;
      default:
        throw UnimplementedError();
    }
  }
}
