import 'package:shared/shared.dart';

abstract class IHomeState extends ViewModelState {
  const IHomeState();
  abstract final List<Post>? feedItems;
  abstract final PostSettings? postSettings;
  abstract final bool isLoading;
  abstract final bool isPostFormValid;

  IHomeState copyWith({
    List<Post>? feed,
    bool? isLoading,
    PostSettings? postSettings,
    bool? isPostFormValid,
  });
}

class HomeState extends IHomeState {
  const HomeState({
    this.feedItems,
    this.postSettings,
    this.isLoading = false,
    this.isPostFormValid = false,
  });

  factory HomeState.initial() => const HomeState();

  @override
  List<Object?> get props => [
        feedItems,
        isLoading,
        postSettings,
        isPostFormValid,
      ];
  @override
  final List<Post>? feedItems;
  @override
  final bool isLoading;
  @override
  final PostSettings? postSettings;
  @override
  final bool isPostFormValid;

  @override
  IHomeState copyWith({
    feed,
    isLoading,
    postSettings,
    isPostFormValid,
  }) =>
      HomeState(
        feedItems: feed ?? feedItems,
        isLoading: isLoading ?? this.isLoading,
        postSettings: postSettings ?? this.postSettings,
        isPostFormValid: isPostFormValid ?? this.isPostFormValid,
      );
}
