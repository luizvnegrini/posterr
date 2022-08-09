import 'package:shared/shared.dart';

abstract class IFeedState extends ViewModelState {
  const IFeedState();
  abstract final List<Post>? feedItems;
  abstract final PostSettings? postSettings;
  abstract final bool isLoading;
  abstract final bool dailyLimitOfPostsExceeded;
  abstract final bool postCreated;
  abstract final Post? postToMention;
  abstract final User? user;

  IFeedState copyWith({
    List<Post>? feed,
    bool? isLoading,
    bool? postCreated,
    PostSettings? postSettings,
    User? user,
    bool? dailyLimitOfPostsExceeded,
    Post? postToMention,
  });
}

class FeedState extends IFeedState {
  const FeedState({
    this.feedItems,
    this.postSettings,
    this.user,
    this.postToMention,
    this.isLoading = false,
    this.postCreated = false,
    this.dailyLimitOfPostsExceeded = false,
  });

  factory FeedState.initial() => const FeedState();

  @override
  List<Object?> get props => [
        feedItems,
        postSettings,
        isLoading,
        postCreated,
        user,
        dailyLimitOfPostsExceeded,
        postToMention,
      ];
  @override
  final List<Post>? feedItems;
  @override
  final bool isLoading;
  @override
  final bool postCreated;
  @override
  final PostSettings? postSettings;
  @override
  final User? user;
  @override
  final bool dailyLimitOfPostsExceeded;
  @override
  final Post? postToMention;

  @override
  IFeedState copyWith({
    feed,
    isLoading,
    postSettings,
    postCreated,
    currentBottomNavBarIndex,
    user,
    dailyLimitOfPostsExceeded,
    postToMention,
  }) =>
      FeedState(
        feedItems: feed ?? feedItems,
        isLoading: isLoading ?? this.isLoading,
        postCreated: postCreated ?? this.postCreated,
        postSettings: postSettings ?? this.postSettings,
        user: user ?? this.user,
        dailyLimitOfPostsExceeded:
            dailyLimitOfPostsExceeded ?? this.dailyLimitOfPostsExceeded,
        postToMention: postToMention,
      );
}
