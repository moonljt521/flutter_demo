
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_demo/base/base_page.dart';

class ZoneCallBackPage extends BasePage {

  ZoneCallBackPage({super.key , super.title});

  @override
  Widget pageBody(BuildContext context) {
    return MyWidget();
  }
}


class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String _text = 'Hello';

  void _updateText() async {
// 使用Zone.bindCallback来绑定一个异步回调函数
    var callback = Zone.current.bindCallback(() async {
      await Future.delayed(Duration(seconds: 1));
      return 'World';
    });
// 在回调函数执行后更新状态
    var result = await callback();
    setState(() {
      _text = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(_text),
        ElevatedButton(
          onPressed: _updateText,
          child: Text('Update'),
        ),
      ],
    );
  }
}