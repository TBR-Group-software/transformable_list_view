import 'package:flutter/rendering.dart';

/// {@template transformable_list_item}
/// Contains data about [TransformableListView] or [TransformableSliverList] or [TransformableSliver] scroll item
/// {@endtemplate}
class TransformableListItem {
  /// Main axis offset of the child.
  /// By default (with vertical, non reversed scroll view) [offset.dx] is always 0 while [offset.dy] is the distance
  /// between top edge of the child and top edge of the viewport.
  final Offset offset;

  /// Size of the child received from [RenderBox]
  final Size size;

  /// Describes the current scroll state of the viewport from the point of view of the sliver receiving the constraints.
  final SliverConstraints constraints;

  /// Index of the child. Will be null when using [TransformableSliver]
  final int? index;

  /// {@macro transformable_list_item}
  const TransformableListItem({
    required this.offset,
    required this.size,
    required this.constraints,
    this.index,
  });

  /// Child position on the main axis viewport
  TransformableListItemPosition get position {
    final mainAxisOffset = switch (constraints.axis) {
      Axis.horizontal => offset.dx,
      Axis.vertical => offset.dy,
    };

    if (mainAxisOffset < 0) {
      return TransformableListItemPosition.topEdge;
    } else if (mainAxisOffset >
        constraints.viewportMainAxisExtent - _totalExtent) {
      return TransformableListItemPosition.bottomEdge;
    } else {
      return TransformableListItemPosition.middle;
    }
  }

  /// Currently visible portion of child
  double get visibleExtent => switch (position) {
        TransformableListItemPosition.topEdge => _totalExtent + offset.dy,
        TransformableListItemPosition.middle => _totalExtent,
        TransformableListItemPosition.bottomEdge =>
          constraints.viewportMainAxisExtent - offset.dy,
      };

  double get _totalExtent => switch (constraints.axis) {
        Axis.horizontal => size.width,
        Axis.vertical => size.height,
      };
}

enum TransformableListItemPosition {
  topEdge,
  middle,
  bottomEdge,
}
