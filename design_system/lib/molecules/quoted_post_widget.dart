import 'package:dependencies/dependencies.dart';
import 'package:design_system/atoms/atoms.dart';
import 'package:flutter/material.dart';

class QuotedPostWidget extends HookWidget {
  final String username;
  final DateTime creationDate;
  final String text;
  final String relatedPostAuthorUsername;
  final DateTime relatedPostCreationDate;
  final String relatedPostText;
  final postDateFormatter = DateFormat.MMMMEEEEd();
  final creationDateStyle = TextStyle(
    color: Colors.grey.withOpacity(.5),
    fontSize: 10,
  );
  final defaultSizedBox = const SizedBox(width: 10);

  QuotedPostWidget({
    required this.username,
    required this.creationDate,
    required this.text,
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
              Expanded(
                flex: 1,
                child: Column(
                  children: const [
                    UserImageContainerWidget(size: 30),
                  ],
                ),
              ),
              defaultSizedBox,
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        defaultSizedBox,
                        const Text('·'),
                        defaultSizedBox,
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${postDateFormatter.format(creationDate)} at ${(creationDate.hour).toString().padLeft(2, '0')}:${(creationDate.minute).toString().padLeft(2, '0')}:${(creationDate.second).toString().padLeft(2, '0')}',
                            style: creationDateStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(text),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black, width: .2),
                          ),
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: const [
                                  UserImageContainerWidget(size: 15),
                                ],
                              ),
                              defaultSizedBox,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        relatedPostAuthorUsername,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                      defaultSizedBox,
                                      const Text('·'),
                                      defaultSizedBox,
                                      Text(
                                        '${postDateFormatter.format(relatedPostCreationDate)} at ${(relatedPostCreationDate.hour).toString().padLeft(2, '0')}:${(relatedPostCreationDate.minute).toString().padLeft(2, '0')}:${(relatedPostCreationDate.second).toString().padLeft(2, '0')}',
                                        style: creationDateStyle.copyWith(
                                            fontSize: 8),
                                      ),
                                    ],
                                  ),
                                  Text(relatedPostText)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
