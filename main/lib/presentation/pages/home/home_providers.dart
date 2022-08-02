//vm's
import 'package:dependencies/dependencies.dart';

import '../../presentation.dart';

//vm's
IHomeVM readHomeVM(WidgetRef ref) => ref.read(homeVM.notifier);

//states
IHomeState useHomeState(WidgetRef ref) => ref.watch(homeVM);
