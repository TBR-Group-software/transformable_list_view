import 'package:flutter/material.dart';

import 'package:transformable_list_view/transformable_list_view.dart';

/// Extends [ListView] with [getTransformMatrix] callback that allows to add transform animations.
class TransformableListView extends ListView {
  /// Receives [TransformableListItem] that contains data about item(offset, size, index, viewport constraints)
  /// and returns [Matrix4] that represents item transformations on the current offset. If it returns [Matrix4.identity()] no transformation will be applied
  final TransformMatrixCallback getTransformMatrix;

  TransformableListView({
    required this.getTransformMatrix,
    super.key,
    super.scrollDirection,
    super.reverse,
    super.controller,
    super.primary,
    super.physics,
    super.shrinkWrap,
    super.padding,
    super.itemExtent,
    super.addAutomaticKeepAlives,
    super.addRepaintBoundaries,
    super.addSemanticIndexes,
    super.cacheExtent,
    super.children,
    super.semanticChildCount,
    super.dragStartBehavior,
    super.keyboardDismissBehavior,
    super.restorationId,
    super.clipBehavior,
  });

  TransformableListView.builder({
    required super.itemBuilder,
    required this.getTransformMatrix,
    super.key,
    super.scrollDirection,
    super.reverse,
    super.controller,
    super.primary,
    super.physics,
    super.shrinkWrap,
    super.padding,
    super.itemExtent,
    super.findChildIndexCallback,
    super.itemCount,
    super.addAutomaticKeepAlives,
    super.addRepaintBoundaries,
    super.addSemanticIndexes,
    super.cacheExtent,
    super.semanticChildCount,
    super.dragStartBehavior,
    super.keyboardDismissBehavior,
    super.restorationId,
    super.clipBehavior,
  }) : super.builder();

  TransformableListView.separated({
    required this.getTransformMatrix,
    required super.itemBuilder,
    required super.separatorBuilder,
    required super.itemCount,
    super.key,
    super.scrollDirection = Axis.vertical,
    super.reverse,
    super.controller,
    super.primary,
    super.physics,
    super.shrinkWrap,
    super.padding,
    super.findChildIndexCallback,
    super.addAutomaticKeepAlives,
    super.addRepaintBoundaries,
    super.addSemanticIndexes,
    super.cacheExtent,
    super.dragStartBehavior,
    super.keyboardDismissBehavior,
    super.restorationId,
    super.clipBehavior,
  }) : super.separated();

  const TransformableListView.custom({
    required this.getTransformMatrix,
    required super.childrenDelegate,
    super.key,
    super.scrollDirection,
    super.reverse,
    super.controller,
    super.primary,
    super.physics,
    super.shrinkWrap,
    super.padding,
    super.itemExtent,
    super.cacheExtent,
    super.semanticChildCount,
    super.dragStartBehavior,
    super.keyboardDismissBehavior,
    super.restorationId,
    super.clipBehavior,
  }) : super.custom();

  @override
  Widget buildChildLayout(BuildContext context) {
    /// TODO [SliverPrototypeExtentList] && [prototypeItem]
    /// TODO Matrix + Alignment

    final itemExtent = this.itemExtent;

    if (itemExtent != null) {
      return TransformableSliverFixedExtentList(
        itemExtent: itemExtent,
        delegate: childrenDelegate,
        getTransformMatrix: getTransformMatrix,
      );
    }

    return TransformableSliverList(
      delegate: childrenDelegate,
      getTransformMatrix: getTransformMatrix,
    );
  }
}
