import '../../shared.dart';

class UserModel {
  final int id;
  final String username;
  final List<PostModel> posts;
  final DateTime joinedDate;

  UserModel({
    required this.id,
    required this.username,
    required this.posts,
    required this.joinedDate,
  });

  User toEntity() => User(
        id: id,
        joinedDate: joinedDate,
        posts: posts.map<Post>((x) => x.toEntity()).toList(),
        username: username,
      );

  factory UserModel.fromEntity({
    required User entity,
  }) =>
      UserModel(
        id: entity.id,
        joinedDate: entity.joinedDate,
        posts: entity.posts
            .map<PostModel>((x) => PostModel.fromEntity(entity: x))
            .toList(),
        username: entity.username,
      );
}
