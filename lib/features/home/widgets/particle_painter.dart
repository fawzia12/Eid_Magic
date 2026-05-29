import 'package:flutter/material.dart';
import 'dart:math';

enum ParticleType { star, lantern, firework }

class ParticlePainter extends CustomPainter {
  final double animationValue;
  final List<Particle> particles;
  final double parallaxX;
  final double parallaxY;

  ParticlePainter(this.animationValue, this.particles, {this.parallaxX = 0, this.parallaxY = 0});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      if (particle.type == ParticleType.star) {
        _paintStar(canvas, size, particle);
      } else if (particle.type == ParticleType.lantern) {
        _paintLantern(canvas, size, particle);
      } else if (particle.type == ParticleType.firework) {
        _paintFirework(canvas, size, particle);
      }
    }
  }

  void _paintStar(Canvas canvas, Size size, Particle particle) {
    // Parallax shift for background depth
    double pX = particle.x + (parallaxX * particle.parallaxFactor * 100);
    double pY = particle.y + (parallaxY * particle.parallaxFactor * 100);

    // Flow upward
    double dy = pY - (animationValue * size.height * particle.speed);
    if (dy < -20) {
      dy = size.height + (dy % size.height);
    }
    
    double dx = pX + sin(animationValue * pi * 2 + particle.offset) * 10;

    // Twinkle effect
    double opacity = (sin(animationValue * pi * 4 + particle.offset) + 1) / 2;
    opacity = (opacity * 0.5) + 0.1; // Range: 0.1 to 0.6

    final paint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(opacity)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(dx, dy), particle.size, paint);
  }

  void _paintLantern(Canvas canvas, Size size, Particle particle) {
    double dy = particle.y - (animationValue * size.height * particle.speed * 0.5);
    if (dy < -50) dy = size.height + (dy % size.height);
    
    double dx = particle.x + sin(animationValue * pi + particle.offset) * 30;
    
    // Parallax
    dx += (parallaxX * particle.parallaxFactor * 150);
    dy += (parallaxY * particle.parallaxFactor * 150);

    double glowPulse = (sin(animationValue * pi * 2 + particle.offset) + 1) / 2;
    double opacity = (glowPulse * 0.4) + 0.4; // 0.4 to 0.8

    // Lantern Glow
    final glowPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(opacity * 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    
    // Lantern Body
    final bodyPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(opacity)
      ..style = PaintingStyle.fill;

    final rect = Rect.fromCenter(center: Offset(dx, dy), width: 12 * particle.size, height: 18 * particle.size);
    canvas.drawOval(rect, glowPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), bodyPaint);
  }

  void _paintFirework(Canvas canvas, Size size, Particle particle) {
    // Fireworks have a short lifespan based on animation cycle
    double cycle = (animationValue * particle.speed * 5 + particle.offset) % 1.0;
    
    if (cycle > 0.8) return; // Only show briefly

    double explosionProgress = cycle / 0.8;
    double radius = explosionProgress * 40 * particle.size;
    double opacity = 1.0 - (explosionProgress * explosionProgress);

    final paint = Paint()
      ..color = const Color(0xFF00FF88).withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 8; i++) {
      double angle = (i * pi / 4) + (animationValue * pi);
      double endX = particle.x + cos(angle) * radius;
      double endY = particle.y + sin(angle) * radius;
      
      // Parallax
      double pX = endX + (parallaxX * particle.parallaxFactor * 80);
      double pY = endY + (parallaxY * particle.parallaxFactor * 80);

      canvas.drawLine(
        Offset(
          particle.x + (parallaxX * particle.parallaxFactor * 80),
          particle.y + (parallaxY * particle.parallaxFactor * 80)
        ), 
        Offset(pX, pY), 
        paint
      );
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}

class Particle {
  double x;
  double y;
  double size;
  double speed;
  double offset;
  double parallaxFactor;
  ParticleType type;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.offset,
    required this.parallaxFactor,
    required this.type,
  });

  static List<Particle> generate(int count, Size size) {
    final random = Random();
    List<Particle> particles = [];

    // Stars (80% of particles)
    for (int i = 0; i < count * 0.8; i++) {
      particles.add(Particle(
        x: random.nextDouble() * size.width,
        y: random.nextDouble() * size.height,
        size: random.nextDouble() * 2 + 0.5,
        speed: random.nextDouble() * 0.2 + 0.1,
        offset: random.nextDouble() * pi * 2,
        parallaxFactor: random.nextDouble() * 0.5 + 0.5,
        type: ParticleType.star,
      ));
    }

    // Lanterns (15%)
    for (int i = 0; i < count * 0.15; i++) {
      particles.add(Particle(
        x: random.nextDouble() * size.width,
        y: random.nextDouble() * size.height,
        size: random.nextDouble() * 0.5 + 0.8,
        speed: random.nextDouble() * 0.3 + 0.2,
        offset: random.nextDouble() * pi * 2,
        parallaxFactor: random.nextDouble() * 0.3 + 0.7, // Lanterns are closer
        type: ParticleType.lantern,
      ));
    }

    // Fireworks (5%)
    for (int i = 0; i < count * 0.05; i++) {
      particles.add(Particle(
        x: random.nextDouble() * size.width,
        y: random.nextDouble() * size.height * 0.6, // Higher up in sky
        size: random.nextDouble() * 1.5 + 1.0,
        speed: random.nextDouble() * 0.5 + 0.5,
        offset: random.nextDouble() * pi * 2,
        parallaxFactor: random.nextDouble() * 0.8 + 0.2,
        type: ParticleType.firework,
      ));
    }

    return particles;
  }
}
