import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';

class DailyLimitOfPostsExceededBottomContentWidget extends HookWidget {
  const DailyLimitOfPostsExceededBottomContentWidget({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              'Daily limit of posts exceeded',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'You have reached the daily limit of 5 posts. Try again tomorrow.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                      const Size(double.infinity, 40))),
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            )
          ],
        ),
      );
}
