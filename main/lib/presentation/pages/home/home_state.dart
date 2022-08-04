import 'package:shared/shared.dart';

abstract class IHomeState extends ViewModelState {}

class HomeState extends IHomeState {
  HomeState();
  factory HomeState.initial() => HomeState();

  @override
  List<Object?> get props => [];

  // @override
  // IHomeState copyWith({

  // }) =>
  //     HomeState();
}
