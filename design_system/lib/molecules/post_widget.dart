import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';

import '../design_system.dart';

class PostWidget extends HookWidget {
  final String username;
  final DateTime creationDate;
  final String text;
  final postDateFormatter = DateFormat.MMMMEEEEd();
  final creationDateStyle = TextStyle(
    color: Colors.grey.withOpacity(.5),
    fontSize: 10,
  );
  final defaultSizedBox = const SizedBox(width: 10);

  PostWidget({
    required this.username,
    required this.creationDate,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        elevation: 3,
        child: Container(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Flexible(
                          flex: 1,
                          child: Text(
                            '${postDateFormatter.format(creationDate)} at ${(creationDate.hour).toString().padLeft(2, '0')}:${(creationDate.minute).toString().padLeft(2, '0')}:${(creationDate.second).toString().padLeft(2, '0')}',
                            style: creationDateStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Text(text),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
