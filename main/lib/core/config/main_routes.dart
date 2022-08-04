import 'package:flutter/material.dart';
import 'package:posterr/presentation/presentation.dart';

List<MapEntry<String, Widget Function(BuildContext)>> mainRoutes = [
  MapEntry(
    '/',
    (context) => const HomePage(),
  ),
];
