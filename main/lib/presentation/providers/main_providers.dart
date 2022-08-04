import 'package:dependencies/dependencies.dart';
import 'package:posterr/app_state.dart';
import 'package:shared/shared.dart';

import '../../domain/domain.dart';

final userId = Provider.autoDispose<int>((_) {
  throw UnimplementedError('userId must be overridden');
});
final fetchPostSettings = Provider.autoDispose<IFetchPostSettings>((_) {
  throw UnimplementedError(
      'fetchPostSettings usecase Provider must be overridden');
});
final fetchUsers = Provider.autoDispose<IFetchPosts>((_) {
  throw UnimplementedError('fetchUsers usecase Provider must be overridden');
});
final createPost = Provider.autoDispose<ICreatePost>((_) {
  throw UnimplementedError('createPost usecase Provider must be overridden');
});

List<Override> mainProviders(IAppState state) => <Override>[
      fetchPostSettings
          .overrideWithValue(state.mainDependencies.fetchPostSettings),
      fetchUsers.overrideWithValue(state.mainDependencies.fetchUsers),
      userId.overrideWithValue(state.mainDependencies.userId),
      createPost.overrideWithValue(state.mainDependencies.createPost),
    ];
