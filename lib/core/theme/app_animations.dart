import 'package:flutter/material.dart';

class AppAnimations {
  // Duration Constants
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration extraSlow = Duration(milliseconds: 800);

  // Curve Constants
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve bounceIn = Curves.bounceIn;
  static const Curve bounceOut = Curves.bounceOut;
  static const Curve elasticIn = Curves.elasticIn;
  static const Curve elasticOut = Curves.elasticOut;

  // Custom Curves
  static const Curve fluidCurve = Cubic(0.3, 0, 0, 1);
  static const Curve snappyCurve = Cubic(0.2, 0, 0, 1);

  // Page Transition
  static PageRouteBuilder<T> slideTransition<T>(
    Widget page, {
    RouteSettings? settings,
    Duration duration = medium,
    Curve curve = easeInOut,
    Offset begin = const Offset(1.0, 0.0),
    Offset end = Offset.zero,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: begin,
            end: end,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );
      },
    );
  }

  // Fade Transition
  static PageRouteBuilder<T> fadeTransition<T>(
    Widget page, {
    RouteSettings? settings,
    Duration duration = medium,
    Curve curve = easeInOut,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: curve),
          child: child,
        );
      },
    );
  }

  // Scale Transition
  static PageRouteBuilder<T> scaleTransition<T>(
    Widget page, {
    RouteSettings? settings,
    Duration duration = medium,
    Curve curve = easeInOut,
    double begin = 0.0,
    double end = 1.0,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: begin,
            end: end,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );
      },
    );
  }

  // Stagger Animation Helper
  static Animation<double> staggerAnimation(
    AnimationController controller,
    int index,
    int total, {
    Duration delay = const Duration(milliseconds: 100),
    Curve curve = easeOut,
  }) {
    final start = (index / total) * 0.5;
    final end = start + 0.5;

    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          start.clamp(0.0, 1.0),
          end.clamp(0.0, 1.0),
          curve: curve,
        ),
      ),
    );
  }

  // Shimmer Animation
  static Widget shimmerEffect({
    required Widget child,
    Color baseColor = const Color(0xFFE0E0E0),
    Color highlightColor = const Color(0xFFF5F5F5),
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return AnimatedBuilder(
      animation: AlwaysStoppedAnimation(0.0),
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.0, 0.5, 1.0],
              begin: const Alignment(-1.0, -0.3),
              end: const Alignment(1.0, 0.3),
            ),
          ),
          child: child,
        );
      },
    );
  }
}
