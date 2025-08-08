import 'package:flutter/material.dart';

/// A utility class for handling animations and transitions
class AppAnimations {
  // Standard animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 350);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Standard animation curves
  static const Curve standardCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve decelerateCurve = Curves.decelerate;
  static const Curve accelerateCurve = Curves.accelerate;

  /// Creates a fade in animation
  static Widget fadeIn({
    required Widget child,
    Duration duration = mediumAnimation,
    Curve curve = standardCurve,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }

  /// Creates a slide in animation
  static Widget slideIn({
    required Widget child,
    Duration duration = mediumAnimation,
    Curve curve = standardCurve,
    Offset begin = const Offset(0, 0.1),
    Offset end = Offset.zero,
  }) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween(begin: begin, end: end),
      duration: duration,
      curve: curve,
      child: child,
      builder: (context, offset, child) {
        return Transform.translate(
          offset: offset,
          child: child,
        );
      },
    );
  }

  /// Creates a scale animation
  static Widget scaleIn({
    required Widget child,
    Duration duration = mediumAnimation,
    Curve curve = standardCurve,
    double begin = 0.9,
    double end = 1.0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: begin, end: end),
      duration: duration,
      curve: curve,
      child: child,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
    );
  }

  /// Creates a rotation animation
  static Widget rotateIn({
    required Widget child,
    Duration duration = mediumAnimation,
    Curve curve = standardCurve,
    double begin = -0.1,
    double end = 0.0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: begin, end: end),
      duration: duration,
      curve: curve,
      child: child,
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value,
          child: child,
        );
      },
    );
  }

  /// Creates a combination of animations
  static Widget combinedAnimation({
    required Widget child,
    bool fade = true,
    bool slide = true,
    bool scale = false,
    bool rotate = false,
    Duration duration = mediumAnimation,
    Curve curve = standardCurve,
  }) {
    Widget animatedChild = child;

    if (fade) {
      animatedChild = fadeIn(
        child: animatedChild,
        duration: duration,
        curve: curve,
      );
    }

    if (slide) {
      animatedChild = slideIn(
        child: animatedChild,
        duration: duration,
        curve: curve,
      );
    }

    if (scale) {
      animatedChild = scaleIn(
        child: animatedChild,
        duration: duration,
        curve: curve,
      );
    }

    if (rotate) {
      animatedChild = rotateIn(
        child: animatedChild,
        duration: duration,
        curve: curve,
      );
    }

    return animatedChild;
  }

  /// Creates an animated switcher with a custom transition
  static Widget animatedSwitcher({
    required Widget child,
    Key? key,
    Duration duration = mediumAnimation,
    Widget Function(Widget, Animation<double>)? transitionBuilder,
  }) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: transitionBuilder ?? 
          (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
      child: KeyedSubtree(
        key: key ?? ValueKey(child),
        child: child,
      ),
    );
  }

  /// Creates a staggered animation for a list of widgets
  static List<Widget> staggeredAnimation({
    required List<Widget> children,
    Duration duration = mediumAnimation,
    Duration delay = const Duration(milliseconds: 100),
    Curve curve = standardCurve,
    bool fade = true,
    bool slide = true,
    bool scale = false,
    bool rotate = false,
  }) {
    return children.asMap().entries.map((entry) {
      final index = entry.key;
      final child = entry.value;
      
      return AnimatedOpacity(
        opacity: 1.0,
        duration: duration,
        curve: curve,
        child: AnimatedSlide(
          offset: slide ? const Offset(0, 0.1) : Offset.zero,
          duration: duration,
          curve: curve,
          child: AnimatedScale(
            scale: scale ? 0.9 : 1.0,
            duration: duration,
            curve: curve,
            child: AnimatedRotation(
              turns: rotate ? -0.1 : 0.0,
              duration: duration,
              curve: curve,
              child: child,
            ),
          ),
        ),
      );
    }).toList();
  }

  /// Creates a shimmer loading effect
  static Widget shimmer({
    double width = double.infinity,
    double height = 16.0,
    double borderRadius = 4.0,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: baseColor ?? Colors.grey[300],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              colors: [
                baseColor ?? Colors.grey[300]!,
                highlightColor ?? Colors.grey[100]!,
                baseColor ?? Colors.grey[300]!,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: const Alignment(-1.0, -1.0),
              end: const Alignment(1.0, 1.0),
              tileMode: TileMode.clamp,
            ).createShader(rect);
          },
          child: Container(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Creates a bouncing animation
  static Widget bounce({
    required Widget child,
    Duration duration = const Duration(milliseconds: 800),
    double scale = 1.2,
    bool repeat = true,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 1.0 + (scale - 1.0) * value,
          child: child,
        );
      },
      onEnd: repeat ? () {
        // Restart the animation when it ends
        if (repeat) {
          // This will trigger a rebuild with the animation values reset
          (child.key as ValueKey?)?.value = Object();
        }
      } : null,
      child: child,
    );
  }
}
