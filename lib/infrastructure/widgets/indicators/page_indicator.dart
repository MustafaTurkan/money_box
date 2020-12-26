import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';

//Todo(Erkan) renkler temadan alınacak
const Color _dotColor = Color(0xffdcdedf);
const Color _activeDotColor = Color(0xff1a73e9);

typedef OnDotClicked = void Function(int index);

class PageIndicator extends AnimatedWidget {
  PageIndicator({
    Key key,
    @required this.controller,
    @required this.count,
    this.axisDirection = Axis.horizontal,
    this.textDirection,
    this.onDotClicked,
    this.effect = const WormEffect(),
  }) : super(key: key, listenable: controller);

  // Page view controller
  final PageController controller;

  /// Holds effect configuration to be used in the [IndicatorPainter]
  final IndicatorEffect effect;

  /// layout direction vertical || horizontal
  ///
  /// This will only rotate the canvas in which the dots
  /// are drawn,
  /// It will not affect [effect.dotWidth] and [effect.dotHeight]
  final Axis axisDirection;

  /// The number of pages
  final int count;

  /// If [textDirection] is [TextDirection.rtl], page direction will be flipped
  final TextDirection textDirection;

  /// on dot clicked callback
  final OnDotClicked onDotClicked;

  @override
  Widget build(BuildContext context) {
    return SmoothIndicator(
      offset: _offset,
      count: count,
      effect: effect,
      textDirection: textDirection,
      axisDirection: axisDirection,
      onDotClicked: onDotClicked,
    );
  }

  double get _offset {
    try {
      return controller.page ?? controller.initialPage.toDouble();
    } catch (_) {
      return controller.initialPage.toDouble();
    }
  }
}

class SmoothIndicator extends StatelessWidget {
  SmoothIndicator({
    @required this.offset,
    @required this.count,
    this.axisDirection = Axis.horizontal,
    this.textDirection,
    this.onDotClicked,
    this.effect = const WormEffect(),
    Key key,
  })  : assert(offset != null),
        assert(effect != null),
        assert(count != null),
        // different effects have different sizes
        // so we calculate size based on the provided effect
        _size = effect.calculateSize(count),
        super(key: key);

  // to listen for page offset updates
  final double offset;

  /// Holds effect configuration to be used in the [IndicatorPainter]
  final IndicatorEffect effect;

  /// layout direction vertical || horizontal
  final Axis axisDirection;

  /// The number of pages
  final int count;

  /// If [textDirection] is [TextDirection.rtl], page direction will be flipped
  final TextDirection textDirection;

  /// on dot clicked callback
  final OnDotClicked onDotClicked;

  /// canvas size
  final Size _size;

  @override
  Widget build(BuildContext context) {
    // if textDirection is not provided use the nearest directionality up the widgets tree;
    final isRTL = (textDirection ?? Directionality.of(context)) == TextDirection.rtl;

    return RotatedBox(
      quarterTurns: axisDirection == Axis.vertical
          ? 1
          : isRTL
              ? 2
              : 0,
      child: GestureDetector(
        onTapUp: _onTap,
        child: CustomPaint(
          size: _size,
          // rebuild the painter with the new offset every time it updates
          painter: effect.buildPainter(count, offset),
        ),
      ),
    );
  }

  void _onTap(TapUpDetails details) {
    if (onDotClicked != null) {
      var index = effect.hitTestDots(
        details.localPosition.dx,
        count,
        offset,
      );
      if (index != -1 && index != offset.toInt()) {
        onDotClicked(index);
      }
    }
  }
}

class AnimatedSmoothIndicator extends ImplicitlyAnimatedWidget {
  AnimatedSmoothIndicator({
    @required this.activeIndex,
    @required this.count,
    this.axisDirection = Axis.horizontal,
    this.textDirection,
    this.onDotClicked,
    this.effect = const WormEffect(),
    Curve curve = Curves.easeInOut,
    Duration duration = const Duration(milliseconds: 300),
    VoidCallback onEnd,
    Key key,
  })  : assert(effect != null),
        assert(activeIndex != null),
        assert(count != null),
        assert(duration != null),
        assert(curve != null),
        super(
          key: key,
          duration: duration,
          curve: curve,
          onEnd: onEnd,
        );

  final int activeIndex;

  /// Holds effect configuration to be used in the [IndicatorPainter]
  final IndicatorEffect effect;

  /// layout direction vertical || horizontal
  final Axis axisDirection;

  /// The number of children in [PageView]
  final int count;

  /// If [textDirection] is [TextDirection.rtl], page direction will be flipped
  final TextDirection textDirection;

  /// On dot clicked callback
  final Function(int index) onDotClicked;

  @override
  _AnimatedSmoothIndicatorState createState() => _AnimatedSmoothIndicatorState();
}

class _AnimatedSmoothIndicatorState extends AnimatedWidgetBaseState<AnimatedSmoothIndicator> {
  Tween<double> _offset;

  @override
  void forEachTween(visitor) {
    _offset = visitor(
      _offset,
      widget.activeIndex.toDouble(),
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>;
  }

  @override
  Widget build(BuildContext context) {
    return SmoothIndicator(
      offset: _offset?.evaluate(animation),
      count: widget.count,
      effect: widget.effect,
      textDirection: widget.textDirection,
      axisDirection: widget.axisDirection,
      onDotClicked: widget.onDotClicked,
    );
  }
}

class WormEffect extends IndicatorEffect {
  const WormEffect({
    // ignore: avoid_unused_constructor_parameters
    double offset,
    double dotWidth = 16.0,
    double dotHeight = 16.0,
    double spacing = 8.0,
    double radius = 16,
    Color dotColor = _dotColor,
    Color activeDotColor = _activeDotColor,
    double strokeWidth = 1.0,
    PaintingStyle paintStyle = PaintingStyle.fill,
  }) : super(
          dotWidth: dotWidth,
          dotHeight: dotHeight,
          spacing: spacing,
          radius: radius,
          strokeWidth: strokeWidth,
          paintStyle: paintStyle,
          dotColor: dotColor,
          activeDotColor: activeDotColor,
        );

  @override
  IndicatorPainter buildPainter(int count, double offset) {
    return WormPainter(count: count, offset: offset, effect: this);
  }
}

class ScrollingDotsEffect extends IndicatorEffect {
  const ScrollingDotsEffect({
    this.activeStrokeWidth = 1.5,
    this.activeDotScale = 1.3,
    this.maxVisibleDots = 5,
    this.fixedCenter = false,
    // ignore: avoid_unused_constructor_parameters
    double offset,
    double dotWidth = 16.0,
    double dotHeight = 16.0,
    double spacing = 8.0,
    double radius = 16,
    Color dotColor = _dotColor,
    Color activeDotColor = _activeDotColor,
    double strokeWidth = 1.0,
    PaintingStyle paintStyle = PaintingStyle.fill,
  })  : assert(activeStrokeWidth != null),
        assert(fixedCenter != null),
        assert(activeDotScale != null),
        assert(activeDotScale >= 0.0),
        assert(maxVisibleDots >= 5 && maxVisibleDots % 2 != 0),
        super(
          dotWidth: dotWidth,
          dotHeight: dotHeight,
          spacing: spacing,
          radius: radius,
          strokeWidth: strokeWidth,
          paintStyle: paintStyle,
          dotColor: dotColor,
          activeDotColor: activeDotColor,
        );

  /// The active dot strokeWidth
  /// this's ignored if [fixedCenter] is false
  final double activeStrokeWidth;

  /// [activeDotScale] is multiplied by [dotWidth] to resolve
  /// active dot scaling
  final double activeDotScale;

  /// The max number of dots to display at a time
  /// if count is <= [maxVisibleDots] [maxVisibleDots] = count
  /// must be an odd number that's >= 5
  final int maxVisibleDots;

  // if True the old center dot style will be used
  final bool fixedCenter;

  @override
  Size calculateSize(int count) {
    // Add the scaled dot width to our size calculation
    var width = (dotWidth + spacing) * (min(count, maxVisibleDots));
    if (fixedCenter && count <= maxVisibleDots) {
      width = ((count * 2) - 1) * (dotWidth + spacing);
    }
    return Size(width, dotHeight * activeDotScale);
  }

  @override
  int hitTestDots(double dx, int count, double current) {
    final switchPoint = (maxVisibleDots / 2).floor();
    if (fixedCenter) {
      return super.hitTestDots(dx, count, current) - switchPoint + current.floor();
    } else {
      final firstVisibleDot = (current < switchPoint || count - 1 < maxVisibleDots)
          ? 0
          : min(current - switchPoint, count - maxVisibleDots).floor();
      final lastVisibleDot = min(firstVisibleDot + maxVisibleDots, count - 1).floor();
      var offset = 0.0;
      for (var index = firstVisibleDot; index <= lastVisibleDot; index++) {
        if (dx <= (offset += dotWidth + spacing)) {
          return index;
        }
      }
    }
    return -1;
  }

  @override
  IndicatorPainter buildPainter(int count, double offset) {
    if (fixedCenter) {
      return ScrollingDotsWithFixedCenterPainter(count: count, offset: offset, effect: this);
    } else {
      return ScrollingDotsPainter(count: count, offset: offset, effect: this);
    }
  }
}

class WormPainter extends IndicatorPainter {
  WormPainter({
    @required this.effect,
    @required int count,
    @required double offset,
  }) : super(offset, count, effect);

  final WormEffect effect;

  @override
  void paint(Canvas canvas, Size size) {
//    super.paint(canvas, size);
    // paint still dots
    paintStillDots(canvas, size);
    final activeDotPaint = Paint()..color = effect.activeDotColor;
    final dotOffset = offset - offset.toInt();
    final worm = _calcBounds(size.height, offset.floor(), dotOffset * 2);
    canvas.drawRRect(worm, activeDotPaint);
  }

  RRect _calcBounds(double canvasHeight, num i, double dotOffset) {
    final xPos = (i * distance).toDouble();
    final yPos = canvasHeight / 2;
    double left = xPos;
    double right = xPos + effect.dotWidth + (dotOffset * (effect.dotWidth + effect.spacing));
    if (dotOffset > 1) {
      right = xPos + effect.dotWidth + (1 * (effect.dotWidth + effect.spacing));
      left = xPos + ((effect.spacing + effect.dotWidth) * (dotOffset - 1));
    }
    return RRect.fromLTRBR(
      left,
      yPos - effect.dotHeight / 2,
      right,
      yPos + effect.dotHeight / 2,
      dotRadius,
    );
  }
}

class ScrollingDotsPainter extends IndicatorPainter {
  ScrollingDotsPainter({
    @required this.effect,
    @required int count,
    @required double offset,
  }) : super(offset, count, effect);

  final ScrollingDotsEffect effect;

  @override
  void paint(Canvas canvas, Size size) {
    final current = super.offset.floor();
    final switchPoint = (effect.maxVisibleDots / 2).floor();
    final firstVisibleDot = (current < switchPoint || count - 1 < effect.maxVisibleDots)
        ? 0
        : min(current - switchPoint, count - effect.maxVisibleDots);
    final lastVisibleDot = min(firstVisibleDot + effect.maxVisibleDots, count - 1);
    final inPreScrollRange = current < switchPoint;
    final inAfterScrollRange = current >= (count - 1) - switchPoint;
    final willStartScrolling = (current + 1) == switchPoint + 1;
    final willStopScrolling = current + 1 == (count - 1) - switchPoint;

    final dotOffset = offset - offset.toInt();
    final dotPaint = Paint()
      ..strokeWidth = effect.strokeWidth
      ..style = effect.paintStyle;

    final drawingAnchor =
        (inPreScrollRange || inAfterScrollRange) ? -(firstVisibleDot * distance) : -((offset - switchPoint) * distance);

    final smallDotScale = 0.66;
    final activeScale = effect.activeDotScale - 1.0;
    for (var index = firstVisibleDot; index <= lastVisibleDot; index++) {
      var color = effect.dotColor;

      var scale = 1.0;

      if (index == current) {
        color = Color.lerp(effect.activeDotColor, effect.dotColor, dotOffset);
        scale = effect.activeDotScale - (activeScale * dotOffset);
      } else if (index - 1 == current) {
        color = Color.lerp(effect.dotColor, effect.activeDotColor, dotOffset);
        scale = 1.0 + (activeScale * dotOffset);
      } else if (count - 1 < effect.maxVisibleDots) {
        scale = 1.0;
      } else if (index == firstVisibleDot) {
        if (willStartScrolling) {
          scale = (1.0 * (1.0 - dotOffset)).toDouble();
        } else if (inAfterScrollRange) {
          scale = smallDotScale;
        } else if (!inPreScrollRange) {
          scale = smallDotScale * (1.0 - dotOffset);
        }
      } else if (index == firstVisibleDot + 1 && !(inPreScrollRange || inAfterScrollRange)) {
        scale = 1.0 - (dotOffset * (1.0 - smallDotScale));
      } else if (index == lastVisibleDot - 1.0) {
        if (inPreScrollRange) {
          scale = smallDotScale;
        } else if (!inAfterScrollRange) {
          scale = smallDotScale + ((1.0 - smallDotScale) * dotOffset);
        }
      } else if (index == lastVisibleDot) {
        if (inPreScrollRange) {
          scale = 0.0;
        } else if (willStopScrolling) {
          scale = dotOffset;
        } else if (!inAfterScrollRange) {
          scale = smallDotScale * dotOffset;
        }
      }

      final scaledWidth = (effect.dotWidth * scale).toDouble();
      final scaledHeight = effect.dotHeight * scale;
      final yPos = size.height / 2;
      final xPos = effect.dotWidth / 2 + drawingAnchor + (index * distance);

      final rRect = RRect.fromLTRBR(
        xPos - scaledWidth / 2 + effect.spacing / 2,
        yPos - scaledHeight / 2,
        xPos + scaledWidth / 2 + effect.spacing / 2,
        yPos + scaledHeight / 2,
        dotRadius * scale,
      );

      canvas.drawRRect(rRect, dotPaint..color = color);
    }
  }
}

class ScrollingDotsWithFixedCenterPainter extends IndicatorPainter {
  ScrollingDotsWithFixedCenterPainter({
    @required this.effect,
    @required int count,
    @required double offset,
  }) : super(offset, count, effect);
  final ScrollingDotsEffect effect;

  @override
  void paint(Canvas canvas, Size size) {
    var current = offset.floor();
    var dotOffset = offset - current;
    var dotPaint = Paint()
      ..strokeWidth = effect.strokeWidth
      ..style = effect.paintStyle;

    for (var index = 0; index < count; index++) {
      var color = effect.dotColor;
      if (index == current) {
        color = Color.lerp(effect.activeDotColor, effect.dotColor, dotOffset);
      } else if (index - 1 == current) {
        color = Color.lerp(effect.activeDotColor, effect.dotColor, 1 - dotOffset);
      }

      var scale = 1.0;
      final smallDotScale = 0.66;
      final revDotOffset = 1 - dotOffset;
      final switchPoint = (effect.maxVisibleDots - 1) / 2;

      if (count > effect.maxVisibleDots) {
        if (index >= current - switchPoint && index <= current + (switchPoint + 1)) {
          if (index == (current + switchPoint)) {
            scale = smallDotScale + ((1 - smallDotScale) * dotOffset);
          } else if (index == current - (switchPoint - 1)) {
            scale = 1 - (1 - smallDotScale) * dotOffset;
          } else if (index == current - switchPoint) {
            scale = (smallDotScale * revDotOffset).toDouble();
          } else if (index == current + (switchPoint + 1)) {
            scale = (smallDotScale * dotOffset).toDouble();
          }
        } else {
          continue;
        }
      }

      final rRect = _calcBounds(
        size.height,
        size.width / 2 - (offset * (effect.dotWidth + effect.spacing)),
        index,
        scale,
      );

      canvas.drawRRect(rRect, dotPaint..color = color);
    }

    final rRect = _calcBounds(size.height, size.width / 2, 0, effect.activeDotScale);
    canvas.drawRRect(
        rRect,
        Paint()
          ..color = effect.activeDotColor
          ..strokeWidth = effect.activeStrokeWidth
          ..style = PaintingStyle.stroke);
  }

  RRect _calcBounds(double canvasHeight, double startingPoint, num i, [double scale = 1.0]) {
    final scaledWidth = effect.dotWidth * scale;
    final scaledHeight = effect.dotHeight * scale;

    final xPos = startingPoint + (effect.dotWidth + effect.spacing) * i;
    final yPos = canvasHeight / 2;
    return RRect.fromLTRBR(
      xPos - scaledWidth / 2,
      yPos - scaledHeight / 2,
      xPos + scaledWidth / 2,
      yPos + scaledHeight / 2,
      dotRadius * scale,
    );
  }
}

abstract class IndicatorEffect {
  const IndicatorEffect({
    @required this.strokeWidth,
    @required this.dotWidth,
    @required this.dotHeight,
    @required this.spacing,
    @required this.radius,
    @required this.dotColor,
    @required this.paintStyle,
    @required this.activeDotColor,
  })  : assert(radius != null),
        assert(dotColor != null || paintStyle != null || strokeWidth != null),
        assert(activeDotColor != null),
        assert(dotWidth != null),
        assert(dotHeight != null),
        assert(spacing != null),
        assert(dotWidth >= 0 && dotHeight >= 0 && spacing >= 0 && strokeWidth >= 0);

  /// Singe dot width
  final double dotWidth;

  /// Singe dot height
  final double dotHeight;

  /// The horizontal space between dots
  final double spacing;

  /// Single dot radius
  final double radius;

  /// Inactive dots color or all dots in some effects
  final Color dotColor;

  /// The active dot color
  final Color activeDotColor;

  /// Inactive dots paint style (fill|stroke) defaults to fill.
  final PaintingStyle paintStyle;

  /// This is ignored if [paintStyle] is PaintStyle.fill
  final double strokeWidth;

  /// Builds a new painter every time the page offset changes
  IndicatorPainter buildPainter(int count, double offset);

  /// Calculates the size of canvas based on
  /// dots count, size and spacing
  ///
  /// Other effects can override this function
  /// to calculate their own size
  Size calculateSize(int count) {
    return Size(dotWidth * count + (spacing * (count - 1)), dotHeight);
  }

  /// Returns the index of the section that contains [dx].
  ///
  /// Sections or hit-targets are calculated differently
  /// in some effects
  int hitTestDots(double dx, int count, double current) {
    var offset = -spacing / 2;
    for (var index = 0; index < count; index++) {
      if (dx <= (offset += dotWidth + spacing)) {
        return index;
      }
    }
    return -1;
  }
}

abstract class IndicatorPainter extends CustomPainter {
  IndicatorPainter(
    this.offset,
    this.count,
    this._effect,
  )   : assert(offset.ceil() < count, 'Current page is out of bounds'),
        dotRadius = Radius.circular(_effect.radius),
        dotPaint = Paint()
          ..color = _effect.dotColor
          ..style = _effect.paintStyle
          ..strokeWidth = _effect.strokeWidth;

  /// The raw offset from the [PageController].page
  /// This holds the directional offset
  final double offset;

  /// The count of pages
  final int count;

  // The provided effect is passed to this super class
  // to make some calculations and paint still dots
  final IndicatorEffect _effect;

  /// Inactive dot paint or base paint in one-color effects.
  final Paint dotPaint;

  /// The Radius of all dots
  final Radius dotRadius;

  // The distance between dot lefts
  double get distance => _effect.dotWidth + _effect.spacing;

  void paintStillDots(Canvas canvas, Size size) {
    for (var i = 0; i < count; i++) {
      final xPos = (i * distance).toDouble();
      final yPos = size.height / 2;
      final bounds =
          Rect.fromLTRB(xPos, yPos - _effect.dotHeight / 2, xPos + _effect.dotWidth, yPos + _effect.dotHeight / 2);
      var rect = RRect.fromRectAndRadius(bounds, dotRadius);
      canvas.drawRRect(rect, dotPaint);
    }
  }

  @override
  bool shouldRepaint(IndicatorPainter oldDelegate) {
    // only repaint if the raw offset changes
    return oldDelegate.offset != offset;
  }
}
