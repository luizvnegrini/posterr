//vm's
import 'package:dependencies/dependencies.dart';

import '../../presentation.dart';

//vm's
IFeedViewModel readFeedViewModel(WidgetRef ref) =>
    ref.read(feedViewModel.notifier);

//states
IFeedState useFeedState(WidgetRef ref) => ref.watch(feedViewModel);
