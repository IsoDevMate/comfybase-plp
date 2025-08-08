import 'package:flutter/material.dart';

class LoadingWidget extends StatefulWidget {
  final String message;
  final double size;
  final Color? color;

  const LoadingWidget({
    Key? key,
    this.message = 'Loading...',
    this.size = 40.0,
    this.color,
  }) : super(key: key);

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;
  final int _dotCount = 3;
  final double _maxDotSize = 12.0;
  final double _minDotSize = 4.0;
  final Duration _animationDuration = const Duration(milliseconds: 800);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _animationDuration)
      ..repeat();

    // Create staggered animations for each dot
    _animations = List.generate(
      _dotCount,
      (index) =>
          TweenSequence<double>([
            TweenSequenceItem(
              tween: Tween<double>(
                begin: _minDotSize,
                end: _maxDotSize,
              ).chain(CurveTween(curve: Curves.easeInOut)),
              weight: 1.0,
            ),
            TweenSequenceItem(
              tween: Tween<double>(
                begin: _maxDotSize,
                end: _minDotSize,
              ).chain(CurveTween(curve: Curves.easeInOut)),
              weight: 1.0,
            ),
          ]).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(index * 0.2, 1.0, curve: Curves.easeInOut),
            ),
          ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).primaryColor;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: widget.size,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _dotCount,
                (index) => AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Container(
                      width: _animations[index].value,
                      height: _animations[index].value,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          if (widget.message.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                widget.message,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
        ],
      ),
    );
  }
}
