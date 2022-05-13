import 'package:flutter/material.dart';
import 'package:transformable_list_view/transformable_list_view.dart';

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  Matrix4 getScaleDownMatrix(
    Offset offset,
    Size size,
    double viewportMainAxisExtent,
    int? index,
  ) {
    /// currently visible portion of childs
    late final double visibleSize;

    if (offset.dy < 0) {
      /// on the top edge of viewport
      visibleSize = size.height + offset.dy;
    } else if (offset.dy > viewportMainAxisExtent - size.height) {
      /// on the bottom edge of viewport
      visibleSize = viewportMainAxisExtent - offset.dy;
    } else {
      /// fully displayed
      visibleSize = size.height;
    }

    /// final scale of child when the animatioon is completed
    const endScaleBound = 0.3;

    /// 0 when animation completed and [scale] == [endScaleBound]
    /// 1 when animation starts and [scale] == 1
    final animationProgress = visibleSize / size.height;

    final paintTransform = Matrix4.identity();
    if (animationProgress < 1 && animationProgress > 0) {
      final scale = endScaleBound + ((1 - endScaleBound) * animationProgress);

      paintTransform
        ..translate(size.width / 2)
        ..scale(scale)
        ..translate(-size.width / 2);
    }

    return paintTransform;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TransformableListView.builder(
        getTransformMatrix: getScaleDownMatrix,
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
