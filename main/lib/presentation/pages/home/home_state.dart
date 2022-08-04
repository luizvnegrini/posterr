import 'package:shared/shared.dart';

abstract class IHomeState extends ViewModelState {
  const IHomeState();
  abstract final List<Post>? feedItems;
  abstract final PostSettings? postSettings;
  abstract final bool isLoading;

  IHomeState copyWith({
    List<Post>? feed,
    bool? isLoading,
    PostSettings? postSettings,
  });
}

class HomeState extends IHomeState {
  const HomeState({
    this.feedItems,
    this.postSettings,
    this.isLoading = false,
  });

  factory HomeState.initial() => const HomeState();

  @override
  List<Object?> get props => [
        feedItems,
        isLoading,
      ];
  @override
  final List<Post>? feedItems;
  @override
  final bool isLoading;
  @override
  final PostSettings? postSettings;

  @override
  IHomeState copyWith({
    feed,
    isLoading,
    postSettings,
  }) =>
      HomeState(
        feedItems: feed ?? feedItems,
        isLoading: isLoading ?? this.isLoading,
        postSettings: postSettings ?? this.postSettings,
      );
}
