import 'package:dependencies/dependencies.dart';
import 'package:feed/feed.dart';
import 'package:shared/shared.dart';

final feedViewModel =
    StateNotifierProvider.autoDispose<IFeedViewModel, IFeedState>(
  (ref) => FeedViewModel(
    fetchPostSettings: ref.read(fetchPostSettings),
    fetchPosts: ref.read(fetchPosts),
    createPost: ref.read(createPost),
    userId: ref.read(userId),
    fetchUser: ref.read(fetchUser),
    repost: ref.read(repost),
    quotePost: ref.read(quotePost),
  ),
);

abstract class IFeedViewModel extends ViewModel<IFeedState> {
  IFeedViewModel(FeedState state) : super(state);

  abstract final IFetchPostSettings fetchPostSettings;
  abstract final IFetchPosts fetchPosts;
  abstract final ICreatePost createPost;
  abstract final IRepost repost;
  abstract final IQuotePost quotePost;
  abstract final IFetchUser fetchUser;
  abstract final int userId;
  Future<void> loadUserFeed();
  Future<void> loadPostSettings();
  Future<void> createNewPost(
    String text,
    int userId,
  );
  Future<void> executeRepost({
    required int relatedPostId,
    required int authorId,
  });
  Future<void> executeQuotePost({
    required String text,
    required int relatedPostId,
    required int userId,
  });
  Future<void> loadUser(int userId);
  void mentionPost(Post postToMention);
  void removeQuote();
}

class FeedViewModel extends IFeedViewModel {
  @override
  final IFetchPostSettings fetchPostSettings;
  @override
  final IFetchPosts fetchPosts;
  @override
  final ICreatePost createPost;
  @override
  final int userId;
  @override
  final IFetchUser fetchUser;
  @override
  final IRepost repost;
  @override
  final IQuotePost quotePost;

  FeedViewModel({
    required this.fetchPostSettings,
    required this.fetchPosts,
    required this.createPost,
    required this.userId,
    required this.fetchUser,
    required this.repost,
    required this.quotePost,
  }) : super(FeedState.initial());

  @override
  Future<void> initViewModel() async {
    super.initViewModel();

    state = state.copyWith(isLoading: true);
    await Future.wait([
      loadUserFeed(),
      loadPostSettings(),
      loadUser(userId),
    ]);
    state = state.copyWith(isLoading: false);
  }

  @override
  Future<void> loadUserFeed() async {
    final response = await fetchPosts();

    final newState = response.fold<IFeedState>(
      (l) => throw UnimplementedError(),
      (posts) => state = state.copyWith(feed: posts),
    );

    state = newState.copyWith(isLoading: false);
  }

  @override
  Future<void> loadPostSettings() async {
    final postSettingsResponse = await fetchPostSettings();

    postSettingsResponse.fold(
      (l) => throw UnimplementedError(),
      (postSettings) => state = state.copyWith(
        postSettings: postSettings,
      ),
    );
  }

  @override
  Future<void> loadUser(int userId) async {
    final response = await fetchUser(userId);

    response.fold(
      (l) => throw UnimplementedError(),
      (user) => state = state.copyWith(user: user),
    );
  }

  @override
  Future<void> createNewPost(
    String text,
    int userId,
  ) async {
    state = state.copyWith(
      isLoading: true,
      postCreated: false,
      dailyLimitOfPostsExceeded: false,
    );

    final createPostResponse = await createPost(
      text: text,
      userId: userId,
    );

    await createPostResponse.fold(
      (failure) async {
        if (failure.type == ExceptionType.dailyLimitExceeded) {
          state = state.copyWith(
            dailyLimitOfPostsExceeded: true,
            isLoading: false,
          );
        }
      },
      (r) async {
        state = state.copyWith(postCreated: true);
        await loadUserFeed();
      },
    );
  }

  @override
  Future<void> executeRepost({
    required int relatedPostId,
    required int authorId,
  }) async {
    state = state.copyWith(
      isLoading: true,
      postCreated: false,
      dailyLimitOfPostsExceeded: false,
    );

    final repostResponse = await repost(
      userId: state.user!.id,
      relatedPostAuthorId: authorId,
      relatedPostId: relatedPostId,
    );

    await repostResponse.fold(
      (failure) async {
        if (failure.type == ExceptionType.dailyLimitExceeded) {
          state = state.copyWith(
            dailyLimitOfPostsExceeded: true,
            isLoading: false,
          );
        }
      },
      (r) async {
        state = state.copyWith(postCreated: true);
        await loadUserFeed();
      },
    );
  }

  @override
  Future<void> executeQuotePost({
    required String text,
    required int relatedPostId,
    required int userId,
  }) async {
    state = state.copyWith(
      isLoading: true,
      postCreated: false,
      dailyLimitOfPostsExceeded: false,
    );

    final repostResponse = await quotePost(
      text: text,
      userId: userId,
      relatedPostId: relatedPostId,
    );

    await repostResponse.fold(
      (failure) async {
        if (failure.type == ExceptionType.dailyLimitExceeded) {
          state = state.copyWith(
            dailyLimitOfPostsExceeded: true,
            isLoading: false,
          );
        }
      },
      (r) async {
        state = state.copyWith(postCreated: true);
        await loadUserFeed();
      },
    );
  }

  @override
  void mentionPost(Post postToMention) => state = state.copyWith(
        postToMention: postToMention,
        postCreated: false,
      );

  @override
  void removeQuote() => state = state.copyWith(postToMention: null);
}
