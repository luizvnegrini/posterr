//vm's
import 'package:dependencies/dependencies.dart';

import '../../presentation.dart';

//vm's
IProfileViewModel readProfileViewModel(WidgetRef ref) =>
    ref.read(profileViewModel.notifier);

//states
IProfileState useProfileState(WidgetRef ref) => ref.watch(profileViewModel);
