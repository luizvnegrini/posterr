import 'package:shared/shared.dart';

class PostSettingsFactory {
  static PostSettings makePostSettings() => PostSettings(
        minLength: 5,
        maxLength: 777,
      );
}
