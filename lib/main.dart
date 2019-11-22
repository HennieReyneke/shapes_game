import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
//import 'sky.dart';
import 'surface.dart';
import 'audio.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  double appBarHeight;
  double statusBarHeight;
  List<Offset> _pList;
  Audio audio;
  AnimationController controller;
  Animation<double> _animation;
  int shape;
  bool shapeChanged;

  _MyHomePageState() {
    _pList = <Offset>[];
    audio = Audio();
  }

  @override
  initState() {
    shape = 0;
    shapeChanged = false;
    audio.getAssetPaths(context);
    super.initState();

    controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _animation = new CurvedAnimation(
      parent: controller,
      curve: new Interval(0.0, 1.0, curve: Curves.linear),
    );
  }

  void resetShapeChanged() {
    shapeChanged = false;
  }

  void clearPList() {
    _pList.clear();
  }

  Widget createAppBar() {
    AppBar appBar = new AppBar(
      title: Text(widget.title),
      backgroundColor: Colors.teal,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: () {
            setState(() {
              shapeChanged = true;
              controller.reset();
              if (shape < 2)
                shape++;
              else
                shape = 0;
            });
          },
        )
      ],
    );
    appBarHeight = appBar.preferredSize.height;
    return appBar;
  }

  @override
  Widget build(BuildContext context) {
    statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: createAppBar(),
      body: Listener(
        onPointerMove: (PointerMoveEvent event) {
          //y = event.position.dy - appBarHeight - statusBarHeight;
          //x = event.position.dx;
          //print('x: ${event.position.dx} y: $y');
          //x = event.localPosition.dx;
          //y = event.localPosition.dy;
          //surface.checkPoints(x, y);
          setState(() {
            _pList = List.from(_pList)..add(event.localPosition);
          });
        },
        child: AnimatedBuilder(
          animation: _animation,
          builder: (BuildContext context, Widget child) {
            return new Container(
              child: CustomPaint(
                painter: Surface(_pList, audio, controller, _animation.value,
                    shape, shapeChanged, resetShapeChanged, clearPList),
                child: Center(
                  child: Text(
                    '',
                    style: const TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    print('dispose()');
    audio.stopAudio();
    super.dispose();
  }
}
