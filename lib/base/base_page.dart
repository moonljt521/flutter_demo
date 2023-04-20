import 'package:flutter/material.dart';

abstract class BasePage extends StatefulWidget {

  final String? title;

  Widget pageBody(BuildContext context);

  BasePage({super.key, this.title});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<BasePage> {

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
