import 'package:shared/shared.dart';

abstract class IHomeState extends ViewModelState {
  const IHomeState();
  abstract final List<Post>? feedItems;
  abstract final PostSettings? postSettings;
  abstract final bool isLoading;
  abstract final bool isPostFormValid;
  abstract final bool postCreated;

  IHomeState copyWith({
    List<Post>? feed,
    bool? isLoading,
    PostSettings? postSettings,
    bool? isPostFormValid,
    bool? postCreated,
  });
}

class HomeState extends IHomeState {
  const HomeState({
    this.feedItems,
    this.postSettings,
    this.isLoading = false,
    this.isPostFormValid = false,
    this.postCreated = false,
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
  final bool postCreated;

  @override
  IHomeState copyWith({
    feed,
    isLoading,
    postSettings,
    isPostFormValid,
    postCreated,
  }) =>
      HomeState(
        feedItems: feed ?? feedItems,
        isLoading: isLoading ?? this.isLoading,
        postSettings: postSettings ?? this.postSettings,
        isPostFormValid: isPostFormValid ?? this.isPostFormValid,
        postCreated: postCreated ?? this.postCreated,
      );
}
