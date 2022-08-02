import 'package:flutter/material.dart';

List<MapEntry<String, Widget Function(BuildContext)>> onboardingRoutes = [
  MapEntry(
    '/onboarding',
    (context) => const Text('Onboarding: Alterar este widget pela page'),
  ),
];
