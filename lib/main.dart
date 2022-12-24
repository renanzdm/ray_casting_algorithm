// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: CustomPaint(
              size: const Size(200, 200),
              painter: PolygonPaint(
                points: [
                  const Offset(10, 100),
                  const Offset(0, 90),
                  const Offset(15, 176),
                  const Offset(43, 100),
                  const Offset(10, 100),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              size: const Size(200, 200),
              painter: PolygonGradient(
                points: const Offset(12, 98),
                polygon: [
                  const Offset(10, 100),
                  const Offset(0, 90),
                  const Offset(15, 176),
                  const Offset(43, 100),
                  const Offset(10, 100),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PolygonPaint extends CustomPainter {
  final List<Offset> points;

  PolygonPaint({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;
    canvas.drawPoints(PointMode.polygon, points, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PolygonGradient extends CustomPainter {
  final List<Offset> polygon;
  final Offset points;

  PolygonGradient({
    required this.points,
    this.polygon = const [],
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 3.0;
    for (var i = 0; i < 100000; i++) {
      var X = Random().nextDouble() * 450;
      var Y = Random().nextDouble() * 450;

      bool inside = rayCasting(Offset(X, Y), polygon);
      canvas.drawPoints(PointMode.points, [Offset(X, Y)], paint..color = inside ? Colors.yellow : Colors.transparent);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PointColor {
  final Offset offset;
  final Color color;
  PointColor({
    required this.offset,
    required this.color,
  });
}

bool rayCasting(Offset point, List<Offset> polygon) {
  final int pointsOfPolygon = polygon.length;
  int count = 0;
  final double searchY = point.dy;
  final double searchX = point.dx;
  for (int i = 0; i < pointsOfPolygon - 1; ++i) {
    final Offset p1 = Offset(polygon[i].dx, polygon[i].dy);
    final Offset p2 = Offset(polygon[i + 1].dx, polygon[i + 1].dy);
    final double y1 = p1.dy;
    final double y2 = p2.dy;
    final double x1 = p1.dx;
    final double x2 = p2.dx;

    if (searchY < y1 != searchY < y2 && searchX < (x2 - x1) * (searchY - y1) / (y2 - y1) + x1) {
      count++;
    }
  }
  return count.isOdd;
}
