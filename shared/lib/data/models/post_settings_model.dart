import '../../shared.dart';

class PostSettingsModel {
  final int maxLength;
  final int minLength;

  PostSettingsModel({
    required this.maxLength,
    required this.minLength,
  });

  PostSettings toEntity() => PostSettings(
        maxLength: maxLength,
        minLength: minLength,
      );

  factory PostSettingsModel.fromEntity(
    PostSettings entity,
  ) =>
      PostSettingsModel(
        maxLength: entity.maxLength,
        minLength: entity.minLength,
      );

  Map<String, dynamic> toJson() => {
        'maxLength': maxLength,
        'minLength': minLength,
      };

  factory PostSettingsModel.fromJson(Map<String, dynamic> json) =>
      PostSettingsModel(
        maxLength: json['maxLength'],
        minLength: json['minLength'],
      );
}
