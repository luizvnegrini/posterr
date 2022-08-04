import 'package:dependencies/dependencies.dart';
import 'package:shared/shared.dart';

import '../../../domain/domain.dart';
import '../../presentation.dart';

final homeViewModel =
    StateNotifierProvider.autoDispose<IHomeViewModel, IHomeState>(
  (ref) => HomeViewModel(
    fetchPostSettings: ref.read(fetchPostSettings),
    fetchUsers: ref.read(fetchUsers),
  ),
);

abstract class IHomeViewModel extends ViewModel<IHomeState> {
  IHomeViewModel(HomeState state) : super(state);

  abstract final IFetchPostSettings fetchPostSettings;
  abstract final IFetchUsers fetchUsers;
  Future<void> loadUserFeed();
  Future<void> loadPostSettings();
}

class HomeViewModel extends IHomeViewModel {
  @override
  final IFetchPostSettings fetchPostSettings;
  @override
  final IFetchUsers fetchUsers;

  final int userId = 5;

  HomeViewModel({
    required this.fetchPostSettings,
    required this.fetchUsers,
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

  Future<List<User>> _getUsers() async {
    final response = await fetchUsers();

    return response.fold<List<User>>(
      (l) => throw UnimplementedError(),
      (users) => users,
    );
  }

  @override
  Future<void> loadUserFeed() async {
    final users = await _getUsers();

    state = state.copyWith(
      feed: users.firstWhere((user) => user.id == userId).posts,
    );
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
