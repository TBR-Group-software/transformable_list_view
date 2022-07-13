import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:transformable_list_view/src/mixins/transformable_render_sliver_helpers.dart';
import 'package:transformable_list_view/src/mixins/transformable_render_sliver_multi_box_adaptor.dart';
import 'package:transformable_list_view/src/transform_matrix_callback.dart';

/// Extends [SliverFixedExtentList] with [getTransformMatrix] callback that allows to add transform animations.
class TransformableSliverFixedExtentList extends SliverFixedExtentList {
  /// Receives [TransformableListItem] that contains data about item(offset, size, index, viewport constraints)
  /// and returns [Matrix4] that represents item transformations on the current offset. If it returns [Matrix4.identity()] no transformation will be applied
  final TransformMatrixCallback getTransformMatrix;

  const TransformableSliverFixedExtentList({
    required super.itemExtent,
    required super.delegate,
    required this.getTransformMatrix,
    super.key,
  });

  @override
  TransformableRenderSliverFixedExtentList createRenderObject(
      BuildContext context) {
    final element = context as SliverMultiBoxAdaptorElement;

    return TransformableRenderSliverFixedExtentList(
      childManager: element,
      itemExtent: itemExtent,
      getTransformMatrix: getTransformMatrix,
    );
  }
}

class TransformableRenderSliverFixedExtentList
    extends RenderSliverFixedExtentList
    with
        TransformableRenderSliverMultiBoxAdaptor,
        TransformableRenderSliverHelpers {
  @override
  final TransformMatrixCallback getTransformMatrix;

  TransformableRenderSliverFixedExtentList({
    required super.childManager,
    required super.itemExtent,
    required this.getTransformMatrix,
  });

  @override
  Matrix4 getCurrentTransform(RenderBox child) =>
      cachedTransforms[child] ?? Matrix4.identity();
}
