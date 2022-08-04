import '../../shared.dart';

class PostSettingsModel {
  final int maxLength;

  PostSettingsModel({
    required this.maxLength,
  });

  PostSettings toEntity() => PostSettings(
        maxLength: maxLength,
      );

  factory PostSettingsModel.fromEntity(
    PostSettings entity,
  ) =>
      PostSettingsModel(
        maxLength: entity.maxLength,
      );

  Map<String, dynamic> toJson() => {
        'maxLength': maxLength,
      };

  factory PostSettingsModel.fromJson(Map<String, dynamic> json) =>
      PostSettingsModel(
        maxLength: json['maxLength'],
      );
}
