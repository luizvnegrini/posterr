import 'package:dependencies/dependencies.dart';

class Core {
  static List<Future<void>> initialize() => [
        _startFirebase(),
      ];

  static Future<void> _startFirebase() async {
    await Firebase.initializeApp();

    // Crashlytics
    await FirebaseCrashlytics.instance.sendUnsentReports();
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    // // Analytics
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    await FirebaseAnalytics.instance.logAppOpen();
  }
}
