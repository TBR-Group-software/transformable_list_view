import 'package:flutter/rendering.dart';

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

  /// Contains data about [TransformableListView] or [TransformableSliverList] or [TransformableSliver] scroll item
  const TransformableListItem({
    required this.offset,
    required this.size,
    required this.constraints,
    this.index,
  });

  /// Child position on the main axis viewport
  TransformableListItemPosition get position {
    final double mainAxisOffset;

    switch (constraints.axis) {
      case Axis.horizontal:
        mainAxisOffset = offset.dx;
        break;
      case Axis.vertical:
        mainAxisOffset = offset.dy;
        break;
    }

    if (mainAxisOffset < 0) {
      return TransformableListItemPosition.topEdge;
    } else if (mainAxisOffset > constraints.viewportMainAxisExtent - _totalExtent) {
      return TransformableListItemPosition.bottomEdge;
    } else {
      return TransformableListItemPosition.middle;
    }
  }

  /// Currently visible portion of child
  double get visibleExtent {
    switch (position) {
      case TransformableListItemPosition.topEdge:
        return _totalExtent + offset.dy;
      case TransformableListItemPosition.middle:
        return _totalExtent;
      case TransformableListItemPosition.bottomEdge:
        return constraints.viewportMainAxisExtent - offset.dy;
    }
  }

  double get _totalExtent {
    switch (constraints.axis) {
      case Axis.horizontal:
        return size.width;
      case Axis.vertical:
        return size.height;
    }
  }
}

enum TransformableListItemPosition {
  topEdge,
  middle,
  bottomEdge,
}
