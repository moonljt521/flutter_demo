import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


/// 自定义一个renderBox， 继承自RenderShiftedBox（它的父类是renderBox）
class CustomRenderRenderconstrainedbox extends StatefulWidget {

  const CustomRenderRenderconstrainedbox({super.key});

  @override
  State<CustomRenderRenderconstrainedbox> createState() => _State();
}

class _State extends State<CustomRenderRenderconstrainedbox> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('触摸屏幕产生光圈'),
      ),
      body: TouchHighlight(
        child: Center(
          child: Text("Hello"),
        ),
      ),
    );
  }
}


class TouchHighlightRender extends RenderConstrainedBox {
  TouchHighlightRender() : super(additionalConstraints: const BoxConstraints.expand());

  // 自身是否可进行命中检测
  @override
  bool hitTestSelf(Offset position) => true;

  final Map<int, Offset> _dots = <int, Offset>{};

  // 实现该方法用于处理事件
  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent || event is PointerMoveEvent) {
      _dots[event.pointer] = event.position;
      markNeedsPaint();
    } else if (event is PointerUpEvent || event is PointerCancelEvent) {
      _dots.remove(event.pointer);
      markNeedsPaint();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    canvas.drawRect(offset & size, Paint()..color = const Color(0xFFE6E6FA));

    final Paint paint = Paint()..color = const Color(0xFFFFFF00);
    for (Offset point in _dots.values)
      canvas.drawCircle(point, 50.0, paint);

    super.paint(context, offset);
  }
}

///
/// 触摸高亮控件
///
class TouchHighlight extends SingleChildRenderObjectWidget {
  const TouchHighlight({ Key? key, required Widget child }) : super(key: key, child: child);

  @override
  TouchHighlightRender createRenderObject(BuildContext context) => TouchHighlightRender();
}