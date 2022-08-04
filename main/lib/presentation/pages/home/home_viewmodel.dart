import 'package:dependencies/dependencies.dart';
import 'package:shared/shared.dart';

import '../../../domain/domain.dart';
import '../../presentation.dart';

final homeViewModel =
    StateNotifierProvider.autoDispose<IHomeViewModel, IHomeState>(
  (ref) => HomeViewModel(fetchUsers: ref.read(fetchUsers)),
);

abstract class IHomeViewModel extends ViewModel<IHomeState> {
  IHomeViewModel(HomeState state) : super(state);

  abstract final IFetchUsers fetchUsers;
  Future<void> loadUserFeed();
}

class HomeViewModel extends IHomeViewModel {
  @override
  final IFetchUsers fetchUsers;

  final int userId = 5;

  HomeViewModel({
    required this.fetchUsers,
  }) : super(HomeState.initial());

  @override
  void initViewModel() {
    super.initViewModel();

    loadUserFeed();
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
    state = state.copyWith(isLoading: true);

    final users = await _getUsers();

    state = state.copyWith(
      feed: users.firstWhere((user) => user.id == userId).posts,
      isLoading: false,
    );
  }
}
