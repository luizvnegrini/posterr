import 'package:shared/shared.dart';

abstract class IHomeState extends ViewModelState {
  const IHomeState();
  abstract final List<Post>? feed;
  abstract final bool isLoading;

  IHomeState copyWith({
    List<Post>? feed,
    bool? isLoading,
  });
}

class HomeState extends IHomeState {
  const HomeState({
    this.feed,
    this.isLoading = false,
  });

  factory HomeState.initial() => const HomeState();

  @override
  List<Object?> get props => [
        feed,
        isLoading,
      ];
  @override
  final List<Post>? feed;
  @override
  final bool isLoading;

  @override
  IHomeState copyWith({
    feed,
    isLoading,
  }) =>
      HomeState(
        feed: feed ?? this.feed,
        isLoading: isLoading ?? this.isLoading,
      );
}
