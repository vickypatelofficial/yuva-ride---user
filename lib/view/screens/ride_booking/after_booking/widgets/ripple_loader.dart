import 'package:flutter/material.dart'; 

class RippleLoader extends StatefulWidget {
  final double size;
  final Color color;
  final Widget? child;
  final int waves;
  final Duration duration;

  const RippleLoader({
    super.key,
    this.size = 60,
    this.color = Colors.blue,
    this.child,
    this.waves = 3,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<RippleLoader> createState() => _RippleLoaderState();
}

class _RippleLoaderState extends State<RippleLoader>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 3,
      height: widget.size * 3,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return CustomPaint(
            painter: RipplePainter(
              animationValue: _controller.value,
              color: widget.color,
              waves: widget.waves,
            ),
            child: Center(child: widget.child),
          );
        },
      ),
    );
  }
}

class RipplePainter extends CustomPainter {
  final double animationValue;
  final Color color;
  final int waves;

  RipplePainter({
    required this.animationValue,
    required this.color,
    required this.waves,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color;

    final double maxRadius = size.width / 2;

    for (int i = 0; i < waves; i++) {
      double progress = (animationValue + (i / waves)) % 1;
      double radius = progress * maxRadius;

      paint.color = color.withOpacity(1 - progress);

      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        radius,
        paint..strokeWidth = 4 * (1 - progress),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
