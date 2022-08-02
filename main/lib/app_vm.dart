// ignore_for_file: unused_local_variable

import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';

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

    //gateways

    //repositories

    //services

    final splashMinDuration =
        Future<dynamic>.delayed(const Duration(milliseconds: 500));

    await Future.wait<dynamic>([
      splashMinDuration,
    ]);

    final appState = AppState();

    value = AsyncValue.data(appState);
  }
}

abstract class IAppState {}

class AppState extends IAppState {
  AppState();
}
