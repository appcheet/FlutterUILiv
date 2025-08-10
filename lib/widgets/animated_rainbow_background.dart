import 'package:flutter/material.dart';

class AnimatedRainbowBackground extends StatefulWidget {
  final Widget child;

  const AnimatedRainbowBackground({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedRainbowBackground> createState() =>
      _AnimatedRainbowBackgroundState();
}

class _AnimatedRainbowBackgroundState extends State<AnimatedRainbowBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late Animation<double> _animation1;
  late Animation<double> _animation2;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    );
    _controller2 = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    );

    _animation1 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller1, curve: Curves.easeInOut),
    );
    _animation2 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.easeInOut),
    );

    _controller1.repeat();
    _controller2.repeat();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_animation1, _animation2]),
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(
                  const Color(0xFF1a1a2e),
                  const Color(0xFF16213e),
                  (_animation1.value * 0.5) + 0.5,
                )!,
                Color.lerp(
                  const Color(0xFF16213e),
                  const Color(0xFF0f3460),
                  (_animation2.value * 0.3) + 0.5,
                )!,
                Color.lerp(
                  const Color(0xFF0f3460),
                  const Color(0xFF533483),
                  (_animation1.value * 0.4) + 0.3,
                )!,
              ],
              stops: [
                0.0,
                0.4 + (_animation2.value * 0.2),
                1.0,
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}