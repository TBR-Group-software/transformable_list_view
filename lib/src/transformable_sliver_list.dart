import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:transformable_list_view/src/transform_matrix_callback.dart';
import 'package:transformable_list_view/src/transformable_list_item.dart';
import 'package:transformable_list_view/src/mixins/transformable_render_sliver_helpers.dart';
import 'package:transformable_list_view/src/mixins/transformable_render_sliver_multi_box_adaptor.dart';

/// Extends [SliverList] with [getTransformMatrix] callback that allows to add transform animations.
class TransformableSliverList extends SliverList {
  /// Receives [TransformableListItem] that contains data about item(offset, size, index, viewport constraints)
  /// and returns [Matrix4] that represents item transformations on the current offset. If it returns [Matrix4.identity()] no transformation will be applied
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

class TransformableRenderSliverList extends RenderSliverList
    with
        TransformableRenderSliverMultiBoxAdaptor,
        TransformableRenderSliverHelpers {
  @override
  final TransformMatrixCallback getTransformMatrix;

  TransformableRenderSliverList({
    required RenderSliverBoxChildManager childManager,
    required this.getTransformMatrix,
  }) : super(childManager: childManager);

  @override
  Matrix4 getCurrentTransform(RenderBox child) =>
      cachedTransforms[child] ?? Matrix4.identity();
}
