import 'dart:math';

import 'package:flutter/material.dart';
import 'package:transformable_list_view/transformable_list_view.dart';

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  Matrix4 getScaleDownTransformMatrix(Offset offset, Size size, double paintExtent) {
    const animationBound = 200.0;

    /// distance between bottom edge of child and the top edge of viewport
    final closingOffset = offset.dy + paintExtent;

    /// 0 when animation completed and [scale] == [endScaleBound]
    /// 1 when animation starts and [scale] == 1
    final animationProgress = closingOffset / animationBound;

    Matrix4? paintTransform;
    if (animationProgress < 1 && animationProgress > 0) {
      /// final scale of child when the animatioon is completed
      const endScaleBound = 0.7;

      /// if > 1 -> the animation is faster on the beginnig than at the end
      /// if < 1 -> the animation is faster on the end than at the beginniglp
      /// if = 1 -> no deceleration
      const decelerationFactor = 2.4;

      final scale = endScaleBound +
          ((1 - endScaleBound) * pow(animationProgress, decelerationFactor));

      paintTransform = Matrix4.identity()
        ..translate(size.width / 2, paintExtent)
        ..scale(scale)
        ..translate(-size.width / 2, -paintExtent);
    }

    return paintTransform ?? Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          TransformableSliverList(
            getTransformMatrix: getScaleDownTransformMatrix,
            delegate: SliverChildBuilderDelegate(
              (context, index) {
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
              childCount: 30,
            ),
          ),
        ],
      ),
    );
  }
}
