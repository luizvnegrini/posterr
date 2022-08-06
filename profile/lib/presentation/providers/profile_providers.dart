import 'package:dependencies/dependencies.dart';

import '../../profile.dart';

final fetchUserPosts = Provider.autoDispose<IFetchUserPosts>((_) {
  throw UnimplementedError(
      'fetchUserPosts usecase Provider must be overridden');
});

final fetchUser = Provider.autoDispose<IFetchUser>((_) {
  throw UnimplementedError('fetchUser usecase Provider must be overridden');
});
