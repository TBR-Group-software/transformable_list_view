import 'package:flutter/rendering.dart';

typedef TransformMatrixCallback = Matrix4 Function(
  Offset offset,
  Size childSize,
  double viewportMainAxisExtent,
  int? index,
);
