import 'package:flutter/material.dart';
 
class PsikopompCharacter extends StatefulWidget {
  final String mood; 
  final double size;
 
  const PsikopompCharacter({
    super.key,
    this.mood = 'happy',
    this.size = 200,
  });
 
  @override
  State<PsikopompCharacter> createState() => _PsikopompCharacterState();
}
 
class _PsikopompCharacterState extends State<PsikopompCharacter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
 
  late Animation<double> _floatAnim;  
  late Animation<double> _blinkAnim;
  late Animation<double> _wispAnim; 
 
  @override
  void initState() {
    super.initState();
 
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat(reverse: true);
 
    _floatAnim = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
 
    _blinkAnim = Tween<double>(begin: 1.0, end: 0.08).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.88, 1.0, curve: Curves.easeIn),
      ),
    );
 
    _wispAnim = Tween<double>(begin: 6.0, end: -6.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
      builder: (context, _) {
        return SizedBox(
          width: widget.size,
          height: widget.size * 1.4,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 0,
                top: widget.size * 0.3 + _wispAnim.value,
                child: _buildWisp(widget.size * 0.12),
              ),
 
              Positioned(
                right: 0,
                top: widget.size * 0.25 - _wispAnim.value,
                child: _buildWisp(widget.size * 0.1),
              ),
 
              Transform.translate(
                offset: Offset(0, _floatAnim.value),
                child: CustomPaint(
                  size: Size(widget.size * 0.85, widget.size * 1.1),
                  painter: _PsikopompPainter(
                    mood: widget.mood,
                    blinkScale: _blinkAnim.value,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
 
  Widget _buildWisp(double size) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size * 0.5,
          height: size * 0.6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF5DCAA5).withValues(alpha: 0.3),
          ),
        ),
        Container(
          width: size * 0.7,
          height: size * 0.8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF1D9E75).withValues(alpha: 0.5),
          ),
        ),
        Container(
          width: size,
          height: size * 1.2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF0F6E56).withValues(alpha: 0.65),
          ),
        ),
      ],
    );
  }
}
 
class _PsikopompPainter extends CustomPainter {
  final String mood;
  final double blinkScale; 
 
  _PsikopompPainter({required this.mood, required this.blinkScale});
 
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2; 
    final cy = h * 0.42; 
 
    final body    = Paint()..color = const Color(0xFF2C2C2A);
    final dark    = Paint()..color = const Color(0xFF1a1630);
    final purple  = Paint()..color = const Color(0xFF7F77DD);
    final lPurple = Paint()..color = const Color(0xFFAFA9EC);
    final shadow  = Paint()..color = const Color(0xFF26215C).withValues(alpha: 0.25);
 
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, h * 0.92),
        width: w * 0.5,
        height: h * 0.05,
      ),
      shadow,
    );
 
    final cloak = Path()
      ..moveTo(cx - w * 0.4, cy + h * 0.08)
      ..quadraticBezierTo(cx - w * 0.45, cy + h * 0.32, cx - w * 0.1, cy + h * 0.42)
      ..quadraticBezierTo(cx, cy + h * 0.47, cx + w * 0.1, cy + h * 0.42)
      ..quadraticBezierTo(cx + w * 0.45, cy + h * 0.32, cx + w * 0.4, cy + h * 0.08)
      ..close(); 
    canvas.drawPath(cloak, dark);
 
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, cy),
        width: w * 0.78,
        height: h * 0.68,
      ),
      body,
    );
 
    _drawEar(canvas, cx - w * 0.3, cy - h * 0.27, isLeft: true, dark: dark, purple: purple);
 
    _drawEar(canvas, cx + w * 0.3, cy - h * 0.27, isLeft: false, dark: dark, purple: purple);
 
    _drawEye(canvas, cx - w * 0.17, cy - h * 0.04, w * 0.11, blinkScale, lPurple, purple);
    _drawEye(canvas, cx + w * 0.17, cy - h * 0.04, w * 0.11, blinkScale, lPurple, purple);
 
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - w * 0.24, cy + h * 0.07), width: w * 0.18, height: h * 0.07),
      Paint()..color = const Color(0xFFD4537E).withValues(alpha: 0.18),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + w * 0.24, cy + h * 0.07), width: w * 0.18, height: h * 0.07),
      Paint()..color = const Color(0xFFD4537E).withValues(alpha: 0.18),
    );
 
    _drawMouth(canvas, cx, cy + h * 0.13, w * 0.14, mood, purple);
 
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - w * 0.46, cy + h * 0.1), width: w * 0.2, height: h * 0.16),
      body,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + w * 0.46, cy + h * 0.1), width: w * 0.2, height: h * 0.16),
      body,
    );
 
    final sickle = Paint()
      ..color = const Color(0xFFEF9F27).withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final sicklePath = Path()
      ..moveTo(cx + w * 0.52, cy + h * 0.04)
      ..quadraticBezierTo(cx + w * 0.65, cy - h * 0.04, cx + w * 0.6, cy + h * 0.14);
    canvas.drawPath(sicklePath, sickle);
 
    if (mood == 'sleepy') {
      _drawText(canvas, 'z z Z', Offset(cx + w * 0.2, cy - h * 0.45),
          const Color(0xFF7F77DD), 13);
    }
  }
 
  void _drawEar(Canvas canvas, double x, double y,
      {required bool isLeft, required Paint dark, required Paint purple}) {
    final lean = isLeft ? -1.0 : 1.0;
    final ear = Path()
      ..moveTo(x - 10, y + 12)
      ..lineTo(x + lean * 18, y - 22)
      ..lineTo(x + 10, y + 12)
      ..close();
    canvas.drawPath(ear, dark);
 
    final inner = Path()
      ..moveTo(x - 5, y + 7)
      ..lineTo(x + lean * 10, y - 12)
      ..lineTo(x + 5, y + 7)
      ..close();
    canvas.drawPath(inner, Paint()..color = purple.color.withValues(alpha: 0.35));
  }
 
  void _drawEye(Canvas canvas, double x, double y, double r,
      double blinkScale, Paint white, Paint purple) {
    canvas.save();
    canvas.translate(x, y); 
    canvas.scale(1.0, blinkScale); 
 
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: r * 2, height: r * 1.9), white);
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: r * 1.3, height: r * 1.45), purple);
    canvas.drawCircle(Offset(0, r * 0.08), r * 0.55,
        Paint()..color = const Color(0xFF1a1630));
    canvas.drawCircle(Offset(-r * 0.3, -r * 0.35), r * 0.28,
        Paint()..color = Colors.white.withValues(alpha: 0.9));
 
    canvas.restore();
  }
 
  void _drawMouth(Canvas canvas, double x, double y, double r,
      String mood, Paint purple) {
    final paint = Paint()
      ..color = purple.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
 
    final path = Path();
    switch (mood) {
      case 'happy':
        path.moveTo(x - r, y);
        path.quadraticBezierTo(x, y + r * 0.9, x + r, y);
      case 'sad':
        path.moveTo(x - r, y + r * 0.6);
        path.quadraticBezierTo(x, y - r * 0.4, x + r, y + r * 0.6);
      case 'sleepy':
        path.moveTo(x - r * 0.7, y + r * 0.3);
        path.lineTo(x + r * 0.7, y + r * 0.3);
      case 'hungry':
        canvas.drawOval(
          Rect.fromCenter(center: Offset(x, y + r * 0.3), width: r, height: r * 0.65),
          Paint()..color = const Color(0xFF1a1630),
        );
        return;
      default: 
        path.moveTo(x - r * 0.65, y + r * 0.2);
        path.quadraticBezierTo(x, y + r * 0.6, x + r * 0.65, y + r * 0.2);
    }
    canvas.drawPath(path, paint);
  }
 
  void _drawText(Canvas canvas, String text, Offset offset, Color color, double fontSize) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: fontSize)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }
 
  @override
  bool shouldRepaint(_PsikopompPainter old) =>
      old.blinkScale != blinkScale || old.mood != mood;
}