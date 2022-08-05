import 'dart:async';

import 'package:dependencies/dependencies.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:profile/profile.dart';
import 'package:shared/shared.dart';

import 'app_state.dart';
import 'app_viewmodel.dart';
import 'core/core.dart';
import 'flavors/flavors.dart';

class Startup {
  static Future<void> run() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Future.wait(Core.initialize());

    final vm = AppViewModel();
    vm.loadDependencies();

    runApp(_App(viewModel: vm));
  }
}

class _App extends StatelessWidget {
  final AppViewModel viewModel;
  String get appTitle => 'Posterr';

  const _App({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<AsyncValue<IAppState>>(
        valueListenable: viewModel,
        builder: (context, value, child) => value.maybeWhen(
          data: (state) => ProviderScope(
            overrides: [
              userId.overrideWithValue(state.sharedDependencies.userId),
              fetchPostSettings.overrideWithValue(
                  state.sharedDependencies.fetchPostSettings),
              fetchPosts.overrideWithValue(state.sharedDependencies.fetchPosts),
              createPost.overrideWithValue(state.sharedDependencies.createPost),
            ],
            child: const AppLoadedRoot(),
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
                  child: Text('Alterar por uma imagem ou animação'),
                ),
              ),
              show: kDebugMode,
            ),
          ),
        ),
      );
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
        title: 'Posterr',
        // home: _flavorBanner(child: const HomePage()),
        theme: ThemeData(
          primarySwatch: Colors.orange,
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: <String, Widget Function(BuildContext)>{}..addEntries(
            [
              ...mainRoutes,
              ...profileRoutes,
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
