import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class CustomMultiChildRenderObjectWidgetPage extends StatefulWidget {
  const CustomMultiChildRenderObjectWidgetPage({super.key});

  @override
  State<CustomMultiChildRenderObjectWidgetPage> createState() => _State();
}

class _State extends State<CustomMultiChildRenderObjectWidgetPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('自定义 MultiChildRenderObjectWidget 多孩儿布局'),
      ),
      body: TopBottomLayout(
        list: [
          Text('top'),
          Text('bottom'),
        ],
      ),
    );
  }
}


class TopBottomLayout extends MultiChildRenderObjectWidget {

  TopBottomLayout({Key? key, required List<Widget> list})
      : assert(list.length == 2, "只能传两个 child"),
        super(key: key, children: list);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return TopBottomRender();
  }
}

class TopBottomParentData extends ContainerBoxParentData<RenderBox> {}

class TopBottomRender extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, TopBottomParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, TopBottomParentData> {
  /// 初始化每一个 child 的 parentData
  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! TopBottomParentData)
      child.parentData = TopBottomParentData();
  }

  @override
  void performLayout() {
    //获取当前约束(从父组件传入的)，
    final BoxConstraints constraints = this.constraints;

    //获取第一个组件，和他父组件传的约束
    RenderBox? topChild = firstChild;
    TopBottomParentData childParentData =
    topChild?.parentData as TopBottomParentData;

    //获取下一个组件
    //至于这里为什么可以获取到下一个组件，是因为在 多子组件的 mount 中，遍历创建所有的 child 然后将其插入到到 child 的 childParentData 中了
    RenderBox? bottomChild = childParentData.nextSibling;

    //限制下孩子高度不超过总高度的一半
    bottomChild?.layout(
        constraints.copyWith(maxHeight: constraints.maxHeight / 2),
        parentUsesSize: true);

    //设置下孩子的 offset
    childParentData = bottomChild?.parentData as TopBottomParentData;
    //位于最下边
    childParentData.offset = Offset(0, constraints.maxHeight - (bottomChild?.size.height ?? 0));

    //上孩子的 offset 默认为 (0,0),为了确保上孩子能始终显示，我们不修改他的 offset
    topChild?.layout(
        constraints.copyWith(
          //上侧剩余的最大高度
            maxHeight: constraints.maxHeight - (bottomChild?.size.height ?? 0)),
        parentUsesSize: true);

    //设置上下组件的 size
    size = Size(
        max((topChild?.size.width ?? 0), (bottomChild?.size.width ?? 0)),
        constraints.maxHeight);
  }

  double max(double height, double height2) {
    if (height > height2)
      return height;
    else
      return height2;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset? position}) {
    return defaultHitTestChildren(result, position: position ?? Offset.zero);
  }
}