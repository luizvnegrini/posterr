import '../../shared.dart';

class PostConfigModel {
  final int id;
  final int maxLength;

  PostConfigModel({
    required this.id,
    required this.maxLength,
  });

  PostConfig toEntity() => PostConfig(
        id: id,
        maxLength: maxLength,
      );

  factory PostConfigModel.fromEntity({
    required PostConfig entity,
  }) =>
      PostConfigModel(
        id: entity.id,
        maxLength: entity.maxLength,
      );
}
