import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:transformable_list_view/src/transform_matrix_callback.dart';

class TransformableSliverList extends SliverList {
  final TransformMatrixCallback getTransformMatrix;

  const TransformableSliverList({
    required SliverChildDelegate delegate,
    required this.getTransformMatrix,
    Key? key,
  }) : super(key: key, delegate: delegate);

  @override
  TransformableRenderSliverList createRenderObject(BuildContext context) {
    final element = context as SliverMultiBoxAdaptorElement;

    return TransformableRenderSliverList(
      childManager: element,
      getTransformMatrix: getTransformMatrix,
    );
  }
}

class TransformableRenderSliverList extends RenderSliverList {
  final TransformMatrixCallback getTransformMatrix;

  TransformableRenderSliverList({
    required RenderSliverBoxChildManager childManager,
    required this.getTransformMatrix,
  }) : super(childManager: childManager);

  @override
  void paint(PaintingContext context, Offset offset) {
    //// Copied from [RenderSliverMultiBoxAdaptor] except the OVERRIDE

    if (firstChild == null) return;
    // offset is to the top-left corner, regardless of our axis direction.
    // originOffset gives us the delta from the real origin to the origin in the axis direction.
    final Offset mainAxisUnit, crossAxisUnit, originOffset;
    final bool addExtent;
    switch (applyGrowthDirectionToAxisDirection(
        constraints.axisDirection, constraints.growthDirection)) {
      case AxisDirection.up:
        mainAxisUnit = const Offset(0.0, -1.0);
        crossAxisUnit = const Offset(1.0, 0.0);
        originOffset = offset + Offset(0.0, geometry!.paintExtent);
        addExtent = true;
        break;
      case AxisDirection.right:
        mainAxisUnit = const Offset(1.0, 0.0);
        crossAxisUnit = const Offset(0.0, 1.0);
        originOffset = offset;
        addExtent = false;
        break;
      case AxisDirection.down:
        mainAxisUnit = const Offset(0.0, 1.0);
        crossAxisUnit = const Offset(1.0, 0.0);
        originOffset = offset;
        addExtent = false;
        break;
      case AxisDirection.left:
        mainAxisUnit = const Offset(-1.0, 0.0);
        crossAxisUnit = const Offset(0.0, 1.0);
        originOffset = offset + Offset(geometry!.paintExtent, 0.0);
        addExtent = true;
        break;
    }
    RenderBox? child = firstChild;
    while (child != null) {
      final double mainAxisDelta = childMainAxisPosition(child);
      final double crossAxisDelta = childCrossAxisPosition(child);
      Offset childOffset = Offset(
        originOffset.dx +
            mainAxisUnit.dx * mainAxisDelta +
            crossAxisUnit.dx * crossAxisDelta,
        originOffset.dy +
            mainAxisUnit.dy * mainAxisDelta +
            crossAxisUnit.dy * crossAxisDelta,
      );
      if (addExtent) childOffset += mainAxisUnit * paintExtentOf(child);

      // If the child's visible interval (mainAxisDelta, mainAxisDelta + paintExtentOf(child))
      // does not intersect the paint extent interval (0, constraints.remainingPaintExtent), it's hidden.
      if (mainAxisDelta < constraints.remainingPaintExtent &&
          mainAxisDelta + paintExtentOf(child) > 0) {
        //// --------------- OVERRIDE ---------------
        final paintTransform = getTransformMatrix(
          childOffset,
          child.size,
          paintExtentOf(child),
          child is RenderIndexedSemantics ? child.index : null,
        );

        context.pushTransform(
          needsCompositing,
          childOffset,
          paintTransform,
          (context, offset) => context.paintChild(child!, offset),
        );

        //// --------------- OVERRIDE ---------------
      }

      child = childAfter(child);
    }
  }
}
