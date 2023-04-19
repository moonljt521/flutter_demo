import 'package:flutter/material.dart';

abstract class BasePage extends StatefulWidget {

  final String? title;

  BasePage({super.key, this.title});

  @override
  State<StatefulWidget> createState() {
    return create_state();
  }

  State<StatefulWidget> create_state();
}

abstract class BaseState<T extends BasePage> extends State<T> {

  void onCreate(){

  }

  //页面布局
  Widget pageBody(BuildContext context);

  @override
  void initState() {
    super.initState();
    onCreate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ''),
      ),
      body: pageBody(context),
    );
  }

}