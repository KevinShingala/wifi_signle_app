import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'dart:typed_data';

Future<Map<String, dynamic>> iconToUint8List(IconData icon,
    {int size = 100, Color color = Colors.blue}) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);

  final TextPainter textPainter = TextPainter(
    textDirection: TextDirection.ltr,
  )..text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: size.toDouble(),
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
        color: color,
      ),
    );

  textPainter.layout();
  textPainter.paint(canvas, Offset(0, 0));

  final ui.Image image =
      await pictureRecorder.endRecording().toImage(size, size);
  final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);

  return {
    "image": byteData!.buffer.asUint8List(),
    "width": image.width,
    "height": image.height,
  };
}
