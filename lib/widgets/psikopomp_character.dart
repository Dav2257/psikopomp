import 'dart:math';
import 'package:flutter/material.dart';

class PsikopompCharacter extends StatefulWidget {
  final String mood;
  final double size;
  final VoidCallback? onTap;

  const PsikopompCharacter({
    super.key,
    this.mood = 'neutral',
    this.size = 200,
    this.onTap,
  });

  @override
  State<PsikopompCharacter> createState() => _PsikopompCharacterState();
}

class _PsikopompCharacterState extends State<PsikopompCharacter>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _blinkController;
  late AnimationController _wispController;
  late AnimationController _cloakController;
  late AnimationController _tapController;
  late AnimationController _auraController;

  late Animation<double> _floatAnim;
  late Animation<double> _blinkAnim;
  late Animation<double> _wispAnim;
  late Animation<double> _cloakWave;
  late Animation<double> _tapScale;
  late Animation<double> _auraPulse;

  final _rand = Random();

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
    )..repeat(reverse: true);

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _wispController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);

    _cloakController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat(reverse: true);

    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _auraController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: -12.0, end: 12.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _blinkAnim = Tween<double>(begin: 1.0, end: 0.06).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeIn),
    );

    _wispAnim = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _wispController, curve: Curves.easeInOut),
    );

    _cloakWave = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _cloakController, curve: Curves.easeInOut),
    );

    _tapScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.88), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.88, end: 1.06), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.06, end: 1.0), weight: 20),
    ]).animate(CurvedAnimation(parent: _tapController, curve: Curves.easeOut));

    _auraPulse = Tween<double>(begin: 0.4, end: 0.9).animate(
      CurvedAnimation(parent: _auraController, curve: Curves.easeInOut),
    );

    // Auto blink
    _scheduleBlink();
  }

  void _scheduleBlink() async {
    if (!mounted) return;
    await Future.delayed(Duration(seconds: 2 + _rand.nextInt(4)));
    if (!mounted) return;
    await _blinkController.forward();
    await _blinkController.reverse();
    _scheduleBlink();
  }

  void _handleTap() {
    _tapController.forward(from: 0.0);
    widget.onTap?.call();
  }

  @override
  void dispose() {
    _floatController.dispose();
    _blinkController.dispose();
    _wispController.dispose();
    _cloakController.dispose();
    _tapController.dispose();
    _auraController.dispose();
    super.dispose();
  }

  Color get _moodAuraColor {
    switch (widget.mood) {
      case 'happy':
      case 'blessed':
        return const Color(0xFF7F77DD);
      case 'hungry':
        return const Color(0xFFE05C5C);
      case 'sad':
        return const Color(0xFF1D6E9E);
      case 'cursed':
        return const Color(0xFF6A0DAD);
      default:
        return const Color(0xFF534AB7);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _floatController,
          _blinkController,
          _wispController,
          _cloakController,
          _tapController,
          _auraController,
        ]),
        builder: (context, _) {
          return SizedBox(
            width: widget.size * 1.5,
            height: widget.size * 1.8,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // ─── Aura Glow ───────────────────────────────────────────────
                Positioned(
                  top: widget.size * 0.2,
                  child: Container(
                    width: widget.size * 0.9,
                    height: widget.size * 0.9,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _moodAuraColor.withValues(alpha: _auraPulse.value * 0.3),
                          blurRadius: 60,
                          spreadRadius: 20,
                        ),
                      ],
                    ),
                  ),
                ),

                // ─── Floating Wisps ───────────────────────────────────────────
                Positioned(
                  left: widget.size * 0.05,
                  top: widget.size * 0.4 + _wispAnim.value,
                  child: _buildWisp(widget.size * 0.14, _moodAuraColor),
                ),
                Positioned(
                  right: widget.size * 0.05,
                  top: widget.size * 0.3 - _wispAnim.value,
                  child: _buildWisp(widget.size * 0.10, _moodAuraColor),
                ),
                Positioned(
                  left: widget.size * 0.25,
                  top: widget.size * 0.08 + _wispAnim.value * 0.6,
                  child: _buildWisp(widget.size * 0.07, _moodAuraColor),
                ),

                // ─── Main Character Body ──────────────────────────────────────
                Transform.scale(
                  scale: _tapScale.value,
                  child: Transform.translate(
                    offset: Offset(0, _floatAnim.value),
                    child: CustomPaint(
                      size: Size(widget.size * 0.9, widget.size * 1.2),
                      painter: _GrimReaperPainter(
                        mood: widget.mood,
                        blinkScale: _blinkAnim.value,
                        cloakWave: _cloakWave.value,
                        auraColor: _moodAuraColor,
                      ),
                    ),
                  ),
                ),

                // ─── Ground Shadow ─────────────────────────────────────────────
                Positioned(
                  bottom: widget.size * 0.0,
                  child: Container(
                    width: widget.size * 0.55,
                    height: widget.size * 0.06,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: _moodAuraColor.withValues(alpha: 0.25 + _auraPulse.value * 0.1),
                          blurRadius: 24,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),

                // ─── Status effect particles ─────────────────────────────────
                if (widget.mood == 'blessed' || widget.mood == 'cursed')
                  ...List.generate(5, (i) => _buildStatusParticle(i)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWisp(double size, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size * 0.5,
          height: size * 0.5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.2),
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 8),
            ],
          ),
        ),
        Container(
          width: size * 0.7,
          height: size * 0.8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.4),
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 12),
            ],
          ),
        ),
        Container(
          width: size,
          height: size * 1.3,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.55),
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusParticle(int index) {
    final angle = (index / 5) * 2 * pi +
        _auraController.value * 2 * pi;
    final r = widget.size * 0.38;
    final cx = widget.size * 0.75;
    final cy = widget.size * 0.6;
    final x = cx + r * cos(angle);
    final y = cy + r * sin(angle) * 0.5;

    final color = widget.mood == 'blessed'
        ? const Color(0xFFFFD700)
        : const Color(0xFF8B00FF);

    return Positioned(
      left: x,
      top: y,
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [BoxShadow(color: color, blurRadius: 8)],
        ),
      ),
    );
  }
}

// ─── Custom Painter ─────────────────────────────────────────────────────────────
class _GrimReaperPainter extends CustomPainter {
  final String mood;
  final double blinkScale;
  final double cloakWave;
  final Color auraColor;

  _GrimReaperPainter({
    required this.mood,
    required this.blinkScale,
    required this.cloakWave,
    required this.auraColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h * 0.38;

    final darkPaint = Paint()..color = const Color(0xFF0D0B1A);
    final cloakPaint = Paint()..color = const Color(0xFF120F20);
    final bonePaint = Paint()..color = const Color(0xFFD4C8A8);
    final eyeWhitePaint = Paint()..color = const Color(0xFFEEEAFF);
    final eyeGlowPaint = Paint()
      ..color = auraColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    // ─── Cloak / Robe ───────────────────────────────────────────────────────
    final wave = cloakWave * 5;
    final cloak = Path()
      ..moveTo(cx - w * 0.42, cy + h * 0.05)
      ..cubicTo(
        cx - w * 0.5, cy + h * 0.25 + wave,
        cx - w * 0.38, cy + h * 0.52,
        cx - w * 0.08, cy + h * 0.58,
      )
      ..cubicTo(
        cx, cy + h * 0.62,
        cx, cy + h * 0.62,
        cx + w * 0.08, cy + h * 0.58,
      )
      ..cubicTo(
        cx + w * 0.38, cy + h * 0.52,
        cx + w * 0.5, cy + h * 0.25 - wave,
        cx + w * 0.42, cy + h * 0.05,
      )
      ..close();
    canvas.drawPath(cloak, cloakPaint);

    // Cloak inner shadow/highlight
    final cloakHighlight = Paint()
      ..color = auraColor.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(cloak, cloakHighlight);

    // Hood rim glow
    final hoodGlow = Paint()
      ..color = auraColor.withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy - h * 0.15), width: w * 0.7, height: h * 0.2),
      hoodGlow,
    );

    // ─── Hood ────────────────────────────────────────────────────────────────
    final hood = Path()
      ..moveTo(cx - w * 0.42, cy + h * 0.05)
      ..quadraticBezierTo(cx - w * 0.44, cy - h * 0.18, cx, cy - h * 0.28)
      ..quadraticBezierTo(cx + w * 0.44, cy - h * 0.18, cx + w * 0.42, cy + h * 0.05)
      ..close();
    canvas.drawPath(hood, darkPaint);

    // ─── Skull Face ──────────────────────────────────────────────────────────
    // Draw skull oval
    final skullPaint = Paint()..color = const Color(0xFF2A2840);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: w * 0.72, height: h * 0.56),
      skullPaint,
    );

    // Inner skull highlight
    final skullHighlight = Paint()
      ..color = const Color(0xFF3A3560).withValues(alpha: 0.5);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy - h * 0.03), width: w * 0.55, height: h * 0.35),
      skullHighlight,
    );

    // ─── Bone Cheekbones ─────────────────────────────────────────────────────
    _drawCheekbone(canvas, cx - w * 0.2, cy + h * 0.08, bonePaint);
    _drawCheekbone(canvas, cx + w * 0.2, cy + h * 0.08, bonePaint);

    // ─── Eyes ────────────────────────────────────────────────────────────────
    _drawEye(canvas, cx - w * 0.18, cy - h * 0.05, w * 0.105, blinkScale, eyeWhitePaint, eyeGlowPaint, auraColor, mood);
    _drawEye(canvas, cx + w * 0.18, cy - h * 0.05, w * 0.105, blinkScale, eyeWhitePaint, eyeGlowPaint, auraColor, mood);

    // ─── Nasal Cavity ─────────────────────────────────────────────────────────
    _drawNose(canvas, cx, cy + h * 0.04, w * 0.05, darkPaint);

    // ─── Mouth / Teeth ────────────────────────────────────────────────────────
    _drawMouth(canvas, cx, cy + h * 0.14, w * 0.16, mood, auraColor);

    // ─── Skeletal Arms ───────────────────────────────────────────────────────
    _drawArm(canvas, cx - w * 0.44, cy + h * 0.1, true, bonePaint, darkPaint, cloakPaint);
    _drawArm(canvas, cx + w * 0.44, cy + h * 0.1, false, bonePaint, darkPaint, cloakPaint);

    // ─── Scythe ───────────────────────────────────────────────────────────────
    _drawScythe(canvas, cx + w * 0.44, cy - h * 0.08, w, h, auraColor);

    // ─── Mood-based effects ───────────────────────────────────────────────────
    if (mood == 'hungry') {
      _drawHungerEffect(canvas, cx, cy - h * 0.3, auraColor);
    }
    if (mood == 'blessed') {
      _drawBlessedEffect(canvas, cx, cy, w, h);
    }
    if (mood == 'cursed') {
      _drawCursedEffect(canvas, cx, cy, w, h);
    }
  }

  void _drawCheekbone(Canvas canvas, double x, double y, Paint paint) {
    final p = Paint()
      ..color = bonePaint().color.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x, y), width: 22, height: 10),
      p,
    );
  }

  Paint bonePaint() => Paint()..color = const Color(0xFFD4C8A8);

  void _drawArm(Canvas canvas, double x, double y, bool isLeft,
      Paint bonePaint, Paint darkPaint, Paint cloakPaint) {
    final dir = isLeft ? -1.0 : 1.0;

    // Sleeve
    final sleeve = Path()
      ..moveTo(x, y - 10)
      ..quadraticBezierTo(x + dir * 18, y + 20, x + dir * 12, y + 50)
      ..quadraticBezierTo(x + dir * 5, y + 60, x, y + 55)
      ..quadraticBezierTo(x - dir * 5, y + 45, x - dir * 5, y + 15)
      ..close();
    canvas.drawPath(sleeve, cloakPaint);

    // Bone hand peeking
    final fingerPaint = Paint()
      ..color = bonePaint.color.withValues(alpha: 0.8)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final bx = x + dir * 10;
    final by = y + 55;
    canvas.drawLine(Offset(bx, by), Offset(bx + dir * 2, by + 12), fingerPaint);
    canvas.drawLine(Offset(bx + dir * 4, by + 2), Offset(bx + dir * 7, by + 14), fingerPaint);
    canvas.drawLine(Offset(bx + dir * 8, by + 3), Offset(bx + dir * 11, by + 12), fingerPaint);
  }

  void _drawScythe(Canvas canvas, double x, double y, double w, double h, Color color) {
    final shaft = Paint()
      ..color = const Color(0xFF8B6914)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Staff
    canvas.drawLine(
      Offset(x, y + h * 0.08),
      Offset(x + w * 0.15, y - h * 0.35),
      shaft,
    );

    // Blade glow
    final bladeGlow = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final blade = Paint()
      ..color = const Color(0xFFBBD4E8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final bladePath = Path()
      ..moveTo(x + w * 0.15, y - h * 0.35)
      ..cubicTo(
        x + w * 0.38, y - h * 0.52,
        x + w * 0.32, y - h * 0.18,
        x + w * 0.12, y - h * 0.1,
      );

    canvas.drawPath(bladePath, bladeGlow);
    canvas.drawPath(bladePath, blade);

    // Blade edge accent
    final edgePaint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(bladePath, edgePaint);
  }

  void _drawEye(Canvas canvas, double x, double y, double r, double blinkScale,
      Paint white, Paint glow, Color color, String mood) {
    canvas.save();
    canvas.translate(x, y);
    canvas.scale(1.0, blinkScale);

    // Eye socket shadow
    final socket = Paint()
      ..color = const Color(0xFF0D0B1A)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: r * 2.2, height: r * 2.0),
      socket,
    );

    // Iris/glow
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: r * 1.6, height: r * 1.7),
      Paint()..color = color.withValues(alpha: 0.3),
    );

    // Glowing pupil
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: r * 1.0, height: r * 1.1),
      glow,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: r * 0.7, height: r * 0.8),
      Paint()..color = color,
    );

    // Specular highlight
    canvas.drawCircle(
      Offset(-r * 0.28, -r * 0.3),
      r * 0.22,
      Paint()..color = Colors.white.withValues(alpha: 0.85),
    );

    // Angry eyebrows for cursed/hungry
    if (mood == 'cursed' || mood == 'hungry') {
      final browPaint = Paint()
        ..color = color
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      final isLeft = x < 0;
      canvas.drawLine(
        Offset(isLeft ? -r : r, -r * 1.2),
        Offset(isLeft ? r * 0.2 : -r * 0.2, -r * 1.5),
        browPaint,
      );
    }

    canvas.restore();
  }

  void _drawNose(Canvas canvas, double cx, double cy, double size, Paint dark) {
    final nose = Path()
      ..moveTo(cx, cy - size)
      ..lineTo(cx - size * 0.8, cy + size)
      ..lineTo(cx + size * 0.8, cy + size)
      ..close();
    canvas.drawPath(nose, Paint()..color = const Color(0xFF0D0B1A).withValues(alpha: 0.8));
  }

  void _drawMouth(Canvas canvas, double x, double y, double r, String mood, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final path = Path();
    switch (mood) {
      case 'happy':
      case 'blessed':
        path.moveTo(x - r, y);
        path.quadraticBezierTo(x, y + r * 1.1, x + r, y);
        _drawTeeth(canvas, x, y, r, color);
        break;
      case 'sad':
        path.moveTo(x - r, y + r * 0.7);
        path.quadraticBezierTo(x, y - r * 0.4, x + r, y + r * 0.7);
        break;
      case 'hungry':
        // Open mouth with teeth showing
        final mouth = Paint()..color = const Color(0xFF0D0B1A);
        canvas.drawOval(
          Rect.fromCenter(center: Offset(x, y + r * 0.3), width: r * 1.5, height: r),
          mouth,
        );
        _drawTeeth(canvas, x, y + r * 0.1, r * 0.7, color);
        return;
      case 'cursed':
        // Jagged cursed smile
        path.moveTo(x - r, y + r * 0.2);
        path.lineTo(x - r * 0.5, y - r * 0.2);
        path.lineTo(x, y + r * 0.4);
        path.lineTo(x + r * 0.5, y - r * 0.2);
        path.lineTo(x + r, y + r * 0.2);
        paint.color = const Color(0xFF8B00FF);
        break;
      default:
        path.moveTo(x - r * 0.7, y + r * 0.2);
        path.quadraticBezierTo(x, y + r * 0.55, x + r * 0.7, y + r * 0.2);
    }
    canvas.drawPath(path, paint);
  }

  void _drawTeeth(Canvas canvas, double x, double y, double r, Color color) {
    final toothPaint = Paint()..color = const Color(0xFFD4C8A8);
    for (int i = 0; i < 4; i++) {
      final tx = x - r * 0.6 + i * r * 0.4;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(tx, y, r * 0.3, r * 0.4),
          const Radius.circular(2),
        ),
        toothPaint,
      );
    }
  }

  void _drawHungerEffect(Canvas canvas, double cx, double cy, Color color) {
    // Draw hunger sweat drops
    for (int i = 0; i < 3; i++) {
      final dx = cx + (i - 1) * 15.0;
      final dy = cy + i * 8.0;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(dx, dy), width: 5, height: 8),
        Paint()..color = const Color(0xFFE05C5C).withValues(alpha: 0.5),
      );
    }
    _drawText(canvas, '💀 LAPAR!!', Offset(cx - 35, cy - 20), const Color(0xFFE05C5C), 11);
  }

  void _drawBlessedEffect(Canvas canvas, double cx, double cy, double w, double h) {
    final starPaint = Paint()..color = const Color(0xFFFFD700).withValues(alpha: 0.8);
    for (int i = 0; i < 6; i++) {
      final angle = i * pi / 3;
      final sx = cx + cos(angle) * w * 0.36;
      final sy = cy + sin(angle) * h * 0.22;
      canvas.drawCircle(Offset(sx, sy), 3, starPaint);
    }
  }

  void _drawCursedEffect(Canvas canvas, double cx, double cy, double w, double h) {
    final cursePaint = Paint()
      ..color = const Color(0xFF6A0DAD).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(Offset(cx, cy), w * (0.3 + i * 0.08), cursePaint);
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset, Color color, double fontSize) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: fontSize, fontWeight: FontWeight.w700)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(_GrimReaperPainter old) =>
      old.blinkScale != blinkScale ||
      old.mood != mood ||
      old.cloakWave != cloakWave ||
      old.auraColor != auraColor;
}