import 'package:flutter/rendering.dart';

mixin TransformableRenderSliverHelpers on RenderSliverHelpers {
  Matrix4 getCurrentTransform(RenderBox child);

  @override
  bool hitTestBoxChild(
    BoxHitTestResult result,
    RenderBox child, {
    required double mainAxisPosition,
    required double crossAxisPosition,
  }) {
    //// Copied from [RenderSliverHelpers.hitTestBoxChild] except the OVERRIDE
    final bool rightWayUp = _getRightWayUp(constraints);
    double delta = childMainAxisPosition(child);
    final double crossAxisDelta = childCrossAxisPosition(child);
    double absolutePosition = mainAxisPosition - delta;
    final double absoluteCrossAxisPosition = crossAxisPosition - crossAxisDelta;
    // ignore: unused_local_variable
    Offset paintOffset, transformedPosition;
    switch (constraints.axis) {
      case Axis.horizontal:
        if (!rightWayUp) {
          absolutePosition = child.size.width - absolutePosition;
          delta = geometry!.paintExtent - child.size.width - delta;
        }
        paintOffset = Offset(delta, crossAxisDelta);
        transformedPosition =
            Offset(absolutePosition, absoluteCrossAxisPosition);
      case Axis.vertical:
        if (!rightWayUp) {
          absolutePosition = child.size.height - absolutePosition;
          delta = geometry!.paintExtent - child.size.height - delta;
        }
        paintOffset = Offset(crossAxisDelta, delta);
        transformedPosition =
            Offset(absoluteCrossAxisPosition, absolutePosition);
    }
    //// ---------------↓↓↓OVERRIDE↓↓↓---------------
    return result.addWithPaintTransform(
      transform: getCurrentTransform(child),
      position: transformedPosition,
      hitTest: (result, offset) => child.hitTest(result, position: offset),
    );
    //// ---------------↑↑↑OVERRIDE↑↑↑---------------
  }

  //// Copied from [RenderSliverHelpers]
  bool _getRightWayUp(SliverConstraints constraints) {
    bool rightWayUp;
    switch (constraints.axisDirection) {
      case AxisDirection.up:
      case AxisDirection.left:
        rightWayUp = false;
      case AxisDirection.down:
      case AxisDirection.right:
        rightWayUp = true;
    }
    switch (constraints.growthDirection) {
      case GrowthDirection.forward:
        break;
      case GrowthDirection.reverse:
        rightWayUp = !rightWayUp;
    }
    return rightWayUp;
  }
}
