import 'package:flutter/rendering.dart';
import 'package:transformable_list_view/src/transform_matrix_callback.dart';
import 'package:transformable_list_view/src/transformable_list_item.dart';

mixin TransformableRenderSliverMultiBoxAdaptor on RenderSliverMultiBoxAdaptor {
  abstract final TransformMatrixCallback getTransformMatrix;

  /// transform of each child
  final cachedTransforms = <RenderBox, Matrix4>{};

  @override
  void paint(PaintingContext context, Offset offset) {
    //// Copied from [RenderSliverMultiBoxAdaptor] except the OVERRIDE

    if (firstChild == null) {
      return;
    }
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
      case AxisDirection.right:
        mainAxisUnit = const Offset(1.0, 0.0);
        crossAxisUnit = const Offset(0.0, 1.0);
        originOffset = offset;
        addExtent = false;
      case AxisDirection.down:
        mainAxisUnit = const Offset(0.0, 1.0);
        crossAxisUnit = const Offset(1.0, 0.0);
        originOffset = offset;
        addExtent = false;
      case AxisDirection.left:
        mainAxisUnit = const Offset(-1.0, 0.0);
        crossAxisUnit = const Offset(0.0, 1.0);
        originOffset = offset + Offset(geometry!.paintExtent, 0.0);
        addExtent = true;
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
      if (addExtent) {
        childOffset += mainAxisUnit * paintExtentOf(child);
      }

      // If the child's visible interval (mainAxisDelta, mainAxisDelta + paintExtentOf(child))
      // does not intersect the paint extent interval (0, constraints.remainingPaintExtent), it's hidden.
      if (mainAxisDelta < constraints.remainingPaintExtent &&
          mainAxisDelta + paintExtentOf(child) > 0) {
        //// ---------------↓↓↓OVERRIDE↓↓↓---------------
        final paintTransform = getTransformMatrix(
          TransformableListItem(
            offset: childOffset,
            size: child.size,
            constraints: constraints,
            index: child is RenderIndexedSemantics ? child.index : null,
          ),
        );
        cachedTransforms[child] = paintTransform;

        context.pushTransform(
          needsCompositing,
          childOffset,
          paintTransform,
          (context, offset) => context.paintChild(child!, offset),

          ///TODO add [oldLayer] for perfomance optimization
        );

        //// ---------------↑↑↑OVERRIDE↑↑↑---------------
      }

      child = childAfter(child);
    }
  }
}
