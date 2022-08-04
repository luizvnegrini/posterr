import 'package:dependencies/dependencies.dart';
import 'package:posterr/app_state.dart';

import '../../domain/domain.dart';

final fetchUsers = Provider.autoDispose<IFetchUsers>((_) {
  throw UnimplementedError('fetchUsersUsecase Provider must be overridden');
});

List<Override> mainProviders(IAppState state) => <Override>[
      fetchUsers.overrideWithValue(state.mainDependencies.fetchUsers),
    ];
