import 'dart:math';
import 'package:flutter/material.dart';

class AuraGradient extends StatefulWidget {
  final double stressIndex; // 0.0 to 1.0

  const AuraGradient({Key? key, required this.stressIndex}) : super(key: key);

  @override
  State<AuraGradient> createState() => _AuraGradientState();
}

class _AuraGradientState extends State<AuraGradient> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Animation speed depends on stress (higher stress = faster/more erratic fluid)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant AuraGradient oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stressIndex != widget.stressIndex) {
      // Adjust duration based on stress
      int newDurationSeconds = max(2, (10 - (widget.stressIndex * 8)).toInt());
      _controller.duration = Duration(seconds: newDurationSeconds);
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: FluidPainter(
            animationValue: _controller.value,
            stressIndex: widget.stressIndex,
          ),
          child: Container(),
        );
      },
    );
  }
}

class FluidPainter extends CustomPainter {
  final double animationValue;
  final double stressIndex;

  FluidPainter({required this.animationValue, required this.stressIndex});

  @override
  void paint(Canvas canvas, Size size) {
    // Colors based on stress index
    // Low stress: Cool blues and greens
    // High stress: Warm oranges and reds
    Color color1 = Color.lerp(Colors.teal.shade200, Colors.deepOrange.shade300, stressIndex)!;
    Color color2 = Color.lerp(Colors.blue.shade200, Colors.red.shade400, stressIndex)!;

    final Rect rect = Offset.zero & size;
    final Paint paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [color1, color2],
      ).createShader(rect);

    final Path path = Path();
    
    // Create fluid wave effect using Sine and Cosine waves
    double waveHeight = 20.0 + (stressIndex * 30.0); // Higher stress = higher waves
    double speed = animationValue * 2 * pi;

    path.moveTo(0, size.height * 0.5);
    for (double i = 0; i <= size.width; i++) {
      double y = sin((i / size.width * 2 * pi) + speed) * waveHeight +
                 cos((i / size.width * 3 * pi) - speed) * (waveHeight * 0.5);
      path.lineTo(i, (size.height * 0.5) + y);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawRect(rect, Paint()..color = Colors.black.withOpacity(0.05)); // Subtle background
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant FluidPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue || oldDelegate.stressIndex != stressIndex;
  }
}
