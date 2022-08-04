import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';

abstract class ViewModelState extends Equatable {
  ///Creates a [ViewModelState]
  const ViewModelState();
}

abstract class ViewModel<State extends ViewModelState>
    extends StateNotifier<State> {
  /// If view model is initialized
  bool isInitialized = false;

  /// Creates a [ViewModel]
  ViewModel(initialState) : super(initialState) {
    initViewModel();
  }

  /// Called when the [ViewModel] is created
  @mustCallSuper
  void initViewModel() {
    assert(
      !isInitialized,
      'View Model has already been initialized! The initialization occurs automatically on life cycle, so you should not call initViewModel manually.',
    );
    isInitialized = true;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
