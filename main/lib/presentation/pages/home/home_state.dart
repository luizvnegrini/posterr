import 'package:shared/shared.dart';

abstract class IHomeState extends ViewModelState {
  const IHomeState();
  abstract final int currentBottomNavBarIndex;

  IHomeState copyWith({
    int? currentBottomNavBarIndex,
  });
}

class HomeState extends IHomeState {
  const HomeState({
    this.currentBottomNavBarIndex = 0,
  });

  factory HomeState.initial() => const HomeState();

  @override
  List<Object?> get props => [
        currentBottomNavBarIndex,
      ];
  @override
  final int currentBottomNavBarIndex;

  @override
  IHomeState copyWith({
    feed,
    isLoading,
    postSettings,
    isPostFormValid,
    postCreated,
    currentBottomNavBarIndex,
  }) =>
      HomeState(
        currentBottomNavBarIndex:
            currentBottomNavBarIndex ?? this.currentBottomNavBarIndex,
      );
}
