import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverSideBySide extends MultiChildRenderObjectWidget {
  SliverSideBySide({
    super.key,
    required Widget leftChild,
    required Widget rightChild,
  }) : super(children: [leftChild, rightChild]);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSliverSideBySide();
  }
}

class _ParentData extends SliverPhysicalParentData
    with ContainerParentDataMixin<RenderSliver> {}

class RenderSliverSideBySide extends RenderSliver
    with ContainerRenderObjectMixin<RenderSliver, _ParentData> {
  RenderSliverSideBySide();

  RenderSliver get leftChild => firstChild!;
  SliverPhysicalParentData get leftChildParentData =>
      leftChild.parentData! as SliverPhysicalParentData;

  RenderSliver get rightChild => lastChild!;
  SliverPhysicalParentData get rightChildParentData =>
      rightChild.parentData! as SliverPhysicalParentData;

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! _ParentData) {
      child.parentData = _ParentData();
    }
  }

  @override
  void performLayout() {
    final constraints = this.constraints;

    leftChild.layout(
      constraints.copyWith(
        crossAxisExtent: constraints.crossAxisExtent / 2,
      ),
      parentUsesSize: true,
    );
    rightChild.layout(
      constraints.copyWith(
        crossAxisExtent: constraints.crossAxisExtent / 2,
      ),
      parentUsesSize: true,
    );

    final leftGeometry = leftChild.geometry!;
    final rightGeometry = rightChild.geometry!;

    final height =
        math.max(leftGeometry.scrollExtent, rightGeometry.scrollExtent);

    leftChildParentData.paintOffset = Offset.zero;
    rightChildParentData.paintOffset =
        Offset(constraints.crossAxisExtent / 2, 0);

    geometry = SliverGeometry(
      scrollExtent: height,
      paintExtent:
          math.max(leftGeometry.paintExtent, rightGeometry.paintExtent),
      maxPaintExtent: height,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context
      ..paintChild(leftChild, offset)
      ..paintChild(
        rightChild,
        offset + Offset(constraints.crossAxisExtent / 2, 0),
      );
  }

  @override
  bool hitTest(
    SliverHitTestResult result, {
    required double mainAxisPosition,
    required double crossAxisPosition,
  }) {
    return leftChild.hitTest(
          result,
          mainAxisPosition: mainAxisPosition,
          crossAxisPosition: crossAxisPosition,
        ) ||
        rightChild.hitTest(
          result,
          mainAxisPosition: mainAxisPosition,
          crossAxisPosition:
              crossAxisPosition - constraints.crossAxisExtent / 2,
        );
  }

  @override
  bool hitTestChildren(
    SliverHitTestResult result, {
    required double mainAxisPosition,
    required double crossAxisPosition,
  }) {
    return leftChild.hitTestChildren(
          result,
          mainAxisPosition: mainAxisPosition,
          crossAxisPosition: crossAxisPosition,
        ) ||
        rightChild.hitTestChildren(
          result,
          mainAxisPosition: mainAxisPosition,
          crossAxisPosition:
              crossAxisPosition - constraints.crossAxisExtent / 2,
        );
  }

  @override
  void applyPaintTransform(covariant RenderObject child, Matrix4 transform) {
    if (child == rightChild) {
      transform.translate(constraints.crossAxisExtent / 2, 0);
    }
  }
}
