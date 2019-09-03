import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '我的APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '我的 APP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int myCount=1;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  void _add(){
    setState((){
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    var container = new Container( // grey box
      child: new Text(
        "Lorem ipsum",
        style: new TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
          fontFamily: "Georgia",
        ),
      ),
      width: 320.0,
      height: 240.0,
      color: Colors.grey[300],
    );
   return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children:<Widget>[
                Expanded(
                  flex:1,
                child: Text('You have pushed the button this many times:')
                ),
                Expanded(
                  flex:1,
                child: Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.display1,
                )
                ),
                Expanded(
                    flex:4,
                    child: container
                )
              ]
            )
//            Text(
//              'You have pushed the button this many times:',
//            ),
//            Text(
//              '$_counter',
//              style: Theme.of(context).textTheme.display1,
//            ),


          ],


        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
