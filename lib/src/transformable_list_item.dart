import 'package:flutter/rendering.dart';

/// TODO document it more
class TransformableListItem {
  final Offset offset;
  final Size size;
  final SliverConstraints constraints;
  final int? index;

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

  /// Currently visible portion of childs
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
