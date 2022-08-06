import 'package:shared/shared.dart';

abstract class IProfileState extends ViewModelState {
  const IProfileState();
  abstract final PostSettings? postSettings;
  abstract final User? user;
  abstract final List<Post>? posts;
  abstract final bool isLoading;
  abstract final bool isPostFormValid;
  abstract final bool postCreated;

  IProfileState copyWith({
    User? user,
    List<Post>? posts,
    bool? isLoading,
    PostSettings? postSettings,
    bool? isPostFormValid,
    bool? postCreated,
  });
}

class ProfileState extends IProfileState {
  const ProfileState({
    this.user,
    this.posts,
    this.postSettings,
    this.isLoading = false,
    this.isPostFormValid = false,
    this.postCreated = false,
  });

  factory ProfileState.initial() => const ProfileState();

  @override
  List<Object?> get props => [
        posts,
        postCreated,
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
  final List<Post>? posts;
  @override
  final User? user;

  @override
  IProfileState copyWith({
    user,
    posts,
    isLoading,
    postSettings,
    isPostFormValid,
    postCreated,
  }) =>
      ProfileState(
        user: user ?? this.user,
        posts: posts ?? this.posts,
        isLoading: isLoading ?? this.isLoading,
        postSettings: postSettings ?? this.postSettings,
        isPostFormValid: isPostFormValid ?? this.isPostFormValid,
        postCreated: postCreated ?? this.postCreated,
      );
}
