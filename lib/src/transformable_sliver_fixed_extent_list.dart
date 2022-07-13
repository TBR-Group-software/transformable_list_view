import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:transformable_list_view/src/mixins/transformable_render_sliver_helpers.dart';
import 'package:transformable_list_view/src/mixins/transformable_render_sliver_multi_box_adaptor.dart';
import 'package:transformable_list_view/src/transform_matrix_callback.dart';

/// {@template transformable_sliver_fixed_extent_list}
/// Extends [SliverFixedExtentList] with [getTransformMatrix] callback that allows to add transform animations.
/// {@endtemplate}
class TransformableSliverFixedExtentList extends SliverFixedExtentList {
  /// Receives [TransformableListItem] that contains data about item(offset, size, index, viewport constraints)
  /// and returns [Matrix4] that represents item transformations on the current offset. If it returns [Matrix4.identity()] no transformation will be applied
  final TransformMatrixCallback getTransformMatrix;
  
  /// {@macro transformable_sliver_fixed_extent_list}
  const TransformableSliverFixedExtentList({
    required this.getTransformMatrix,
    required super.itemExtent,
    required super.delegate,
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

/// {@template transformable_render_sliver_fixed_extent_list}
/// Extends [RenderSliverFixedExtentList] with [getTransformMatrix] callback that allows to add transform animations.
/// {@endtemplate}
class TransformableRenderSliverFixedExtentList
    extends RenderSliverFixedExtentList
    with
        TransformableRenderSliverMultiBoxAdaptor,
        TransformableRenderSliverHelpers {
  @override
  final TransformMatrixCallback getTransformMatrix;
  
  /// {@macro transformable_render_sliver_fixed_extent_list}
  TransformableRenderSliverFixedExtentList({
    required this.getTransformMatrix,
    required super.childManager,
    required super.itemExtent,
  });

  @override
  Matrix4 getCurrentTransform(RenderBox child) =>
      cachedTransforms[child] ?? Matrix4.identity();
}
