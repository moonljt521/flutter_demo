

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_demo/base/base_page.dart';

class TestStreamBuilder extends BasePage {

  TestStreamBuilder({super.key , super.title});

  late StreamController<int> streamController;

  late StreamSubscription<int> subscription;

  late StreamSink<int> streamSink;

  late Stream<int> stream;

  var a = 0;

  @override
  onCreate(){
    streamController = StreamController<int>();

    streamSink = streamController.sink;

    stream = streamController.stream;

    // 1 互斥
    // subscription = stream.listen((event) {
    //   print('$event');
    // });
  }

  @override
  onDestroy(){
    streamController.close();
  }

  @override
  Widget pageBody(BuildContext context) {
    return StreamBuilder<int>(
        initialData: 0,
        stream: stream, // 2 与1互斥
        builder: (ctx , snaps){
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Text('${snaps.data}'),
            SizedBox(height: 10,),
            MaterialButton(
                child: Text('click'),
                onPressed: (){
                  a ++;
                streamController.add(a);

            }),
          ],
        ),
      );
    });
  }

}