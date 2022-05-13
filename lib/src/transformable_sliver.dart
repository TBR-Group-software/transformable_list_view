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

    final paintTransform = getTransformMatrix(
      offset,
      size,
      constraints.viewportMainAxisExtent,
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
