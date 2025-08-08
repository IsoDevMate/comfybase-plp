import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// A collection of reusable UI components based on the audio transcription tips
class UIComponents {
  /// Creates a rich text widget with different styles
  static RichText richText({
    required List<TextSpan> children,
    TextAlign textAlign = TextAlign.start,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return RichText(
      text: TextSpan(children: children),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.visible,
    );
  }

  /// Creates a selectable text widget
  static SelectableText selectableText(
    String text, {
    TextStyle? style,
    TextAlign textAlign = TextAlign.start,
    int? maxLines,
  }) {
    return SelectableText(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }

  /// Creates a hero widget for smooth transitions
  static Hero hero({
    required String tag,
    required Widget child,
  }) {
    return Hero(
      tag: tag,
      child: Material(type: MaterialType.transparency, child: child),
    );
  }

  /// Creates an animated icon button
  static StatefulBuilder animatedIconButton({
    required IconData icon,
    required IconData activeIcon,
    required VoidCallback onPressed,
    bool isActive = false,
    double size = 24.0,
    Color? color,
    Color? activeColor,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return IconButton(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: isActive
                ? Icon(activeIcon, key: const ValueKey('active'), size: size, color: activeColor)
                : Icon(icon, key: const ValueKey('inactive'), size: size, color: color),
          ),
          onPressed: () {
            setState(() => isActive = !isActive);
            onPressed();
          },
        );
      },
    );
  }

  /// Creates a custom snackbar
  static void showCustomSnackBar({
    required BuildContext context,
    required String message,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    final snackBar = SnackBar(
      content: Text(message, style: GoogleFonts.poppins(color: Colors.white)),
      backgroundColor: backgroundColor ?? AppColors.primary,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      action: action,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Creates a visibility widget with animation
  static AnimatedVisibility animatedVisibility({
    required bool visible,
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    Widget Function(Widget child, Animation<double> animation)? customBuilder,
  }) {
    return AnimatedVisibility(
      visible: visible,
      duration: duration,
      child: child,
      customBuilder: customBuilder ?? (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: 1.0,
            child: child,
          ),
        );
      },
    );
  }

  /// Creates a responsive layout that adapts to different screen sizes
  static Widget responsiveLayout({
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        
        if (width >= 1200 && desktop != null) {
          return desktop;
        } else if (width >= 600 && tablet != null) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}

/// A wrapper for animated visibility with more options
class AnimatedVisibility extends StatelessWidget {
  final bool visible;
  final Widget child;
  final Duration duration;
  final Widget Function(Widget child, Animation<double> animation) customBuilder;

  const AnimatedVisibility({
    Key? key,
    required this.visible,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    Widget Function(Widget child, Animation<double> animation)? customBuilder,
  }) : customBuilder = customBuilder ?? _defaultBuilder,
       super(key: key);

  static Widget _defaultBuilder(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return customBuilder(child, animation);
      },
      child: visible ? child : const SizedBox.shrink(),
    );
  }
}
