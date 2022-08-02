import 'package:dependencies/dependencies.dart';

abstract class IHomeState extends Equatable {
  // final double batteryPercentage;

  // const IHomeState({
  // required this.batteryPercentage,
  // });

  // IHomeState copyWith({
  //   double? batteryPercentage,
  // });
}

class HomeState extends IHomeState {
  // const HomeState({
  //   required super.batteryPercentage,
  // });

  @override
  List<Object?> get props => [
        // batteryPercentage,
      ];

  // @override
  // IHomeState copyWith({
  //   double? batteryPercentage,
  // }) =>
  //     HomeState();
}
