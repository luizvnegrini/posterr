import 'package:flutter/material.dart';
import 'package:main/presentation/presentation.dart';

List<MapEntry<String, Widget Function(BuildContext)>> mainRoutes = [
  MapEntry(
    '/',
    (context) => const HomePage(),
  ),
];
