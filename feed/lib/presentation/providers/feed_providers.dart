import 'package:dependencies/dependencies.dart';

import '../../feed.dart';

final repost = Provider.autoDispose<IRepost>((_) {
  throw UnimplementedError('repost must be overridden');
});
final quotePost = Provider.autoDispose<IQuotePost>((_) {
  throw UnimplementedError('quotPost usecase Provider must be overridden');
});
