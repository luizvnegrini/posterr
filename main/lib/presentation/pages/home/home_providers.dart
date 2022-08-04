//vm's
import 'package:dependencies/dependencies.dart';

import '../../presentation.dart';

//vm's
IHomeViewModel readHomeVM(WidgetRef ref) => ref.read(homeViewModel.notifier);

//states
IHomeState useHomeState(WidgetRef ref) => ref.watch(homeViewModel);
