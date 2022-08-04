import 'package:dependencies/dependencies.dart';
import 'package:posterr/app_state.dart';

import '../../domain/domain.dart';

final fetchPostSettings = Provider.autoDispose<IFetchPostSettings>((_) {
  throw UnimplementedError(
      'fetchPostSettings usecase Provider must be overridden');
});
final fetchUsers = Provider.autoDispose<IFetchUsers>((_) {
  throw UnimplementedError('fetchUsers usecase Provider must be overridden');
});

List<Override> mainProviders(IAppState state) => <Override>[
      fetchPostSettings
          .overrideWithValue(state.mainDependencies.fetchPostSettings),
      fetchUsers.overrideWithValue(state.mainDependencies.fetchUsers),
    ];
