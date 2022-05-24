<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

Scrollable widgets with easily customizable transform animations.

## Features

The package contains 3 widgets: 

- `TransformableListView` that extends `ListView`
- `TransformableSliverList` that extends `SliverList`
- `TransformableSliver` that extends `SliverToBoxAdapter`

Each of then has `getTransformMatrix` callback. In the callback you need to return `Matrix4` that represetns transormation of the child at the current moment. If you don't need any transformations you can simply return `Matrix4.identity()`.

In `getTransformMatrix` callback you receive `TransformableListItem` with the data about list item:

- `Offset offset` is main axis offset of the child. By default (with vertical, non reversed scroll view) [offset.dx] is always 0 while [offset.dy] is the distance between top edge of the child and top edge of the viewport.
- `Size size` is the child size received from its `RenderBox`.
- `SliverConstraints constraints` describes the current scroll state of the viewport from the point of view of the sliver receiving the constraints.
- `int? index` is the index of the child. Will be null when using `TransformableSliver`.
- `TransformableListItemPosition position` is child position on the main axis viewport. Can be `TransformableListItemPosition.topEdge`, `TransformableListItemPosition.middle` or `TransformableListItemPosition.bottomEdge`.
- `double visibleExtent` is currently visible portion of item. For example, if item is hidden it will be `0` while it's completely displayed will equal to `size.height` or `size.width` depending on axis.


## Usage

First you need to add `TransformableListView` where you need transformations

```dart
TransformableListView.builder(
  getTransformMatrix: getTransformMatrix,
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
  itemCount: 30,
),
```

Second you need to implement `getTransformMatrix` callback

```dart
Matrix4 getTransformMatrix(TransformableListItem item) {
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
```

You can implement your own callback or check more at `/example` folder.

## Additional information

You can read more about matrix transfomations in Flutter [here](https://medium.com/flutter-community/advanced-flutter-matrix4-and-perspective-transformations-a79404a0d828). Any feedback and PRs are welcome.

Developed by [TBR Group](https://github.com/TBR-Group-software).

