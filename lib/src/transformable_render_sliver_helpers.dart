import 'package:flutter/rendering.dart';

mixin TransformableRenderSliverHelpers on RenderSliverHelpers {
  bool hitTestBoxChildWithTransform(
    BoxHitTestResult result,
    RenderBox child, {
    required double mainAxisPosition,
    required double crossAxisPosition,
    required Matrix4 transform,
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
        break;
      case Axis.vertical:
        if (!rightWayUp) {
          absolutePosition = child.size.height - absolutePosition;
          delta = geometry!.paintExtent - child.size.height - delta;
        }
        paintOffset = Offset(crossAxisDelta, delta);
        transformedPosition =
            Offset(absoluteCrossAxisPosition, absolutePosition);
        break;
    }
    //// ---------------↓↓↓OVERRIDE↓↓↓---------------
    return result.addWithPaintTransform(
      transform: transform,
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
        break;
      case AxisDirection.down:
      case AxisDirection.right:
        rightWayUp = true;
        break;
    }
    switch (constraints.growthDirection) {
      case GrowthDirection.forward:
        break;
      case GrowthDirection.reverse:
        rightWayUp = !rightWayUp;
        break;
    }
    return rightWayUp;
  }
}
