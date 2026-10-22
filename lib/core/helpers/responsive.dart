import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Width breakpoints and content caps used across DocDoc.
///
/// The values follow the Material 3 window size classes:
/// * compact  (< 600)   phones in portrait
/// * medium   (600-839) small tablets, foldables, phone landscape
/// * expanded (>= 840)  large tablets and desktop windows
abstract final class AppBreakpoints {
  static const double medium = 600;
  static const double expanded = 840;

  /// Content cap for single-column forms (login, sign up).
  static const double form = 480;

  /// Content cap for lists and detail screens.
  static const double content = 720;

  /// Content cap for screens that can show more than one column.
  static const double wideContent = 960;
}

extension ResponsiveContext on BuildContext {
  double get windowWidth => MediaQuery.sizeOf(this).width;

  bool get isCompactWidth => windowWidth < AppBreakpoints.medium;

  bool get isMediumWidth =>
      windowWidth >= AppBreakpoints.medium &&
      windowWidth < AppBreakpoints.expanded;

  bool get isExpandedWidth => windowWidth >= AppBreakpoints.expanded;

  /// Returns how many columns fit in [availableWidth] when every item needs
  /// at least [minItemWidth] and we never exceed [maxColumns].
  int responsiveColumns({
    required double availableWidth,
    double minItemWidth = 360,
    int maxColumns = 2,
  }) {
    final columns = (availableWidth / minItemWidth).floor();
    return columns.clamp(1, maxColumns);
  }
}

/// Scales text with the screen width but keeps the factor in a readable
/// range, so tablets and desktop windows do not render oversized type.
///
/// Passed to `ScreenUtilPlusInit` as its `fontSizeResolver`.
double responsiveFontSize(num fontSize, ScreenUtilPlus instance) {
  final scale = instance.scaleWidth.clamp(0.9, 1.3);
  return fontSize * scale;
}

/// Centres [child] and caps its width so pages do not stretch edge to edge
/// on tablets and desktop windows.
///
/// Use inside a [Scaffold] body: the bounded height keeps scrollables and
/// viewports working as usual.
class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = AppBreakpoints.content,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

/// Caps the width of a single element and keeps its intrinsic height.
///
/// Use inside bottom bars and other places where [ResponsiveCenter] would try
/// to expand to the full available height.
class ResponsiveWidth extends StatelessWidget {
  const ResponsiveWidth({
    super.key,
    required this.child,
    this.maxWidth = AppBreakpoints.form,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
