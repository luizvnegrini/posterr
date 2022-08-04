import 'package:posterr/core/config/dependencies.dart';
import 'package:shared/shared.dart';

abstract class IAppState {
  abstract final ISharedDependencies sharedDependencies;
  abstract final IMainDependencies mainDependencies;
}

class AppState extends IAppState {
  AppState({
    required this.sharedDependencies,
    required this.mainDependencies,
  });

  @override
  final ISharedDependencies sharedDependencies;

  @override
  final IMainDependencies mainDependencies;
}
