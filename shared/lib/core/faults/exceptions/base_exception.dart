import 'package:dependencies/dependencies.dart';

typedef ExceptionObserver = void Function(BaseException exception);

abstract class BaseException extends Equatable implements Exception {
  BaseException({required this.type, this.debugInfo, this.debugData}) {
    observer?.call(this);
  }

  final ExceptionType type;

  final String? debugInfo;
  final dynamic debugData;

  static ExceptionObserver? observer;

  @override
  List<Object> get props => [type];

  @override
  String toString() => '''
  [BaseException - $type] $debugInfo.
  Debug Data: $debugData
  ''';
}

enum ExceptionType {
  serverError,
  notFound,
}
