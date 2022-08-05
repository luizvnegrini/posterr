import 'package:shared/shared.dart';

abstract class IProfileState extends ViewModelState {
  const IProfileState();
  abstract final PostSettings? postSettings;
  abstract final bool isLoading;
  abstract final bool isPostFormValid;
  abstract final bool postCreated;

  IProfileState copyWith({
    List<Post>? feed,
    bool? isLoading,
    PostSettings? postSettings,
    bool? isPostFormValid,
    bool? postCreated,
  });
}

class ProfileState extends IProfileState {
  const ProfileState({
    this.postSettings,
    this.isLoading = false,
    this.isPostFormValid = false,
    this.postCreated = false,
  });

  factory ProfileState.initial() => const ProfileState();

  @override
  List<Object?> get props => [
        isLoading,
        postSettings,
        isPostFormValid,
      ];
  @override
  final bool isLoading;
  @override
  final PostSettings? postSettings;
  @override
  final bool isPostFormValid;
  @override
  final bool postCreated;

  @override
  IProfileState copyWith({
    feed,
    isLoading,
    postSettings,
    isPostFormValid,
    postCreated,
  }) =>
      ProfileState(
        isLoading: isLoading ?? this.isLoading,
        postSettings: postSettings ?? this.postSettings,
        isPostFormValid: isPostFormValid ?? this.isPostFormValid,
        postCreated: postCreated ?? this.postCreated,
      );
}
