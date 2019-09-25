//import 'package:provide/provide.dart';
import 'package:flutter/material.dart';
//import '../config/string.dart';
import '../config/index.dart';
import '../service/http_service.dart';
import 'dart:convert';


class HomePage extends StatefulWidget{
  _HomePageState  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
//   super.build(context);
   return Scaffold(
     backgroundColor: KColor.bannerColor,
     appBar: AppBar(title: Text(KString.homeTitle),),
     body: FutureBuilder( //防止重绘
        future: request('homePageContent',formData:null),
        builder:(context,snapshot){
           print(snapshot);
           print(snapshot.hasData);
          if(snapshot.hasData){
            var data= json.decode(snapshot.data.toString());
            print('aaa');
            return  Container(
              child: Text('imc '),
            );
          }else{
            return Container(
              child: Text('加载中'),
            );
          }

       }
     ),
   );
  }
}