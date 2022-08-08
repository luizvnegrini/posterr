import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';

class UserImageContainerWidget extends HookWidget {
  final double size;

  const UserImageContainerWidget({
    required this.size,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 2,
          ),
          shape: BoxShape.circle,
          color: Colors.grey.shade500,
        ),
        child: Icon(
          Icons.person,
          size: size,
          color: Colors.white,
        ),
      );
}
