import 'package:dependencies/dependencies.dart';
import 'package:shared/shared.dart';

import '../../../profile.dart';

final profileViewModel =
    StateNotifierProvider.autoDispose<IProfileViewModel, IProfileState>(
  (ref) => ProfileViewModel(
    fetchPostSettings: ref.read(fetchPostSettings),
    createPost: ref.read(createPost),
    userId: ref.read(userId),
    fetchUser: ref.read(fetchUser),
  ),
);

abstract class IProfileViewModel extends ViewModel<IProfileState> {
  IProfileViewModel(ProfileState state) : super(state);

  abstract final ICreatePost createPost;
  abstract final IFetchUser fetchUser;
  abstract final IFetchPostSettings fetchPostSettings;
  abstract final int userId;
  Future<void> loadUser(int userId);
  Future<void> createNewPost(String text);
  Future<void> loadPostSettings();
}

class ProfileViewModel extends IProfileViewModel {
  @override
  final ICreatePost createPost;
  @override
  final IFetchUser fetchUser;
  @override
  final int userId;
  @override
  IFetchPostSettings fetchPostSettings;

  ProfileViewModel({
    required this.createPost,
    required this.userId,
    required this.fetchPostSettings,
    required this.fetchUser,
  }) : super(ProfileState.initial());

  @override
  Future<void> initViewModel() async {
    super.initViewModel();

    state = state.copyWith(isLoading: true);
    await Future.wait([
      loadUser(userId),
      loadPostSettings(),
    ]);
    state = state.copyWith(isLoading: false);
  }

  @override
  Future<void> loadUser(int userId) async {
    final response = await fetchUser(userId);

    response.fold(
      (l) => throw UnimplementedError(),
      (user) {
        user.posts.sort((a, b) => b.creationDate.compareTo(a.creationDate));
        state = state.copyWith(user: user);
      },
    );
  }

  @override
  Future<void> createNewPost(String text) async {
    state = state.copyWith(
      isLoading: true,
      postCreated: false,
      dailyLimitOfPostsExceeded: false,
    );

    final createPostResponse = await createPost(
      text: text,
      userId: state.user!.id,
    );

    createPostResponse.fold(
      (failure) {
        if (failure.type == ExceptionType.dailyLimitExceeded) {
          state = state.copyWith(
            dailyLimitOfPostsExceeded: true,
            isLoading: false,
          );
        }
      },
      (r) async => await loadUser(state.user!.id),
    );

    state = state.copyWith(isLoading: false);
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
}
