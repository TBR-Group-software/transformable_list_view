import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:transformable_list_view/src/transform_matrix_callback.dart';

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

class TransformableRenderSliver extends RenderSliverToBoxAdapter {
  final TransformMatrixCallback getTransformMatrix;
  final transformLayer = LayerHandle<TransformLayer>();

  TransformableRenderSliver({required this.getTransformMatrix});

  @override
  void paint(PaintingContext context, Offset offset) {
    final size = child?.size;

    if (size == null) {
      return;
    }

    final double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = size.width;
        break;
      case Axis.vertical:
        childExtent = size.height;
        break;
    }

    final paintExtent = calculatePaintOffset(
      constraints,
      from: 0,
      to: childExtent,
    );

    final paintTransform = getTransformMatrix(
      offset,
      size,
      paintExtent,
      null,
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
}
