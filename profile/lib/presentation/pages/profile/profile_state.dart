import 'package:shared/shared.dart';

abstract class IProfileState extends ViewModelState {
  const IProfileState();
  abstract final User? user;
  abstract final bool isLoading;
  abstract final PostSettings? postSettings;
  abstract final bool postCreated;
  abstract final bool dailyLimitOfPostsExceeded;

  IProfileState copyWith({
    User? user,
    bool? isLoading,
    PostSettings? postSettings,
    bool? postCreated,
    bool? dailyLimitOfPostsExceeded,
  });
}

class ProfileState extends IProfileState {
  const ProfileState({
    this.user,
    this.postSettings,
    this.isLoading = false,
    this.postCreated = false,
    this.dailyLimitOfPostsExceeded = false,
  });

  factory ProfileState.initial() => const ProfileState();

  @override
  List<Object?> get props => [
        user,
        postCreated,
        isLoading,
        postSettings,
        dailyLimitOfPostsExceeded,
      ];
  @override
  final bool isLoading;
  @override
  final PostSettings? postSettings;
  @override
  final bool postCreated;
  @override
  final User? user;
  @override
  final bool dailyLimitOfPostsExceeded;

  @override
  IProfileState copyWith({
    user,
    isLoading,
    postSettings,
    postCreated,
    dailyLimitOfPostsExceeded,
  }) =>
      ProfileState(
        user: user ?? this.user,
        isLoading: isLoading ?? this.isLoading,
        postSettings: postSettings ?? this.postSettings,
        postCreated: postCreated ?? this.postCreated,
        dailyLimitOfPostsExceeded:
            dailyLimitOfPostsExceeded ?? this.dailyLimitOfPostsExceeded,
      );
}
