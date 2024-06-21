import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final Duration duration;
  final VoidCallback? end;
  final bool iconlike;

  const LikeAnimation({
    Key? key,
    required this.child,
    required this.isAnimating,
    this.duration = const Duration(milliseconds: 150),
    this.end,
    this.iconlike = false,
  }) : super(key: key);

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        vsync: this,
        duration: Duration(microseconds: widget.duration.inMilliseconds));
    scale = Tween<double>(begin: 1, end: 1).animate(controller);
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      startAnimation();
    }
  }

  void startAnimation() async {
    if (widget.isAnimating || widget.iconlike) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(Duration(microseconds: 200));
    }
    if (widget.end != null) {
      widget.end!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: scale, child:  widget.child,);
  }
}
