import 'package:shared/shared.dart';

abstract class IFeedState extends ViewModelState {
  const IFeedState();
  abstract final List<Post>? feedItems;
  abstract final PostSettings? postSettings;
  abstract final bool isLoading;
  abstract final bool isPostFormValid;
  abstract final bool dailyLimitOfPostsExceeded;
  abstract final bool postCreated;
  abstract final User? user;

  IFeedState copyWith({
    List<Post>? feed,
    bool? isLoading,
    bool? isPostFormValid,
    bool? postCreated,
    PostSettings? postSettings,
    User? user,
    bool? dailyLimitOfPostsExceeded,
  });
}

class FeedState extends IFeedState {
  const FeedState({
    this.feedItems,
    this.postSettings,
    this.user,
    this.isLoading = false,
    this.isPostFormValid = false,
    this.postCreated = false,
    this.dailyLimitOfPostsExceeded = false,
  });

  factory FeedState.initial() => const FeedState();

  @override
  List<Object?> get props => [
        feedItems,
        postSettings,
        isLoading,
        isPostFormValid,
        postCreated,
        user,
        dailyLimitOfPostsExceeded,
      ];
  @override
  final List<Post>? feedItems;
  @override
  final bool isLoading;
  @override
  final bool isPostFormValid;
  @override
  final bool postCreated;
  @override
  final PostSettings? postSettings;
  @override
  final User? user;
  @override
  final bool dailyLimitOfPostsExceeded;

  @override
  IFeedState copyWith({
    feed,
    isLoading,
    postSettings,
    isPostFormValid,
    postCreated,
    currentBottomNavBarIndex,
    user,
    dailyLimitOfPostsExceeded,
  }) =>
      FeedState(
        feedItems: feed ?? feedItems,
        isLoading: isLoading ?? this.isLoading,
        isPostFormValid: isPostFormValid ?? this.isPostFormValid,
        postCreated: postCreated ?? this.postCreated,
        postSettings: postSettings ?? this.postSettings,
        user: user ?? this.user,
        dailyLimitOfPostsExceeded:
            dailyLimitOfPostsExceeded ?? this.dailyLimitOfPostsExceeded,
      );
}
