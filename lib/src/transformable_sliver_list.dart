import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:transformable_list_view/src/transform_matrix_callback.dart';
import 'package:transformable_list_view/src/transformable_list_item.dart';
import 'package:transformable_list_view/src/mixins/transformable_render_sliver_helpers.dart';
import 'package:transformable_list_view/src/mixins/transformable_render_sliver_multi_box_adaptor.dart';

/// {@template transformable_sliver_list}
/// Extends [SliverList] with [getTransformMatrix] callback that allows to add transform animations.
/// {@endtemplate}
class TransformableSliverList extends SliverList {
  /// Receives [TransformableListItem] that contains data about item(offset, size, index, viewport constraints)
  /// and returns [Matrix4] that represents item transformations on the current offset. If it returns [Matrix4.identity()] no transformation will be applied
  final TransformMatrixCallback getTransformMatrix;

  /// {@macro transformable_sliver_list}
  const TransformableSliverList({
    required this.getTransformMatrix,
    required super.delegate,
    super.key,
  });

  @override
  TransformableRenderSliverList createRenderObject(BuildContext context) {
    final element = context as SliverMultiBoxAdaptorElement;

    return TransformableRenderSliverList(
      childManager: element,
      getTransformMatrix: getTransformMatrix,
    );
  }
}

/// {@template transformable_render_sliver_list}
/// Extends [RenderSliverList] with [getTransformMatrix] callback that allows to add transform animations.
/// {@endtemplate}
class TransformableRenderSliverList extends RenderSliverList
    with
        TransformableRenderSliverMultiBoxAdaptor,
        TransformableRenderSliverHelpers {
  @override
  final TransformMatrixCallback getTransformMatrix;

  /// {@macro transformable_render_sliver_list}
  TransformableRenderSliverList({
    required this.getTransformMatrix,
    required super.childManager,
  });

  @override
  Matrix4 getCurrentTransform(RenderBox child) =>
      cachedTransforms[child] ?? Matrix4.identity();
}
