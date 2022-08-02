import 'package:shared/shared.dart';

abstract class IAppState {
  abstract final ISharedDependencies sharedDependencies;
}

class AppState extends IAppState {
  AppState({
    required this.sharedDependencies,
  });

  @override
  final ISharedDependencies sharedDependencies;
}
