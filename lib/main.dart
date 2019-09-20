import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class MyAppBar extends StatelessWidget {
  MyAppBar({this.title});

  // Widget子类中的字段往往都会定义为"final"

  final Widget title;

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width-30,
      padding:new EdgeInsets.fromLTRB(0, 0,0, 0),
      decoration: new BoxDecoration(color: Colors.white),
        child: new Column(
            children: <Widget>[
              new Expanded(
                child: new SwiperView()
              ),
              new Expanded(
                child: new Text('Hello, world!',style:new TextStyle(fontSize: 20)),

              ),
              new Expanded(
                child: new Container(
                  width: 700,
                  height: 300,
                  color: Color.fromARGB(255, 238, 238, 238),
                ),
              ),
              new Expanded(
                child: new Container(
                  width: 700,
                  height: 1200,
                  color: Colors.red
                ),
              ),

            ]
        )
      // Row 是水平方向的线性布局（linear layout）
//      child: new SwiperView()
        //列表项的类型是 <Widget>


    );
  }
}

class MyScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Material 是UI呈现的“一张纸”
    return new Material(
      // Column is 垂直方向的线性布局.
      child: new Column(
        children: <Widget>[
          new MyAppBar(
            title: new Text(
              '首页',
              style: new TextStyle(color: const Color(0xff333333),fontSize:20),
            ),
          ),
          new Expanded(
              child: new Text('Hello, world!'),
          ),
          new Expanded(
            child: new Center(
              child: new MyScaffold2(),
            ),
          ),
        ],
      ),
    );
  }

}
class MyScaffold2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Material 是UI呈现的“一张纸”
    return new Material(
      // Column is 垂直方向的线性布局.
      child: new Column(
        children: <Widget>[

          new Expanded(
            child: new Center(
              child: new Text('Hello, world!'),
            ),
          ),
        ],
      ),
    );
  }

}


void main() {
  runApp(new MaterialApp(
    title: 'My app', // used by the OS task switcher
    home: new MyAppFr(),
  ));
}
//class MyAppBar1 extends StatefulWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new Container(
//      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
//      width: MediaQuery.of(context).size.width,
////        height: 200,
//      child: new SwiperView(),
////        children: <Widget>[
////          new Expanded(child: new SwiperView())
////        ]
//    );
//  }
//}
class SwiperView extends StatefulWidget {
  @override
  _SwiperViewState createState() => _SwiperViewState();
}

class _SwiperViewState extends State<SwiperView> {
  // 声明一个list，存放image Widget
  List<Widget> imageList = List();

  @override
  void initState() {
    imageList
      ..add(Image.network(
        'https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1568110987&di=aea83b9458dc0f8e3fe44deea76cba2a&src=http://pic.90sjimg.com/design/00/35/73/86/55e6ad5544a6c.jpg',
        fit: BoxFit.fill,
      ))
      ..add(Image.network(
        'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568121092626&di=79e2e7be5fb678c449dd1cb7c20dedb1&imgtype=0&src=http%3A%2F%2Fimg.sccnn.com%2Fbimg%2F337%2F45570.jpg',
        fit: BoxFit.fill,
      ))
      ..add(Image.network(
        'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568121131037&di=e60a1cd250957620622ce11a839e38d9&imgtype=0&src=http%3A%2F%2Fimg.xspic.com%2Fimg8%2F70%2F90%2F2579014_1.jpg',
        fit: BoxFit.fill,
      ))
      ..add(Image.network(
        'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568121148531&di=5e0c1f22a4147ea63d13e5f858efc700&imgtype=0&src=http%3A%2F%2Fpic208.nipic.com%2Ffile%2F20190305%2F110139_132813060030_2.jpg',
        fit: BoxFit.fill,
      ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title:new Text('轮播图',style: new TextStyle(color:Colors.black87,fontSize:20),),backgroundColor:Colors.white,centerTitle:true,),
        body: ListView(     // 这里使用listView是因为本地写了几组不同样式的展示，太懒了，所以这里就没有改
          children: <Widget>[
            firstSwiperView()
          ],
        )
    );
  }

  Widget firstSwiperView() {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
//      margin: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 20),
      width: MediaQuery.of(context).size.width,
      height: 190,
      child: Swiper(
        itemCount: 4,
        itemBuilder: _swiperBuilder,
        pagination: SwiperPagination(
            alignment: Alignment.bottomCenter,
//            margin: const EdgeInsets.fromLTRB(0, 0, 20, 10),
            builder: DotSwiperPaginationBuilder(
                color: Colors.black54,
                activeColor: Colors.white
            )
        ),
        controller: SwiperController(),
        scrollDirection: Axis.horizontal,
        autoplay: true,
        onTap: (index) => print('点击了第$index'),
      ),
    );
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    return (imageList[index]);
  }
}


class MyAppFr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Basic List';

    return new MaterialApp(
      title: title,
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text(title),
        ),
        body: new ListView(
          children: <Widget>[
            new ListTile(
              leading: new Icon(Icons.map),
              title: new Text('Map'),
            ),
            new ListTile(
              leading: new Icon(Icons.photo),
              title: new Text('Album'),
            ),
            new ListTile(
              leading: new Icon(Icons.phone),
              title: new Text('Phone'),
            ),
          ],
        ),
      ),
    );
  }
}