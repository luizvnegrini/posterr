import 'package:shared/shared.dart';

class PostSettingsFactory {
  static PostSettings makePostSettings() {
    return PostSettings(
      maxLength: 777,
      minLength: 5,
    );
  }
}
