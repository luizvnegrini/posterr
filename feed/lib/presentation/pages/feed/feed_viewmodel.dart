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
    fetchUser: ref.read(fetchUser),
  ),
);

abstract class IFeedViewModel extends ViewModel<IFeedState> {
  IFeedViewModel(FeedState state) : super(state);

  abstract final IFetchPostSettings fetchPostSettings;
  abstract final IFetchPosts fetchPosts;
  abstract final ICreatePost createPost;
  abstract final IFetchUser fetchUser;
  abstract final int userId;
  Future<void> loadUserFeed();
  Future<void> loadPostSettings();
  Future<void> createNewPost(String text);
  Future<void> loadUser(int userId);
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
  @override
  final IFetchUser fetchUser;

  FeedViewModel({
    required this.fetchPostSettings,
    required this.fetchPosts,
    required this.createPost,
    required this.userId,
    required this.fetchUser,
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
  void checkIsPostFormValid(String text) => state = state.copyWith(
      isPostFormValid: text.length >= state.postSettings!.minLength &&
          text.length <= state.postSettings!.maxLength);

  @override
  Future<void> createNewPost(String text) async {
    state = state.copyWith(
      isLoading: true,
      postCreated: false,
    );

    final createPostResponse = await createPost(
      Post.original(
        id: 999, //TODO: alterar aqui depois
        author: state.user!,
        creationDate: DateTime.now(),
        text: text,
      ),
    );

    await createPostResponse.fold(
      (l) => throw UnimplementedError(),
      (r) async {
        state = state.copyWith(postCreated: true);
        await loadUserFeed();
      },
    );
  }
}
