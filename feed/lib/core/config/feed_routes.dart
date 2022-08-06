import 'package:flutter/material.dart';

import '../../feed.dart';

List<MapEntry<String, Widget Function(BuildContext)>> feedRoutes = [
  MapEntry(
    '/feed',
    (context) => const FeedPage(),
  ),
];
