import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:transformable_list_view/src/transform_matrix_callback.dart';
import 'package:transformable_list_view/src/transformable_list_item.dart';
import 'package:transformable_list_view/src/transformable_render_sliver_helpers.dart';

class TransformableSliver extends SingleChildRenderObjectWidget {
  final TransformMatrixCallback getTransformMatrix;

  const TransformableSliver({
    Key? key,
    required Widget child,
    required this.getTransformMatrix,
  }) : super(key: key, child: child);

  @override
  TransformableRenderSliver createRenderObject(BuildContext context) {
    return TransformableRenderSliver(getTransformMatrix: getTransformMatrix);
  }
}

class TransformableRenderSliver extends RenderSliverToBoxAdapter
    with TransformableRenderSliverHelpers {
  final TransformMatrixCallback getTransformMatrix;
  final transformLayer = LayerHandle<TransformLayer>();

  Matrix4 paintTransform = Matrix4.identity();

  TransformableRenderSliver({required this.getTransformMatrix});

  @override
  void paint(PaintingContext context, Offset offset) {
    final size = child?.size;

    if (size == null) {
      return;
    }

    final Offset itemOffset;
    switch (constraints.axis) {
      case Axis.horizontal:
        itemOffset = offset.translate(offset.dx == 0 ? -constraints.scrollOffset : 0, 0);
        break;
      case Axis.vertical:
        itemOffset = offset.translate(0, offset.dy == 0 ? -constraints.scrollOffset : 0);
        break;
    }

    paintTransform = getTransformMatrix(
      TransformableListItem(
        offset: itemOffset,
        size: size,
        constraints: constraints,
      ),
    );

    transformLayer.layer = child != null && (geometry?.visible ?? false)
        ? context.pushTransform(
            needsCompositing,
            offset,
            paintTransform,
            super.paint,
            oldLayer: transformLayer.layer,
          )
        : null;
  }

  @override
  bool hitTestBoxChild(BoxHitTestResult result, RenderBox child,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    return hitTestBoxChildWithTransform(
      result,
      child,
      mainAxisPosition: mainAxisPosition,
      crossAxisPosition: crossAxisPosition,
      transform: paintTransform,
    );
  }
}
