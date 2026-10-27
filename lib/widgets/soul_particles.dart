import 'dart:math';
import 'package:flutter/material.dart';

// ─── Particle Data ─────────────────────────────────────────────────────────────
class _Particle {
  double x, y, vx, vy, size, opacity, life;
  final Color color;

  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.opacity,
    required this.color,
    required this.life,
  });
}

// ─── Soul Particle Overlay ─────────────────────────────────────────────────────
class SoulParticleOverlay extends StatefulWidget {
  final String mood;
  const SoulParticleOverlay({super.key, this.mood = 'neutral'});

  @override
  State<SoulParticleOverlay> createState() => _SoulParticleOverlayState();
}

class _SoulParticleOverlayState extends State<SoulParticleOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final _rand = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _controller.addListener(_updateParticles);

    // Seed initial particles
    for (int i = 0; i < 20; i++) {
      _spawnParticle(immediate: true);
    }
  }

  Color get _particleColor {
    switch (widget.mood) {
      case 'happy':
      case 'blessed':
        return const Color(0xFF7F77DD);
      case 'hungry':
        return const Color(0xFFE05C5C);
      case 'cursed':
        return const Color(0xFF6A0DAD);
      case 'sad':
        return const Color(0xFF1D6E9E);
      default:
        return const Color(0xFF534AB7);
    }
  }

  void _spawnParticle({bool immediate = false}) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

    _particles.add(_Particle(
      x: _rand.nextDouble() * screenW,
      y: immediate
          ? _rand.nextDouble() * screenH
          : screenH + 10,
      vx: (_rand.nextDouble() - 0.5) * 0.8,
      vy: -(_rand.nextDouble() * 0.8 + 0.3),
      size: _rand.nextDouble() * 4 + 2,
      opacity: _rand.nextDouble() * 0.5 + 0.15,
      color: _particleColor,
      life: immediate ? _rand.nextDouble() : 1.0,
    ));
  }

  void _updateParticles() {
    if (!mounted) return;

    for (final p in _particles) {
      p.x += p.vx;
      p.y += p.vy;
      p.life -= 0.002;
      p.opacity = (p.life * 0.6).clamp(0, 1);
    }
    _particles.removeWhere((p) => p.life <= 0 || p.y < -20);

    // Spawn new particles
    if (_particles.length < 30 && _rand.nextDouble() < 0.3) {
      _spawnParticle();
    }

    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_updateParticles);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ParticlePainter(_particles),
      size: Size.infinite,
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()
        ..color = p.color.withValues(alpha: p.opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.size * 0.8);
      canvas.drawCircle(Offset(p.x, p.y), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true;
}

// ─── Background Realm Painter ──────────────────────────────────────────────────
class RealmBackground extends StatefulWidget {
  final String realmName;
  final String mood;

  const RealmBackground({
    super.key,
    required this.realmName,
    required this.mood,
  });

  @override
  State<RealmBackground> createState() => _RealmBackgroundState();
}

class _RealmBackgroundState extends State<RealmBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _shimmer = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
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
      builder: (_, _) => CustomPaint(
        painter: _RealmPainter(
          realmName: widget.realmName,
          mood: widget.mood,
          shimmer: _shimmer.value,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _RealmPainter extends CustomPainter {
  final String realmName;
  final String mood;
  final double shimmer;

  _RealmPainter({
    required this.realmName,
    required this.mood,
    required this.shimmer,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Base gradient
    final baseColors = _getRealmColors();
    final bg = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.0, -0.3),
        radius: 1.2,
        colors: baseColors,
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bg);

    // Shimmer vignette
    final vignette = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.9,
        colors: [
          Colors.transparent,
          Colors.black.withValues(alpha: 0.4 + shimmer * 0.15),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), vignette);

    // Realm-specific ground mist
    _drawMist(canvas, w, h, baseColors[0]);

    // Stars / runes in background
    if (realmName == 'Tartarus' || realmName == 'Purgatorio') {
      _drawRunes(canvas, w, h);
    }
  }

  List<Color> _getRealmColors() {
    switch (realmName) {
      case 'Elysium':
        return [
          const Color(0xFF1A1060),
          const Color(0xFF0D0B1A),
        ];
      case 'Limbo':
        return [
          const Color(0xFF0F1520),
          const Color(0xFF0D0B1A),
        ];
      case 'Purgatorio':
        return [
          const Color(0xFF1A0820),
          const Color(0xFF0D0B1A),
        ];
      case 'Tartarus':
        return [
          const Color(0xFF1A0808),
          const Color(0xFF0D0B1A),
        ];
      default:
        return [
          const Color(0xFF0D0B1A),
          const Color(0xFF0D0B1A),
        ];
    }
  }

  void _drawMist(Canvas canvas, double w, double h, Color color) {
    final mistPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          color.withValues(alpha: 0.2),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, h * 0.6, w, h * 0.4), mistPaint);
  }

  void _drawRunes(Canvas canvas, double w, double h) {
    final runes = ['ᚱ', 'ᚾ', 'ᛟ', 'ᛗ', 'ᚹ', 'ᛒ'];
    final rand = Random(42); // Fixed seed for stable positions
    final runePaint = TextStyle(
      color: const Color(0xFF534AB7).withValues(alpha: 0.08),
      fontSize: 22,
      fontWeight: FontWeight.w300,
    );

    for (int i = 0; i < 12; i++) {
      final tp = TextPainter(
        text: TextSpan(
          text: runes[rand.nextInt(runes.length)],
          style: runePaint,
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(rand.nextDouble() * w, rand.nextDouble() * h * 0.8),
      );
    }
  }

  @override
  bool shouldRepaint(_RealmPainter old) =>
      old.realmName != realmName || old.shimmer != shimmer;
}
