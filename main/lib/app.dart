import 'dart:async';
import 'dart:isolate';

import 'package:dependencies/dependencies.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:onboarding/onboarding.dart';
import 'package:shared/shared.dart';

import 'app_vm.dart';
import 'core/core.dart';
import 'flavors/flavors.dart';

class Startup {
  static Future<void> run() async {
    await configureErrorsOutsideOfFlutter();

    runZonedGuarded<Future<void>>(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Future.wait(Core.initialize());

      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      final vm = AppVM();
      vm.loadDependencies();

      runApp(_App(vm: vm));
    },
        (error, stack) =>
            FirebaseCrashlytics.instance.recordError(error, stack));
  }
}

class _App extends StatelessWidget {
  final AppVM vm;
  String get appTitle => 'Transport app';

  const _App({
    required this.vm,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<AsyncValue<IAppState>>(
        valueListenable: vm,
        builder: (context, value, child) => value.maybeWhen(
          data: (state) => const ProviderScope(
            overrides: [],
            child: AppLoadedRoot(),
          ),
          orElse: () => MaterialApp(
            title: appTitle,
            theme: ThemeData(
              primarySwatch: Colors.green,
              useMaterial3: true,
            ),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: _flavorBanner(
              child: Container(
                color: Theme.of(context).colorScheme.onBackground,
                child: const Center(
                  ///TODO: alterar por alguma animação
                  child: Text('Alterar por uma imagem ou animação'),
                ),
              ),
              show: kDebugMode,
            ),
          ),
        ),
      );
}

Future<void> configureErrorsOutsideOfFlutter() async {
  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final List<dynamic> errorAndStacktrace = pair;
    await FirebaseCrashlytics.instance.recordError(
      errorAndStacktrace.first,
      errorAndStacktrace.last,
    );
  }).sendPort);
}

Widget _flavorBanner({
  required Widget child,
  bool show = true,
}) =>
    show
        ? Banner(
            location: BannerLocation.topStart,
            message: F.name,
            color: Colors.green.withOpacity(0.6),
            textStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.0,
                letterSpacing: 1.0),
            textDirection: TextDirection.ltr,
            child: child,
          )
        : Container(
            child: child,
          );

class AppLoadedRoot extends HookConsumerWidget {
  const AppLoadedRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp(
        title: 'Transport app',
        // home: _flavorBanner(child: const HomePage()),
        theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: <String, Widget Function(BuildContext)>{}..addEntries(
            [
              ...mainRoutes,
              ...onboardingRoutes,
            ],
          ),
        scaffoldMessengerKey: useScaffoldMessenger(ref),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('pt', 'BR'),
        ],
      );
}
