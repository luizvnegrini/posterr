//vm's
import 'package:dependencies/dependencies.dart';

import '../../presentation.dart';

//vm's
IProfileViewModel readHomeVM(WidgetRef ref) =>
    ref.read(profileViewModel.notifier);

//states
IProfileState useHomeState(WidgetRef ref) => ref.watch(profileViewModel);
