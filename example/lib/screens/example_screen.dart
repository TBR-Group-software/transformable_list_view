import 'package:flutter/material.dart';
import 'package:transformable_list_view/transformable_list_view.dart';

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  Matrix4 getScaleDownMatrix(TransformableListItem item) {
    /// final scale of child when the animation is completed
    const endScaleBound = 0.3;

    /// 0 when animation completed and [scale] == [endScaleBound]
    /// 1 when animation starts and [scale] == 1
    final animationProgress = item.visibleExtent / item.size.height;
    
    //if(item.index == 0) print(item.visibleExtent);

    final paintTransform = Matrix4.identity();
    if (animationProgress < 1 && animationProgress > 0) {
      final scale = endScaleBound + ((1 - endScaleBound) * animationProgress);

      paintTransform
        ..translate(item.size.width / 2)
        ..scale(scale)
        ..translate(-item.size.width / 2);
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
            margin: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
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
