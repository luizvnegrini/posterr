import 'package:feed/feed.dart';
import 'package:main/core/config/dependencies.dart';
import 'package:profile/profile.dart';
import 'package:shared/shared.dart';

abstract class IAppState {
  abstract final ISharedDependencies sharedDependencies;
  abstract final IMainDependencies mainDependencies;
  abstract final IFeedDependencies feedDependencies;
  abstract final IProfileDependencies profileDependencies;
}

class AppState extends IAppState {
  AppState({
    required this.sharedDependencies,
    required this.mainDependencies,
    required this.feedDependencies,
    required this.profileDependencies,
  });

  @override
  final ISharedDependencies sharedDependencies;

  @override
  final IMainDependencies mainDependencies;

  @override
  final IFeedDependencies feedDependencies;

  @override
  final IProfileDependencies profileDependencies;
}
