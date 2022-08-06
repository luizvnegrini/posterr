import 'package:dependencies/dependencies.dart';
import 'package:shared/shared.dart';

import '../../../profile.dart';

final profileViewModel =
    StateNotifierProvider.autoDispose<IProfileViewModel, IProfileState>(
  (ref) => ProfileViewModel(
      createPost: ref.read(createPost),
      userId: ref.read(userId),
      fetchUserPosts: ref.read(fetchUserPosts),
      fetchUser: ref.read(fetchUser)),
);

abstract class IProfileViewModel extends ViewModel<IProfileState> {
  IProfileViewModel(ProfileState state) : super(state);

  abstract final ICreatePost createPost;
  abstract final IFetchUserPosts fetchUserPosts;
  abstract final IFetchUser fetchUser;
  abstract final int userId;
  Future<void> loadUserPosts(int userId);
  Future<void> loadUser(int userId);
  Future<void> createNewPost(String text);
  void checkIsPostFormValid(String text);
}

class ProfileViewModel extends IProfileViewModel {
  @override
  final ICreatePost createPost;
  @override
  final int userId;
  @override
  final IFetchUserPosts fetchUserPosts;
  @override
  final IFetchUser fetchUser;

  ProfileViewModel({
    required this.createPost,
    required this.userId,
    required this.fetchUserPosts,
    required this.fetchUser,
  }) : super(ProfileState.initial());

  @override
  Future<void> initViewModel() async {
    super.initViewModel();

    state = state.copyWith(isLoading: true);
    await Future.wait([
      loadUserPosts(userId),
      loadUser(userId),
    ]);
    state = state.copyWith(isLoading: false);
  }

  @override
  Future<void> loadUserPosts(int userId) async {
    final response = await fetchUserPosts(userId);

    response.fold(
      (l) => throw UnimplementedError(),
      (posts) => state = state.copyWith(posts: posts),
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
    state = state.copyWith(isLoading: true);

    final createPostResponse = await createPost(
      Post.original(
        userId: userId,
        creationDate: DateTime.now(),
        text: text,
      ),
    );

    await createPostResponse.fold(
      (l) => throw UnimplementedError(),
      (r) async => await loadUserPosts(userId),
    );

    state = state.copyWith(isLoading: false);
  }
}
