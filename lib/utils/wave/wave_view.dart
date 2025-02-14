import 'package:flutter/material.dart';

import '../helper.dart';
import '../notice.dart';
import 'wave_line.dart';

/*
 * @description Wave View
 * @author zl
 * @date 2025/2/14 11:11
 */
class WaveView extends StatelessWidget {
  const WaveView({super.key});

  @override
  Widget build(BuildContext context) => Consumer<Helper>(
        builder: (context, helper) => ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: Colors.grey.shade100,
            margin: const EdgeInsets.only(top: 20),
            child: CustomPaint(
              size: const Size(double.infinity, 150),
              painter: _LinePainter(),
            ),
          ),
        ),
      );
}

class _LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var offset = DrawLine.instance.updateSize(size);
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    // Erase
    final paint2 = Paint()
      ..color = Colors.grey.shade100
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    Path path = Path();
    path.moveTo(-3, size.height + 1);
    for (var i = 0; i < offset.length; i++) {
      path.lineTo(offset[i].dx, offset[i].dy);
    }
    path.lineTo(offset.last.dx + 3, size.height + 1);
    path.close();
    canvas.drawPath(path, paint);
    var rect = Rect.fromPoints(DrawLine.instance.getStartX, DrawLine.instance.getEndX);
    canvas.drawRect(rect, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
