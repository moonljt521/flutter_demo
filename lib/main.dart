import 'package:flutter/material.dart';
import 'package:flutter_demo/widget/custom_render_box.dart' deferred as custom_render_box_page;
import 'package:flutter_demo/widget/drag_a_letter.dart' deferred as drag_a_letter_page;
import 'package:flutter_demo/widget/wonderous_photo_gallery.dart' deferred as wonderous_photo_gallery_page;
import 'package:flutter_demo/widget/reflect_widget_page.dart' deferred as reflect_widget_page_page;
import 'package:flutter_demo/widget/custom_render_renderconstrainedbox.dart' deferred as renderconstrainedbox;
import 'package:flutter_demo/widget/custom_multi_childrenderobject_widget.dart' deferred as custom_multi_childrenderobject;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo'),
      routes: routes,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var routeLists = [];

  @override
  void initState() {
    super.initState();
    routeLists = routes.keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.separated(itemBuilder: (ctx ,index ){
        return TextButton(onPressed: (){

          Navigator.of(context).pushNamed(routeLists[index]);

        }, child: Container(
          alignment: Alignment.centerLeft,
          child: Text(routeLists[index] , style: TextStyle(fontSize: 17),),
        ));
      }, separatorBuilder: (ctx , index){
            return Container(
              height: 0.5,
              width: double.infinity,
              color: Colors.blueAccent,
            );
          }, itemCount: routeLists.length),
    );
  }
}


Map<String,WidgetBuilder> routes = {
  "自定义renderBox": (context) {
    return ContainerAsyncRouterPage(custom_render_box_page.loadLibrary(),
            (context) {
          return custom_render_box_page.CustomRenderBox(title: '自定义renderBox',);
        });
  },
  "拖拽示例": (context) {
    return ContainerAsyncRouterPage(drag_a_letter_page.loadLibrary(),
            (context) {
          return drag_a_letter_page.DragALetter();
        });
  },
  "仿Wonderous相册效果":(context) {
    return ContainerAsyncRouterPage(wonderous_photo_gallery_page.loadLibrary(),
            (context) {
          return wonderous_photo_gallery_page.PhotoGalleryDemoPage();
        });
  },
  "显示倒影":(context) {
      return ContainerAsyncRouterPage(reflect_widget_page_page.loadLibrary(),
              (context) {
            return reflect_widget_page_page.ReflectWidgetPage();
          });
    },
  "触摸屏幕产生光圈":(context) {
        return ContainerAsyncRouterPage(renderconstrainedbox.loadLibrary(),
                (context) {
              return renderconstrainedbox.CustomRenderRenderconstrainedbox();
            });
      },
  "自定义 MultiChildRenderObjectWidget 多孩儿布局":(context) {
          return ContainerAsyncRouterPage(custom_multi_childrenderobject.loadLibrary(),
                  (context) {
                return custom_multi_childrenderobject.CustomMultiChildRenderObjectWidgetPage();
              });
        },

};

class ContainerAsyncRouterPage extends StatelessWidget {
  final Future libraryFuture;

  ///不能直接传widget，因为 release 打包时 dart2js 优化会导致时许不对
  final WidgetBuilder child;

  ContainerAsyncRouterPage(this.libraryFuture, this.child);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: libraryFuture,
        builder: (c, s) {
          if (s.connectionState == ConnectionState.done) {
            if (s.hasError) {
              return Scaffold(
                appBar: AppBar(),
                body: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Error: ${s.error}',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            }
            return child.call(context);
          }
          return Scaffold(
            appBar: AppBar(),
            body: Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}