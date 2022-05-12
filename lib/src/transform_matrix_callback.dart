import 'package:flutter/rendering.dart';

typedef TransformMatrixCallback = Matrix4 Function(
    Offset offset, Size size, double paintExtent, int? index);