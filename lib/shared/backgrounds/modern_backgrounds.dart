import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

enum BackgroundType {
  mesh,
  aurora,
  polar,
  gradientBlur,
  galaxy,
  ocean,
  sunset,
  neon,
}

class ModernBackground extends StatelessWidget {
  final BackgroundType type;
  final Widget child;
  final double? intensity;
  final List<Color>? customColors;

  const ModernBackground({
    super.key,
    required this.type,
    required this.child,
    this.intensity,
    this.customColors,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _getBackground(),
        child,
      ],
    );
  }

  Widget _getBackground() {
    switch (type) {
      case BackgroundType.mesh:
        return GradientMeshBackground(
          intensity: intensity ?? 0.3,
          colors: customColors,
        );
      case BackgroundType.aurora:
        return AuroraBackground(
          intensity: intensity ?? 0.4,
          colors: customColors,
        );
      case BackgroundType.polar:
        return PolarBackground(
          intensity: intensity ?? 0.5,
          colors: customColors,
        );
      case BackgroundType.gradientBlur:
        return GradientBlurBackground(
          intensity: intensity ?? 0.6,
          colors: customColors,
        );
      case BackgroundType.galaxy:
        return GalaxyBackground(
          intensity: intensity ?? 0.4,
          colors: customColors,
        );
      case BackgroundType.ocean:
        return OceanBackground(
          intensity: intensity ?? 0.3,
          colors: customColors,
        );
      case BackgroundType.sunset:
        return SunsetBackground(
          intensity: intensity ?? 0.5,
          colors: customColors,
        );
      case BackgroundType.neon:
        return NeonBackground(
          intensity: intensity ?? 0.4,
          colors: customColors,
        );
    }
  }
}

// Mesh Background (Based on your example)
class GradientMeshBackground extends StatefulWidget {
  final double intensity;
  final List<Color>? colors;

  const GradientMeshBackground({
    super.key,
    this.intensity = 0.3,
    this.colors,
  });

  @override
  State<GradientMeshBackground> createState() => _GradientMeshBackgroundState();
}

class _GradientMeshBackgroundState extends State<GradientMeshBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color pastelRainbowColor(double t, double alpha) {
    final r = (sin(2 * pi * t) * 127 + 128).toInt();
    final g = (sin(2 * pi * (t + 1 / 3)) * 127 + 128).toInt();
    final b = (sin(2 * pi * (t + 2 / 3)) * 127 + 128).toInt();
    final pastelR = ((r + 255) ~/ 2);
    final pastelG = ((g + 255) ~/ 2);
    final pastelB = ((b + 255) ~/ 2);
    return Color.fromARGB(
      (alpha * 255).toInt(),
      pastelR,
      pastelG,
      pastelB,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          final t = _controller.value;
          final size = MediaQuery.of(context).size;

          final centers = [
            Offset(
              size.width * (0.22 + 0.06 * sin(t * 2 * pi)),
              size.height * (0.25 + 0.09 * cos(t * 2 * pi)),
            ),
            Offset(
              size.width * (0.80 + 0.08 * cos(t * 2 * pi + pi / 2)),
              size.height * (0.48 + 0.06 * sin(t * 2 * pi + pi / 2)),
            ),
            Offset(
              size.width * (0.43 + 0.07 * cos(t * 2 * pi + pi)),
              size.height * (0.77 + 0.07 * sin(t * 2 * pi + pi)),
            ),
            Offset(
              size.width * (0.68 + 0.08 * sin(t * 2 * pi + pi / 4)),
              size.height * (0.22 + 0.05 * cos(t * 2 * pi + pi / 4)),
            ),
            Offset(
              size.width * (0.13 + 0.05 * cos(t * 2 * pi + pi / 1.3)),
              size.height * (0.65 + 0.07 * sin(t * 2 * pi + pi / 1.7)),
            ),
          ];

          return CustomPaint(
            size: size,
            painter: _MeshPainter(
              centers: centers,
              intensity: widget.intensity,
              t: t,
              customColors: widget.colors,
            ),
          );
        },
      ),
    );
  }
}

class _MeshPainter extends CustomPainter {
  final List<Offset> centers;
  final double intensity;
  final double t;
  final List<Color>? customColors;

  _MeshPainter({
    required this.centers,
    required this.intensity,
    required this.t,
    this.customColors,
  });

  Color pastelRainbowColor(double t, double alpha) {
    final r = (sin(2 * pi * t) * 127 + 128).toInt();
    final g = (sin(2 * pi * (t + 1 / 3)) * 127 + 128).toInt();
    final b = (sin(2 * pi * (t + 2 / 3)) * 127 + 128).toInt();
    final pastelR = ((r + 255) ~/ 2);
    final pastelG = ((g + 255) ~/ 2);
    final pastelB = ((b + 255) ~/ 2);
    return Color.fromARGB(
      (alpha * 255).toInt(),
      pastelR,
      pastelG,
      pastelB,
    );
  }


  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

    final radii = [
      size.width * 0.57,
      size.width * 0.38,
      size.width * 0.43,
      size.width * 0.3,
      size.width * 0.33,
    ];

    final blurSigmas = [95.0, 65.0, 75.0, 55.0, 58.0];

    for (int i = 0; i < centers.length; i++) {
      final rect = Rect.fromCircle(center: centers[i], radius: radii[i]);
      
      List<Color> colors;
      if (customColors != null && customColors!.length >= 2) {
        colors = [
          customColors![i % customColors!.length].withValues(alpha: intensity),
          customColors![(i + 1) % customColors!.length].withValues(alpha: intensity),
        ];
      } else {
        colors = [
          pastelRainbowColor(t + i * 0.2, intensity),
          pastelRainbowColor((t + 0.13 + i * 0.2) % 1.0, intensity),
        ];
      }

      final gradient = RadialGradient(
        colors: colors,
        stops: const [0.0, 1.0],
      );
      final paint = Paint()
        ..shader = gradient.createShader(rect)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigmas[i]);
      canvas.drawCircle(centers[i], radii[i], paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MeshPainter oldDelegate) => true;
}

// Aurora Background
class AuroraBackground extends StatefulWidget {
  final double intensity;
  final List<Color>? colors;

  const AuroraBackground({
    super.key,
    this.intensity = 0.4,
    this.colors,
  });

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return CustomPaint(
            size: MediaQuery.of(context).size,
            painter: _AuroraPainter(
              t: _controller.value,
              intensity: widget.intensity,
              customColors: widget.colors,
            ),
          );
        },
      ),
    );
  }
}

class _AuroraPainter extends CustomPainter {
  final double t;
  final double intensity;
  final List<Color>? customColors;

  _AuroraPainter({
    required this.t,
    required this.intensity,
    this.customColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Dark background for aurora
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF0a0a0f),
    );

    final defaultColors = [
      const Color(0xFF00ff88),
      const Color(0xFF0088ff),
      const Color(0xFFff0088),
      const Color(0xFF88ff00),
    ];

    final colors = customColors ?? defaultColors;

    // Draw aurora waves
    for (int wave = 0; wave < 4; wave++) {
      final path = Path();
      final waveOffset = wave * pi / 2;
      final amplitude = size.height * (0.15 + wave * 0.05);
      final frequency = 3.0 + wave * 0.5;
      
      path.moveTo(0, size.height / 2);
      
      for (double x = 0; x <= size.width; x += 2) {
        final y = size.height / 2 + 
                  amplitude * sin(frequency * x / size.width * 2 * pi + t * 2 * pi + waveOffset);
        path.lineTo(x, y);
      }

      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();

      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          colors[wave % colors.length].withValues(alpha: intensity),
          colors[wave % colors.length].withValues(alpha: 0.0),
        ],
      );

      final paint = Paint()
        ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _AuroraPainter oldDelegate) => true;
}

// Polar Background
class PolarBackground extends StatefulWidget {
  final double intensity;
  final List<Color>? colors;

  const PolarBackground({
    super.key,
    this.intensity = 0.5,
    this.colors,
  });

  @override
  State<PolarBackground> createState() => _PolarBackgroundState();
}

class _PolarBackgroundState extends State<PolarBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return CustomPaint(
            size: MediaQuery.of(context).size,
            painter: _PolarPainter(
              t: _controller.value,
              intensity: widget.intensity,
              customColors: widget.colors,
            ),
          );
        },
      ),
    );
  }
}

class _PolarPainter extends CustomPainter {
  final double t;
  final double intensity;
  final List<Color>? customColors;

  _PolarPainter({
    required this.t,
    required this.intensity,
    this.customColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Icy background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFeef7ff),
    );

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width > size.height ? size.width : size.height;

    final defaultColors = [
      const Color(0xFF87ceeb),
      const Color(0xFFb0e0e6),
      const Color(0xFFffffff),
      const Color(0xFFe0f6ff),
    ];

    final colors = customColors ?? defaultColors;

    // Draw concentric circles with polar effect
    for (int i = 0; i < 8; i++) {
      final radius = maxRadius * (0.2 + i * 0.15 + 0.05 * sin(t * 2 * pi + i));
      final colorIndex = i % colors.length;
      
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            colors[colorIndex].withValues(alpha: intensity * 0.3),
            colors[colorIndex].withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 30 + i * 5);

      canvas.drawCircle(center, radius, paint);
    }

    // Add sparkle effect
    final random = Random(42); // Fixed seed for consistent pattern
    for (int i = 0; i < 50; i++) {
      final sparkleT = (t + i * 0.1) % 1.0;
      final alpha = (sin(sparkleT * 2 * pi) + 1) / 2;
      
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: alpha * intensity * 0.8)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      canvas.drawCircle(Offset(x, y), 1 + alpha * 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PolarPainter oldDelegate) => true;
}

// Gradient Blur Background
class GradientBlurBackground extends StatelessWidget {
  final double intensity;
  final List<Color>? colors;

  const GradientBlurBackground({
    super.key,
    this.intensity = 0.6,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColors = [
      const Color(0xFFff6b6b),
      const Color(0xFF4ecdc4),
      const Color(0xFF45b7d1),
      const Color(0xFF96ceb4),
      const Color(0xFFfeca57),
    ];

    final backgroundColors = colors ?? defaultColors;

    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: backgroundColors
                .map((c) => c.withValues(alpha: intensity))
                .toList(),
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
        ),
      ),
    );
  }
}

// Galaxy Background
class GalaxyBackground extends StatefulWidget {
  final double intensity;
  final List<Color>? colors;

  const GalaxyBackground({
    super.key,
    this.intensity = 0.4,
    this.colors,
  });

  @override
  State<GalaxyBackground> createState() => _GalaxyBackgroundState();
}

class _GalaxyBackgroundState extends State<GalaxyBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return CustomPaint(
            size: MediaQuery.of(context).size,
            painter: _GalaxyPainter(
              t: _controller.value,
              intensity: widget.intensity,
              customColors: widget.colors,
            ),
          );
        },
      ),
    );
  }
}

class _GalaxyPainter extends CustomPainter {
  final double t;
  final double intensity;
  final List<Color>? customColors;

  _GalaxyPainter({
    required this.t,
    required this.intensity,
    this.customColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Deep space background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF0f0f23),
    );

    final center = Offset(size.width / 2, size.height / 2);
    final random = Random(42);

    final defaultColors = [
      const Color(0xFFff6b9d),
      const Color(0xFF9b59b6),
      const Color(0xFF3742fa),
      const Color(0xFF00d2d3),
    ];

    final colors = customColors ?? defaultColors;

    // Draw spiral galaxy
    for (double angle = 0; angle < 4 * pi; angle += 0.1) {
      final spiralRadius = 50 + angle * 20 + 30 * sin(t * 2 * pi);
      final spiralAngle = angle + t * 2 * pi;
      
      final x = center.dx + spiralRadius * cos(spiralAngle);
      final y = center.dy + spiralRadius * sin(spiralAngle);
      
      if (x >= 0 && x <= size.width && y >= 0 && y <= size.height) {
        final colorIndex = (angle ~/ (pi / 2)) % colors.length;
        final alpha = intensity * (1 - angle / (4 * pi)) * 0.8;
        
        final paint = Paint()
          ..color = colors[colorIndex].withValues(alpha: alpha)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

        canvas.drawCircle(Offset(x, y), 2 + alpha * 3, paint);
      }
    }

    // Add stars
    for (int i = 0; i < 200; i++) {
      final starT = (t + i * 0.01) % 1.0;
      final twinkle = (sin(starT * 4 * pi) + 1) / 2;
      
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: twinkle * intensity * 0.9)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);

      canvas.drawCircle(Offset(x, y), 0.5 + twinkle, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GalaxyPainter oldDelegate) => true;
}

// Ocean Background
class OceanBackground extends StatefulWidget {
  final double intensity;
  final List<Color>? colors;

  const OceanBackground({
    super.key,
    this.intensity = 0.3,
    this.colors,
  });

  @override
  State<OceanBackground> createState() => _OceanBackgroundState();
}

class _OceanBackgroundState extends State<OceanBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return CustomPaint(
            size: MediaQuery.of(context).size,
            painter: _OceanPainter(
              t: _controller.value,
              intensity: widget.intensity,
              customColors: widget.colors,
            ),
          );
        },
      ),
    );
  }
}

class _OceanPainter extends CustomPainter {
  final double t;
  final double intensity;
  final List<Color>? customColors;

  _OceanPainter({
    required this.t,
    required this.intensity,
    this.customColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final defaultColors = [
      const Color(0xFF0077be),
      const Color(0xFF00a8cc),
      const Color(0xFF40e0d0),
      const Color(0xFF87ceeb),
    ];

    final colors = customColors ?? defaultColors;

    // Ocean gradient background
    final backgroundGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        colors[0].withValues(alpha: intensity),
        colors[1].withValues(alpha: intensity),
      ],
    );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = backgroundGradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      ),
    );

    // Draw ocean waves
    for (int wave = 0; wave < 5; wave++) {
      final path = Path();
      final waveHeight = size.height * (0.6 + wave * 0.05);
      final amplitude = 20 + wave * 5;
      final frequency = 2 + wave * 0.3;
      final phase = t * 2 * pi + wave * pi / 3;

      path.moveTo(0, waveHeight);

      for (double x = 0; x <= size.width; x += 2) {
        final y = waveHeight + amplitude * sin(frequency * x / 100 + phase);
        path.lineTo(x, y);
      }

      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();

      final waveGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          colors[(wave + 2) % colors.length].withValues(alpha: intensity * 0.4),
          colors[(wave + 2) % colors.length].withValues(alpha: 0.0),
        ],
      );

      final paint = Paint()
        ..shader = waveGradient.createShader(
          Rect.fromLTWH(0, waveHeight - amplitude, size.width, size.height),
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _OceanPainter oldDelegate) => true;
}

// Sunset Background
class SunsetBackground extends StatelessWidget {
  final double intensity;
  final List<Color>? colors;

  const SunsetBackground({
    super.key,
    this.intensity = 0.5,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColors = [
      const Color(0xFFff7f50),
      const Color(0xFFff6b9d),
      const Color(0xFFffa726),
      const Color(0xFFffb347),
      const Color(0xFFffd700),
    ];

    final backgroundColors = colors ?? defaultColors;

    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: backgroundColors
                .map((c) => c.withValues(alpha: intensity))
                .toList(),
          ),
        ),
      ),
    );
  }
}

// Neon Background
class NeonBackground extends StatefulWidget {
  final double intensity;
  final List<Color>? colors;

  const NeonBackground({
    super.key,
    this.intensity = 0.4,
    this.colors,
  });

  @override
  State<NeonBackground> createState() => _NeonBackgroundState();
}

class _NeonBackgroundState extends State<NeonBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return CustomPaint(
            size: MediaQuery.of(context).size,
            painter: _NeonPainter(
              t: _controller.value,
              intensity: widget.intensity,
              customColors: widget.colors,
            ),
          );
        },
      ),
    );
  }
}

class _NeonPainter extends CustomPainter {
  final double t;
  final double intensity;
  final List<Color>? customColors;

  _NeonPainter({
    required this.t,
    required this.intensity,
    this.customColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Dark background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF1a1a1a),
    );

    final defaultColors = [
      const Color(0xFFff0080),
      const Color(0xFF00ff80),
      const Color(0xFF8000ff),
      const Color(0xFF0080ff),
    ];

    final colors = customColors ?? defaultColors;

    // Draw neon grid
    final paint = Paint()..style = PaintingStyle.stroke;

    // Vertical lines
    for (int i = 0; i < 10; i++) {
      final x = size.width * i / 9;
      final opacity = (sin(t * 2 * pi + i) + 1) / 2;
      
      paint
        ..color = colors[i % colors.length].withValues(alpha: opacity * intensity)
        ..strokeWidth = 2
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (int i = 0; i < 6; i++) {
      final y = size.height * i / 5;
      final opacity = (cos(t * 2 * pi + i) + 1) / 2;
      
      paint
        ..color = colors[(i + 2) % colors.length].withValues(alpha: opacity * intensity)
        ..strokeWidth = 2
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NeonPainter oldDelegate) => true;
}