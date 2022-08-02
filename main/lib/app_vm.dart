// ignore_for_file: unused_local_variable

import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

import 'app_state.dart';

abstract class IAppVM extends ValueNotifier<AsyncValue<IAppState>> {
  IAppVM(AsyncValue<IAppState> value) : super(value);

  Future<void> loadDependencies();
}

class AppVM extends IAppVM {
  AppVM() : super(const AsyncValue.loading());
  var _hasRequestedLoading = false;

  @override
  Future<void> loadDependencies() async {
    if (_hasRequestedLoading) {
      return;
    }
    _hasRequestedLoading = true;

    final splashMinDuration =
        Future<dynamic>.delayed(const Duration(seconds: 1));

    await Future.wait<dynamic>([
      splashMinDuration,

      ///call routine to save first users and posts
    ]);

    final appState = AppState(
      sharedDependencies: SharedDependencies.load(),
    );

    value = AsyncValue.data(appState);
  }
}
