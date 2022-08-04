import 'package:dependencies/dependencies.dart';
import 'package:shared/shared.dart';

import '../../presentation.dart';

final homeViewModel =
    StateNotifierProvider.autoDispose<IHomeViewModel, IHomeState>(
  (ref) => HomeViewModel(),
);

abstract class IHomeViewModel extends ViewModel<IHomeState> {
  IHomeViewModel(HomeState state) : super(state);
}

class HomeViewModel extends IHomeViewModel {
  HomeViewModel() : super(HomeState.initial());
}
