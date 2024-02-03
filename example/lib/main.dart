import 'dart:math';

import 'package:flutter/material.dart';
import 'package:transformable_list_view/transformable_list_view.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Transformable List View Example',
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ListViewExample(
                            transformMatrix: TransformMatrices.scaleDown,
                          ),
                        ),
                      );
                    },
                    child: const Text('Scale Down Example'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ListViewExample(
                            transformMatrix: TransformMatrices.rotate,
                          ),
                        ),
                      );
                    },
                    child: const Text('Rotate Example'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ListViewExample(
                            transformMatrix: TransformMatrices.wheel,
                          ),
                        ),
                      );
                    },
                    child: const Text('Wheel Example'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SliverExampleScreen(),
                        ),
                      );
                    },
                    child: const Text('Sliver Example'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ListViewExample extends StatelessWidget {
  const ListViewExample({
    super.key,
    required this.transformMatrix,
  });

  final TransformMatrixCallback transformMatrix;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListView Example'),
      ),
      body: TransformableListView.builder(
        padding: EdgeInsets.zero,
        getTransformMatrix: transformMatrix,
        itemCount: 30,
        itemBuilder: (context, index) {
          return Container(
            height: 100,
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: index.isEven ? Colors.grey : Colors.blueAccent,
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(index.toString()),
          );
        },
      ),
    );
  }
}

class SliverExampleScreen extends StatelessWidget {
  const SliverExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('Sliver Example'),
            floating: true,
            snap: true,
          ),
          TransformableSliverList.builder(
            itemCount: 10,
            getTransformMatrix: TransformMatrices.scaleDown,
            itemBuilder: (context, index) {
              return Container(
                height: 100,
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: index.isEven ? Colors.grey : Colors.blueAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(index.toString()),
              );
            },
          ),
          TransformableSliverList.builder(
            itemCount: 10,
            getTransformMatrix: TransformMatrices.rotate,
            itemBuilder: (context, index) {
              return Container(
                height: 100,
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: index.isEven ? Colors.grey : Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(index.toString()),
              );
            },
          ),
          TransformableSliverList.builder(
            itemCount: 10,
            getTransformMatrix: TransformMatrices.wheel,
            itemBuilder: (context, index) {
              return Container(
                height: 100,
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: index.isEven ? Colors.grey : Colors.amber,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(index.toString()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class TransformMatrices {
  static Matrix4 scaleDown(TransformableListItem item) {
    /// final scale of child when the animation is completed
    const endScaleBound = 0.3;

    /// 0 when animation completed and [scale] == [endScaleBound]
    /// 1 when animation starts and [scale] == 1
    final animationProgress = item.visibleExtent / item.size.height;

    /// result matrix
    final paintTransform = Matrix4.identity();

    /// animate only if item is on edge
    if (item.position != TransformableListItemPosition.middle) {
      final scale = endScaleBound + ((1 - endScaleBound) * animationProgress);

      paintTransform
        ..translate(item.size.width / 2)
        ..scale(scale)
        ..translate(-item.size.width / 2);
    }

    return paintTransform;
  }

  static Matrix4 rotate(TransformableListItem item) {
    /// rotate item to 90 degrees
    const maxRotationTurnsInRadians = pi / 2.0;

    /// 0 when animation starts and [rotateAngle] == 0 degrees
    /// 1 when animation completed and [rotateAngle] == 90 degrees
    final animationProgress = 1 - item.visibleExtent / item.size.height;

    /// result matrix
    final paintTransform = Matrix4.identity();

    /// animate only if item is on edge
    if (item.position != TransformableListItemPosition.middle) {
      /// rotate to the left if even
      /// rotate to the right if odd
      final isEven = item.index?.isEven ?? false;

      /// To select corner of the rotation
      final FractionalOffset fractionalOffset;
      final int rotateDirection;

      switch (item.position) {
        case TransformableListItemPosition.topEdge:
          fractionalOffset = isEven
              ? FractionalOffset.bottomLeft
              : FractionalOffset.bottomRight;
          rotateDirection = isEven ? -1 : 1;
          break;
        case TransformableListItemPosition.middle:
          return paintTransform;
        case TransformableListItemPosition.bottomEdge:
          fractionalOffset =
              isEven ? FractionalOffset.topLeft : FractionalOffset.topRight;
          rotateDirection = isEven ? 1 : -1;
          break;
      }

      final rotateAngle = animationProgress * maxRotationTurnsInRadians;
      final translation = fractionalOffset.alongSize(item.size);

      paintTransform
        ..translate(translation.dx, translation.dy)
        ..rotateZ(rotateDirection * rotateAngle)
        ..translate(-translation.dx, -translation.dy);
    }

    return paintTransform;
  }

  static Matrix4 wheel(TransformableListItem item) {
    /// rotate item to 36 degrees
    const maxRotationTurnsInRadians = pi / 5.0;
    const minScale = 0.6;
    const maxScale = 1.0;

    /// perception of depth when the item rotates
    const depthFactor = 0.01;

    /// offset when [animationProgress] == 0
    final medianOffset = item.constraints.viewportMainAxisExtent / 2;
    final animationProgress =
        1 - item.offset.dy.clamp(0, double.infinity) / medianOffset;
    final scale = minScale + (maxScale - minScale) * animationProgress.abs();

    /// alignment of item
    final translationOffset = FractionalOffset.center.alongSize(item.size);
    final rotationMatrix = Matrix4.identity()
      ..setEntry(3, 2, depthFactor)
      ..rotateX(maxRotationTurnsInRadians * animationProgress)
      ..scale(scale);

    final result = Matrix4.identity()
      ..translate(translationOffset.dx, translationOffset.dy)
      ..multiply(rotationMatrix)
      ..translate(-translationOffset.dx, -translationOffset.dy);

    return result;
  }
}
