import 'package:dependencies/dependencies.dart';

import '../../presentation.dart';

final homeVM = StateNotifierProvider.autoDispose<IHomeVM, IHomeState>(
  (ref) => HomeVM(
      // hardwareService: ref.read(hardwareService),
      ),
);

abstract class IHomeVM extends StateNotifier<IHomeState> {
  // abstract final IHardwareService hardwareService;

  IHomeVM(HomeState state) : super(state);

  // Future<void> getBatteryPercentage();
}

class HomeVM extends IHomeVM {
  // @override
  // final IHardwareService hardwareService;

  HomeVM() : super(HomeState()) {
    // getBatteryPercentage();
  }
}
