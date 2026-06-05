import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final Color? primaryColor;
  final Color? secondaryColor;
  final bool showBubbles;
  final bool showStars;
  final bool showParticles;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.primaryColor,
    this.secondaryColor,
    this.showBubbles = true,
    this.showStars = true,
    this.showParticles = false,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _bubblesController;
  late AnimationController _starsController;
  late AnimationController _particlesController;
  
  final List<Bubble> _bubbles = [];
  final List<Star> _stars = [];
  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    
    _bubblesController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _starsController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
    
    _particlesController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    
    _generateBubbles();
    _generateStars();
    _generateParticles();
  }

  void _generateBubbles() {
    final random = math.Random();
    for (int i = 0; i < 15; i++) {
      _bubbles.add(Bubble(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 60 + 20,
        speed: random.nextDouble() * 0.5 + 0.2,
        opacity: random.nextDouble() * 0.3 + 0.1,
        phase: random.nextDouble() * 2 * math.pi,
      ));
    }
  }

  void _generateStars() {
    final random = math.Random();
    for (int i = 0; i < 30; i++) {
      _stars.add(Star(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 3 + 1,
        twinkleSpeed: random.nextDouble() * 2 + 1,
        phase: random.nextDouble() * 2 * math.pi,
        brightness: random.nextDouble() * 0.8 + 0.2,
      ));
    }
  }

  void _generateParticles() {
    final random = math.Random();
    for (int i = 0; i < 50; i++) {
      _particles.add(Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 2 + 0.5,
        speedX: (random.nextDouble() - 0.5) * 0.1,
        speedY: (random.nextDouble() - 0.5) * 0.1,
        life: random.nextDouble(),
        maxLife: random.nextDouble() * 5 + 2,
      ));
    }
  }

  @override
  void dispose() {
    _bubblesController.dispose();
    _starsController.dispose();
    _particlesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient Background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.primaryColor ?? const Color(0xFF667eea),
                widget.secondaryColor ?? const Color(0xFF764ba2),
              ],
            ),
          ),
        ),
        
        // Animated Bubbles
        if (widget.showBubbles)
          AnimatedBuilder(
            animation: _bubblesController,
            builder: (context, child) {
              return CustomPaint(
                painter: BubblesPainter(
                  bubbles: _bubbles,
                  animationValue: _bubblesController.value,
                ),
                size: Size.infinite,
              );
            },
          ),
        
        // Animated Stars
        if (widget.showStars)
          AnimatedBuilder(
            animation: _starsController,
            builder: (context, child) {
              return CustomPaint(
                painter: StarsPainter(
                  stars: _stars,
                  animationValue: _starsController.value,
                ),
                size: Size.infinite,
              );
            },
          ),
        
        // Animated Particles
        if (widget.showParticles)
          AnimatedBuilder(
            animation: _particlesController,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlesPainter(
                  particles: _particles,
                  animationValue: _particlesController.value,
                ),
                size: Size.infinite,
              );
            },
          ),
        
        // Child content
        widget.child,
      ],
    );
  }
}

class Bubble {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double opacity;
  final double phase;

  Bubble({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.phase,
  });
}

class Star {
  final double x;
  final double y;
  final double size;
  final double twinkleSpeed;
  final double phase;
  final double brightness;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.twinkleSpeed,
    required this.phase,
    required this.brightness,
  });
}

class Particle {
  final double x;
  final double y;
  final double size;
  final double speedX;
  final double speedY;
  final double life;
  final double maxLife;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.life,
    required this.maxLife,
  });
}

class BubblesPainter extends CustomPainter {
  final List<Bubble> bubbles;
  final double animationValue;

  BubblesPainter({required this.bubbles, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    for (final bubble in bubbles) {
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: bubble.opacity)
        ..style = PaintingStyle.fill;
      
      // Calculate animated position
      final animatedY = (bubble.y - bubble.speed * animationValue) % 1.2;
      final animatedX = bubble.x + 
          0.1 * math.sin(bubble.phase + animationValue * 2 * math.pi);
      
      // Skip if bubble is off screen
      if (animatedY > 1.1) continue;
      
      final center = Offset(
        animatedX * size.width,
        animatedY * size.height,
      );
      
      // Draw bubble with gradient effect
      final gradient = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: bubble.opacity * 0.8),
          Colors.white.withValues(alpha: bubble.opacity * 0.2),
          Colors.transparent,
        ],
        stops: const [0.0, 0.7, 1.0],
      );
      
      paint.shader = gradient.createShader(
        Rect.fromCenter(center: center, width: bubble.size, height: bubble.size),
      );
      
      canvas.drawCircle(center, bubble.size / 2, paint);
      
      // Draw bubble highlight
      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: bubble.opacity * 0.6)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        center + Offset(-bubble.size * 0.2, -bubble.size * 0.2),
        bubble.size * 0.15,
        highlightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(BubblesPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class StarsPainter extends CustomPainter {
  final List<Star> stars;
  final double animationValue;

  StarsPainter({required this.stars, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      // Calculate twinkling effect
      final twinkle = math.sin(star.phase + animationValue * star.twinkleSpeed * 2 * math.pi);
      final currentBrightness = star.brightness + (twinkle * 0.3);
      final currentSize = star.size + (twinkle * 0.5);
      
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: currentBrightness)
        ..style = PaintingStyle.fill;
      
      final center = Offset(star.x * size.width, star.y * size.height);
      
      // Draw star as a cross
      final path = Path();
      final halfSize = currentSize / 2;
      
      // Vertical line
      path.moveTo(center.dx, center.dy - halfSize);
      path.lineTo(center.dx, center.dy + halfSize);
      
      // Horizontal line
      path.moveTo(center.dx - halfSize, center.dy);
      path.lineTo(center.dx + halfSize, center.dy);
      
      // Diagonal lines for sparkle effect
      if (currentBrightness > 0.6) {
        final diagonalSize = halfSize * 0.7;
        path.moveTo(center.dx - diagonalSize, center.dy - diagonalSize);
        path.lineTo(center.dx + diagonalSize, center.dy + diagonalSize);
        
        path.moveTo(center.dx + diagonalSize, center.dy - diagonalSize);
        path.lineTo(center.dx - diagonalSize, center.dy + diagonalSize);
      }
      
      paint.strokeWidth = 1.0;
      paint.style = PaintingStyle.stroke;
      paint.strokeCap = StrokeCap.round;
      
      canvas.drawPath(path, paint);
      
      // Add glow effect for bright stars
      if (currentBrightness > 0.7) {
        final glowPaint = Paint()
          ..color = Colors.white.withValues(alpha: currentBrightness * 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        
        canvas.drawCircle(center, currentSize, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(StarsPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class ParticlesPainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlesPainter({required this.particles, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      // Calculate particle life cycle
      final currentLife = (particle.life + animationValue * particle.maxLife) % particle.maxLife;
      final lifeProgress = currentLife / particle.maxLife;
      
      // Fade out particles as they age
      final opacity = math.sin(lifeProgress * math.pi);
      
      if (opacity <= 0) continue;
      
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: opacity * 0.5)
        ..style = PaintingStyle.fill;
      
      // Calculate animated position
      final animatedX = (particle.x + particle.speedX * animationValue) % 1.0;
      final animatedY = (particle.y + particle.speedY * animationValue) % 1.0;
      
      final center = Offset(animatedX * size.width, animatedY * size.height);
      
      // Vary size based on life cycle
      final currentSize = particle.size * (1.0 - lifeProgress * 0.5);
      
      canvas.drawCircle(center, currentSize, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

// Specialized animated backgrounds for different themes

class CosmicAnimatedBackground extends AnimatedBackground {
  const CosmicAnimatedBackground({
    super.key,
    required super.child,
  }) : super(
    primaryColor: const Color(0xFF0F0C29),
    secondaryColor: const Color(0xFF24243e),
    showBubbles: false,
    showStars: true,
    showParticles: true,
  );
}

class OceanAnimatedBackground extends AnimatedBackground {
  const OceanAnimatedBackground({
    super.key,
    required super.child,
  }) : super(
    primaryColor: const Color(0xFF667eea),
    secondaryColor: const Color(0xFF764ba2),
    showBubbles: true,
    showStars: false,
    showParticles: false,
  );
}

class SunsetAnimatedBackground extends AnimatedBackground {
  const SunsetAnimatedBackground({
    super.key,
    required super.child,
  }) : super(
    primaryColor: const Color(0xFFfa709a),
    secondaryColor: const Color(0xFFfee140),
    showBubbles: true,
    showStars: true,
    showParticles: false,
  );
}

class ForestAnimatedBackground extends AnimatedBackground {
  const ForestAnimatedBackground({
    super.key,
    required super.child,
  }) : super(
    primaryColor: const Color(0xFF11998e),
    secondaryColor: const Color(0xFF38ef7d),
    showBubbles: false,
    showStars: false,
    showParticles: true,
  );
}