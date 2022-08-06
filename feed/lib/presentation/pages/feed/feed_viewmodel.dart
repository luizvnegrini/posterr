import 'package:dependencies/dependencies.dart';
import 'package:shared/shared.dart';

import '../../presentation.dart';

final feedViewModel =
    StateNotifierProvider.autoDispose<IFeedViewModel, IFeedState>(
  (ref) => FeedViewModel(
    fetchPostSettings: ref.read(fetchPostSettings),
    fetchPosts: ref.read(fetchPosts),
    createPost: ref.read(createPost),
    userId: ref.read(userId),
  ),
);

abstract class IFeedViewModel extends ViewModel<IFeedState> {
  IFeedViewModel(FeedState state) : super(state);

  abstract final IFetchPostSettings fetchPostSettings;
  abstract final IFetchPosts fetchPosts;
  abstract final ICreatePost createPost;
  abstract final int userId;
  Future<void> loadUserFeed();
  Future<void> loadPostSettings();
  Future<void> createNewPost(String text);
  void checkIsPostFormValid(String text);
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

  FeedViewModel({
    required this.fetchPostSettings,
    required this.fetchPosts,
    required this.createPost,
    required this.userId,
  }) : super(FeedState.initial());

  @override
  Future<void> initViewModel() async {
    super.initViewModel();

    state = state.copyWith(isLoading: true);
    await Future.wait([
      loadUserFeed(),
      loadPostSettings(),
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
  void checkIsPostFormValid(String text) => state = state.copyWith(
      isPostFormValid: text.length >= state.postSettings!.minLength &&
          text.length <= state.postSettings!.maxLength);

  @override
  Future<void> createNewPost(String text) async {
    final createPostResponse = await createPost(
      Post.original(
        userId: userId,
        creationDate: DateTime.now(),
        text: text,
      ),
    );

    await createPostResponse.fold(
      (l) => throw UnimplementedError(),
      (r) async => await loadUserFeed(),
    );
  }
}
