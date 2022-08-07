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
  void checkIsPostFormValid(String text);
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
        id: 999, //TODO: atualizar aqui
        author: state.user!,
        creationDate: DateTime.now(),
        text: text,
      ),
    );

    await createPostResponse.fold(
      (l) => throw UnimplementedError(),
      (r) async => await loadUser(userId),
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
