import 'dart:math' as Math;

import 'package:flutter/material.dart';

num degToRad(num deg) => deg * (Math.pi / 180.0);

num radToDeg(num rad) => rad * (180.0 / Math.pi);

double valueToAngle(double value, double min, double max, double angleRange) {
  return percentageToAngle(
      valueToPercentage(value - min, min, max), angleRange);
}

double valueToPercentage(double value, double min, double max) {
  return value / ((max - min) / 100);
}

double percentageToAngle(double percentage, double angleRange) {
  final step = angleRange / 100;
  if (percentage > 100) {
    return angleRange;
  } else if (percentage < 0) {
    return 0.5;
  }
  return percentage * step;
}

int valueToDuration(double value, double previous, double min, double max) {
  final divider = (max - min) / 100;
  return divider != 0 ? (value - previous).abs() ~/ divider * 15 : 0;
}

class CircleProgressBar extends StatefulWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final int duration;
  final double size;
  final double strokeWidth;
  final double startAngle;
  final double rangeAngle;
  final double min;
  final double max;
  final double initialValue;
  final TextStyle textStyle;
  final Widget innerWidget;

  const CircleProgressBar({
    @required this.size,
    this.backgroundColor = Colors.grey,
    this.foregroundColor = Colors.blueAccent,
    this.duration = 3000,
    this.strokeWidth = 10.0,
    this.textStyle,
    this.min = 0,
    this.max = 100,
    this.startAngle = -90,
    this.rangeAngle = 360,
    this.initialValue = 50,
    this.innerWidget,
  });

  double get angle {
    return valueToAngle(initialValue, min, max, 360);
  }

  @override
  _CircleProgressBarState createState() => _CircleProgressBarState();
}

class _CircleProgressBarState extends State<CircleProgressBar>
    with SingleTickerProviderStateMixin {
  Animation<double> _doubleAnimation;
  AnimationController _animationController;
  CurvedAnimation curve;
  ValueChangedAnimationManager _animationManager;

  @override
  void initState() {
    super.initState();
    final duration = valueToDuration(
        widget.initialValue, widget.min, widget.min, widget.max);
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: duration));

    curve = new CurvedAnimation(
        parent: _animationController, curve: Curves.easeOut);
    _doubleAnimation =
        new Tween(begin: widget.startAngle, end: widget.angle).animate(curve);

    _animationController.addListener(() {
      setState(() {});
    });
    onAnimationStart();
  }

  @override
  void reassemble() {
    onAnimationStart();
  }

  onAnimationStart() {
    _animationController.forward(from: widget.startAngle);
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.size,
        height: widget.size,
        child: CustomPaint(
          painter: CircleProgressBarPainter(
              backgroundColor: widget.backgroundColor,
              foregroundColor: widget.foregroundColor,
              progress: 0.8,
              startAngle: widget.startAngle,
              sweepAngle: _doubleAnimation.value,
              endAngle: 360,
              strokeWidth: widget.strokeWidth),
          size: Size(widget.size, widget.size),
          child: Center(
            child: widget.innerWidget ?? Container(),
          ),
        ));
  }
}

class CircleProgressBarPainter extends CustomPainter {
  final double progress;
  var strokeWidth;
  var backgroundColor;
  var foregroundColor;
  var startAngle;
  var sweepAngle;
  var endAngle;

  CircleProgressBarPainter(
      {this.strokeWidth,
        this.progress,
        this.backgroundColor,
        this.foregroundColor,
        this.startAngle,
        this.sweepAngle,
        this.endAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final double center = size.width * 0.5;
    final Offset offsetCenter = Offset(center, center);
    final radius = (size.width / 2) - (this.strokeWidth / 2).ceil();
    Paint _paintBackground = new Paint()
      ..color = backgroundColor
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(offsetCenter, radius, _paintBackground);
    if (progress > 0.0) {
      Paint _paintForeground = new Paint()
        ..color = foregroundColor
        ..isAntiAlias = true
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      final double start = degToRad(startAngle);
      final double sweep = degToRad(sweepAngle);
      final Rect arcRect =
      Rect.fromCircle(center: offsetCenter, radius: radius);
      canvas.drawArc(arcRect, start, sweep, false, _paintForeground);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return sweepAngle != endAngle;
  }
}

typedef void ValueChangeAnimation(double animation, bool animationFinished);

class ValueChangedAnimationManager {
  final TickerProvider tickerProvider;
  final double minValue;
  final double maxValue;

  ValueChangedAnimationManager({
    @required this.tickerProvider,
    @required this.minValue,
    @required this.maxValue,
  });

  Animation<double> _animation;
  bool _animationCompleted = false;
  AnimationController _animController;

  void animate(
      {double initialValue,
        double oldValue,
        double angle,
        double oldAngle,
        ValueChangeAnimation valueChangedAnimation}) {
    _animationCompleted = false;

    final duration =
    valueToDuration(initialValue, oldValue ?? minValue, minValue, maxValue);
    if (_animController == null) {
      _animController = AnimationController(vsync: tickerProvider);
    }

    _animController.duration = Duration(milliseconds: duration);

    final curvedAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _animation =
    Tween<double>(begin: oldAngle ?? 0, end: angle).animate(curvedAnimation)
      ..addListener(() {
        valueChangedAnimation(_animation.value, _animationCompleted);
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationCompleted = true;

          _animController.reset();
        }
      });
    _animController.forward();
  }

  void dispose() {
    _animController.dispose();
  }
}
