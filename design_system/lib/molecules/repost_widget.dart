import 'package:dependencies/dependencies.dart';
import 'package:design_system/atoms/atoms.dart';
import 'package:flutter/material.dart';

class RepostWidget extends HookWidget {
  final String relatedPostAuthorUsername;
  final DateTime relatedPostCreationDate;
  final String relatedPostText;
  final postDateFormatter = DateFormat.MMMMEEEEd();
  final creationDateStyle = TextStyle(
    color: Colors.grey.withOpacity(.5),
    fontSize: 10,
  );
  final defaultSizedBox = const SizedBox(width: 10);

  RepostWidget({
    required this.relatedPostAuthorUsername,
    required this.relatedPostCreationDate,
    required this.relatedPostText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: const [
                  UserImageContainerWidget(size: 30),
                ],
              ),
              defaultSizedBox,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        relatedPostAuthorUsername,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      defaultSizedBox,
                      const Text('·'),
                      defaultSizedBox,
                      Text(
                        '${postDateFormatter.format(relatedPostCreationDate)} at ${(relatedPostCreationDate.hour).toString().padLeft(2, '0')}:${(relatedPostCreationDate.minute).toString().padLeft(2, '0')}:${(relatedPostCreationDate.second).toString().padLeft(2, '0')}',
                        style: creationDateStyle,
                      ),
                    ],
                  ),
                  Text(relatedPostText),
                ],
              ),
            ],
          ),
        ),
      );
}
