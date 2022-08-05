import 'package:dependencies/dependencies.dart';

import '../../shared.dart';

final userId = Provider.autoDispose<int>((_) {
  throw UnimplementedError('userId must be overridden');
});
final fetchPostSettings = Provider.autoDispose<IFetchPostSettings>((_) {
  throw UnimplementedError(
      'fetchPostSettings usecase Provider must be overridden');
});
final fetchPosts = Provider.autoDispose<IFetchPosts>((_) {
  throw UnimplementedError('fetchPosts usecase Provider must be overridden');
});
final createPost = Provider.autoDispose<ICreatePost>((_) {
  throw UnimplementedError('createPost usecase Provider must be overridden');
});
