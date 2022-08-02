import 'package:dependencies/dependencies.dart';

import '../../shared.dart';

abstract class IPostRepository {
  Future<Either<PostFailure, Unit>> createNewPost(Post post);
  Future<Either<PostFailure, List<Post>>> fetchUserPosts(int userId);
}
