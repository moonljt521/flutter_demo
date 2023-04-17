import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


/// 自定义一个renderBox， 继承自RenderShiftedBox（它的父类是renderBox）
class CustomRenderBox extends StatefulWidget {

  const CustomRenderBox({super.key});

  @override
  State<CustomRenderBox> createState() => _CustomRenderBoxPageState();
}

class _CustomRenderBoxPageState extends State<CustomRenderBox> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('自定义renderBox'),
      ),
      body: MyAlignWidget(
        alignment: Alignment.bottomRight,
        child: Container(
          width: 100,
          height: 50,
          color: Colors.red,
        )
      ),
    );
  }
}


class MyRenderShiftbox extends RenderShiftedBox {

  AlignmentGeometry? alignment;

  MyRenderShiftbox({this.alignment,
    RenderBox? child,
  }) : super(child);

  @override
  void performLayout() {

    /// 测量
    /// 父级向子级传递约束，子级必须服从给定的约束。
    /// parentUsesSize为true，表示父级依赖于子级的布局，子级布局改变，父级也要重新布局
    /// 反之，子级发生改变，不会通知父级。即父级不依赖子级
    child?.layout(BoxConstraints(
      minHeight: 0,
      maxHeight: constraints.maxHeight,
      minWidth: 0,
      maxWidth: constraints.maxWidth
    ), parentUsesSize: true);

    final BoxParentData? parentData = child?.parentData as BoxParentData?;
    /// !!! 关于方位计算， 可以手动判断，自由确定

    // if(alignment == Alignment.center){
    //   parentData?.offset = Offset((constraints.maxWidth - (child?.size.width ?? 0))/2,
    //       (constraints.maxHeight - (child?.size.height ?? 0))/2);
    // }else{
    //   parentData?.offset = Offset(0, 0);
    // }

    /// ！！也可以用Aliment 自带的
    var of = (Size(constraints.maxWidth, constraints.maxHeight) - (child!.size)) as Offset;
    parentData?.offset = (alignment as Alignment).alongOffset(of);

    /// 确定自己的“布局细节”
    size = Size(this.constraints.maxWidth, constraints.maxHeight);
  }

}

/// 自定义对齐布局Widget
class MyAlignWidget extends SingleChildRenderObjectWidget{

  MyAlignWidget({this.alignment=Alignment.center,required Widget child}):super(child:child);

  final AlignmentGeometry alignment;

  @override
  SingleChildRenderObjectElement createElement() {
    return super.createElement();
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    // 创建我们自定义的渲染对象
    return MyRenderShiftbox(alignment: alignment);
  }
}