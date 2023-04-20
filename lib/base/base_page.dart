import 'package:flutter/material.dart';

abstract class BasePage extends StatefulWidget {

  final String? title;

  Widget pageBody(BuildContext context);

  BasePage({super.key, this.title});

  onCreate() {

  }

  onDestroy() {

  }

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<BasePage> {

  @override
  void initState() {
    super.initState();
    widget.onCreate();
  }

  @override
  void dispose() {
    super.dispose();
    widget.onDestroy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ''),
      ),
      body: widget.pageBody(context),
    );
  }
}
