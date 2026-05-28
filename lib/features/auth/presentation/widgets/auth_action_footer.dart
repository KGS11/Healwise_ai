import 'package:flutter/material.dart';

class AuthActionFooter extends StatelessWidget {
  const AuthActionFooter({
    super.key,
    required this.question,
    required this.actionText,
    required this.onPressed,
  });

  final String question;
  final String actionText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          question,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF53645F)),
        ),
        TextButton(onPressed: onPressed, child: Text(actionText)),
      ],
    );
  }
}
