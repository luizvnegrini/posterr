import 'dart:convert';

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

  factory UserModel.fromEntity(User entity) => UserModel(
        id: entity.id,
        joinedDate: entity.joinedDate,
        posts: entity.posts
            .map<PostModel>((x) => PostModel.fromEntity(x))
            .toList(),
        username: entity.username,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'posts': posts.map((e) => jsonEncode(e.toJson())).toList(),
        'joinedDate': joinedDate.toIso8601String(),
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        username: json['username'],
        joinedDate: DateTime.parse(json['joinedDate']),
        posts: (json['posts'] as List)
            .map((post) => PostModel.fromJson(jsonDecode(post)))
            .toList(),
      );
}
