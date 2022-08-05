import 'package:flutter/material.dart';

import '../../profile.dart';

List<MapEntry<String, Widget Function(BuildContext)>> profileRoutes = [
  MapEntry(
    '/profile',
    (context) => const ProfilePage(),
  ),
];
