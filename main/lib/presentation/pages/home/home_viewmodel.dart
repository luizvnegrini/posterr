import 'package:dependencies/dependencies.dart';
import 'package:shared/shared.dart';

import '../../../domain/domain.dart';
import '../../presentation.dart';

final homeViewModel =
    StateNotifierProvider.autoDispose<IHomeViewModel, IHomeState>(
  (ref) => HomeViewModel(
    fetchPostSettings: ref.read(fetchPostSettings),
    fetchPosts: ref.read(fetchUsers),
    createPost: ref.read(createPost),
    userId: ref.read(userId),
  ),
);

abstract class IHomeViewModel extends ViewModel<IHomeState> {
  IHomeViewModel(HomeState state) : super(state);

  abstract final IFetchPostSettings fetchPostSettings;
  abstract final IFetchPosts fetchPosts;
  abstract final ICreatePost createPost;
  abstract final int userId;
  Future<void> loadUserFeed();
  Future<void> loadPostSettings();
  Future<void> createNewPost(String text);
  void checkIsPostFormValid(String text);
}

class HomeViewModel extends IHomeViewModel {
  @override
  final IFetchPostSettings fetchPostSettings;
  @override
  final IFetchPosts fetchPosts;
  @override
  final ICreatePost createPost;
  @override
  final int userId;

  HomeViewModel({
    required this.fetchPostSettings,
    required this.fetchPosts,
    required this.createPost,
    required this.userId,
  }) : super(HomeState.initial());

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

    final newState = response.fold<IHomeState>(
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
