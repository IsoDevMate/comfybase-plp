import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String message;
  final String? buttonText;
  final VoidCallback? onRetry;
  final IconData? icon;
  final double iconSize;
  final double spacing;

  const ErrorMessageWidget({
    Key? key,
    required this.message,
    this.buttonText,
    this.onRetry,
    this.icon,
    this.iconSize = 48.0,
    this.spacing = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: iconSize,
                color: Theme.of(context).colorScheme.error,
              ),
            if (icon != null) SizedBox(height: spacing),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
            if (onRetry != null) SizedBox(height: spacing / 2),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                child: Text(buttonText ?? 'Retry'),
              ),
          ],
        ),
      ),
    );
  }
}
