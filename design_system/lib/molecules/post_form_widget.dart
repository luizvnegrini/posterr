import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';

import '../design_system.dart';

class PostFormWidget extends HookWidget {
  final TextEditingController controller;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final VoidCallback? removeQuote;
  final Widget? suffixIcon;
  final bool enabled;
  final int? maxLength;
  final bool hasPostToMention;
  final String? postToMentionUsername;
  final DateTime? postToMentionCreationDate;
  final String? postToMentionText;

  const PostFormWidget({
    required this.controller,
    required this.onFieldSubmitted,
    required this.suffixIcon,
    required this.validator,
    required this.enabled,
    required this.maxLength,
    Key? key,
  })  : hasPostToMention = false,
        postToMentionCreationDate = null,
        postToMentionText = null,
        postToMentionUsername = null,
        removeQuote = null,
        super(key: key);

  const PostFormWidget.quote({
    required this.controller,
    required this.onFieldSubmitted,
    required this.suffixIcon,
    required this.validator,
    required this.enabled,
    required this.maxLength,
    required this.postToMentionCreationDate,
    required this.postToMentionText,
    required this.postToMentionUsername,
    required this.removeQuote,
    Key? key,
  })  : hasPostToMention = true,
        super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (hasPostToMention)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: removeQuote,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Text(
                            'Remove quote',
                            style: TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          Icon(
                            Icons.close,
                          ),
                        ],
                      ),
                    ),
                    PostWidget(
                      username: postToMentionUsername!,
                      creationDate: postToMentionCreationDate!,
                      text: postToMentionText!,
                    ),
                  ],
                ),
              TextFormField(
                autofocus: true,
                controller: controller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: validator,
                decoration: InputDecoration(
                  labelText: 'Create new post',
                  hintText: 'What\'s happening?',
                  suffixIcon: suffixIcon,
                ),
                maxLength: maxLength,
                minLines: 1,
                maxLines: 3,
                keyboardType: TextInputType.text,
                enabled: enabled,
                onFieldSubmitted: onFieldSubmitted,
              ),
            ],
          ),
        ),
      );
}
