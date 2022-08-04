import 'package:dependencies/dependencies.dart';

import '../../shared.dart';

class LocalStorageAdapter implements ILocalStorageDataSource {
  final LocalStorage localStorage;

  LocalStorageAdapter({required this.localStorage});

  @override
  // ignore: avoid_annotating_with_dynamic
  Future<void> save({
    required String key,
    required dynamic value,
  }) async {
    await localStorage.deleteItem(key);
    await localStorage.setItem(key, value, (object) => object);
  }

  @override
  Future<void> delete(String key) async => await localStorage.deleteItem(key);

  @override
  Future<dynamic> fetch(String key) async => await localStorage.getItem(key);
}
