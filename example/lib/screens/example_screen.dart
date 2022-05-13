import 'package:flutter/material.dart';
import 'package:transformable_list_view/transformable_list_view.dart';

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  Matrix4 getScaleDownTransformMatrix(
    Offset offset,
    Size size,
    double paintExtent,
    int? index,
  ) {
    const animationBound = 500.0;

    /// distance between bottom edge of child and the top edge of viewport
    final closingOffset = offset.dy + paintExtent;

    /// 0 when animation completed and [scale] == [endScaleBound]
    /// 1 when animation starts and [scale] == 1
    final animationProgress = closingOffset / animationBound;

    final paintTransform = Matrix4.identity();
    if (animationProgress < 1 && animationProgress > 0) {
      /// final scale of child when the animatioon is completed
      const endScaleBound = 0.5;

      final scale = endScaleBound + ((1 - endScaleBound) * animationProgress);

      paintTransform
        ..translate(size.width / 2, paintExtent)
        ..scale(scale)
        ..translate(-size.width / 2, -paintExtent);
    }

    return paintTransform;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TransformableListView.builder(
        getTransformMatrix: getScaleDownTransformMatrix,
        itemBuilder: (context, index) {
          return Container(
            height: 100,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: index.isEven
                  ? Colors.black.withOpacity(0.3)
                  : Colors.blueAccent,
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(index.toString()),
          );
        },
        itemCount: 30,
      ),
    );
  }
}
