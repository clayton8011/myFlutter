//import 'package:provide/provide.dart';
import 'package:flutter/material.dart';
//import '../config/string.dart';
import '../config/index.dart';
import '../service/http_service.dart';
import 'dart:convert';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; //屏幕尺寸兼容


class HomePage extends StatefulWidget{
  _HomePageState  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
//  火爆专区分页
  int page=1;
  List<Map> hotGoodsList = [];
//防止刷新 保持页面状态
  @override
  bool get wantKeepAlive =>true;
  GlobalKey<RefreshFooterState> _footerKey =new GlobalKey<RefreshFooterState>();
  @override
  void initState(){
    super.initState();
    print('首页刷新了');
  }
  @override
  Widget build(BuildContext context) {
//   super.build(context);
   return Scaffold(
     backgroundColor: KColor.bannerColor,
     appBar: AppBar(title: Text(KString.homeTitle),),
     body: FutureBuilder( //防止重绘
        future: request('homePageContent',formData:null),
        builder:(context,snapshot){
          if(snapshot.hasData){
            var data= json.decode(snapshot.data.toString());
//            print(data);
//            data.list;
            List<Map> swiperDataLIst=(data['data']['slides'] as List).cast();//轮播
            List<Map> navigatorList=(data['data']['category'] as List).cast();//分类
            List<Map> recommendList=(data['data']['recommend'] as List).cast();//商品推荐
            List<Map> floor1=(data['data']['floor1'] as List).cast();//底部商品推荐
            Map floorPic=data['data']['floor1Pic'];//广告
//            print(floorPic);

            return  EasyRefresh(
              refreshFooter: ClassicsFooter(
                key: _footerKey,
                bgColor: Colors.white,
                textColor: KColor.refreshTextColor,
                moreInfoColor: KColor.refreshTextColor,
                showMore: true,
                noMoreText: '',
                moreInfo: KString.loading,//加载中
                loadReadyText: KString.loadReady,
              ),
              child: ListView(
                children: <Widget>[
                  SwiperDiy(
                      swiperDataList:swiperDataLIst,
                  ),
                  TopNavigator(
                      navigatorList:navigatorList
                  ),
                  RecommendUI(
                      recommendList:recommendList
                  ),
                  FloorPic(floorPic:floorPic),
                  Floor(floor: floor1),
                  _hotGoods()
                ],
              ),
              loadMore: ()async{
                print('开始加载更多');
                _getHotGoods();
              },
            );
          }else{
            return Center(
              child: Text('加载中...'),
            );
          }

       }
     ),
   );
  }
  void _getHotGoods() {
    var formPage = {'page':page};
    request('getHotGoods',formData: formPage).then((val){
      var data=json.decode(val.toString());
      List<Map> newGoodsList = (data['data'] as List).cast();
      //设置火爆专区数据列表
      setState((){
        hotGoodsList.addAll(newGoodsList);
        page ++;
      });
      print(data);
      print('aaa');
    });
  }
  //火爆专区标题
  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10),
    padding: EdgeInsets.all(5),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(width: 0.5,color: KColor.defaultBorderColor)
      ),
    ),
    child: Text(KString.hotGoodsTitle,style: TextStyle(color: KColor.homeSubTitleTextColor),),//火爆专区
  );
  //火爆专区列表行
  Widget _wrapList(){
     if(hotGoodsList.length >0){
       List<Widget> listWidget= hotGoodsList.map((val) {
         return InkWell(
           onTap: (){

           },
            child: Container(
              width: ScreenUtil().setWidth(372),
              color: Colors.white,
              padding: EdgeInsets.all(5.0),
              margin: EdgeInsets.only(bottom:3.0),
              child: Column(
                children: <Widget>[
                  Image.network(
                    val['image'],
                    width: ScreenUtil().setWidth(375),
                    height: ScreenUtil().setHeight(375),
                    fit: BoxFit.cover,
                  ),
                  Text(
                    val['name'],
                    maxLines:1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: ScreenUtil().setSp(26)),
                  ),
                  Row(
                    children: <Widget>[
                      Text('￥${val['presentPrice']}',style:TextStyle(color: KColor.presentPriceTextColor) ,),
                      Text('￥${val['oriPrice']}',style:TextStyle(color: KColor.oriPriceTextColor))
                        ],
                  ),
                ],
              ),
            ),
         );
       }).toList();
       return Wrap(
         spacing: 2,
         children: listWidget,
       );
     }else{
       return Text('');
     }
  }
  //火爆专区组合
  Widget _hotGoods(){
    return Container(
      child: Column(
        children: <Widget>[
          hotTitle,
          _wrapList()
        ],
      ),
    );
  }
}

//首页轮播组件编写
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;
  SwiperDiy({Key key, this.swiperDataList}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemCount: swiperDataList.length,
        itemBuilder: (BuildContext context,int index){
          return InkWell(
            onTap: (){

            },
            child: Image.network("${swiperDataList[index]['image']}",fit: BoxFit.cover,),
          );
        },
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}
class TopNavigator extends StatelessWidget {
  final List navigatorList;
  TopNavigator({Key key,this.navigatorList}) : super(key:key);

  Widget _gridViewItemUI(BuildContext context,item,index){
    return InkWell(
      onTap: (){
        //跳转分类
      },
      child: Column(
        children: <Widget>[
          Image.network(item['image'],width: ScreenUtil().setWidth(95),),
          Text(item['firstCategoryName'])
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context){
    if(navigatorList.length>10){
      navigatorList.removeRange(10, navigatorList.length);
    }
    var tempIndex = -1;
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5.0),
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),//禁止滚动
        crossAxisCount: 5,
        padding: EdgeInsets.all(4.0),
        children: navigatorList.map((item){
          tempIndex++;
          return _gridViewItemUI(context, item, tempIndex);
        }).toList(),
      ),
    );
  }
}
//商品推荐
class RecommendUI extends StatelessWidget {
  final List recommendList;
  var tempIndex = -1;
  RecommendUI({Key key,this.recommendList}) : super(key:key);
  @override
  Widget build(BuildContext context){
      return Container(
        margin: EdgeInsets.only(top: 10.0),
        child: Column(
          children: <Widget>[
            _titleWidget(),
            _recommendList(context),
          ],
        ),
      );
  }
  Widget _titleWidget(){
   return Container(
     alignment: Alignment.centerLeft,
     padding: EdgeInsets.fromLTRB(10, 2.0, 0, 5.0),
     decoration: BoxDecoration(
       color: Colors.white,
       border: Border(
         bottom: BorderSide(width: 0.5,color: KColor.defaultBorderColor)
       ),
     ),
     child:Text(
       KString.recommendText,//商品推荐
       style: TextStyle(color: KColor.homeSubTitleTextColor),
     ),
   );
  }
//列表
  Widget _recommendList(BuildContext context){

    return Container(
      height: ScreenUtil().setHeight(380) ,
      child:ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context ,index){
//          recommendList.Map
//          return _recommendBox(context,item,index);
//          return _recommendBox();
          return _item(index, context);
        },
      ),
    );
  }

  Widget _item(index, context){
    return InkWell(
      onTap: (){
        //跳转分类
      },
      child:Container(
        width: ScreenUtil().setWidth(280),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(width: 0.5,color: KColor.defaultBorderColor)
          )
        ),
        child: Column(
            children: <Widget>[
              Expanded(
                child:Image.network(recommendList[index]['image'],width: ScreenUtil().setWidth(280),height: ScreenUtil().setHeight(280),fit: BoxFit.fitWidth),
              ),
               Text('￥${recommendList[index]['presentPrice']}',style: TextStyle(color: KColor.presentPriceTextColor),) ,
              Text('${recommendList[index]['oriPrice']}',style: KFont.oriPriceStyle) ,


            ],
        ),
      ),
    );
  }

}
class FloorPic extends StatelessWidget {
  final Map floorPic;
  FloorPic({Key key,this.floorPic}) : super(key:key);
  @override
  Widget build(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(bottom: 20),
      child:InkWell(
        child: Image.network(
          floorPic['PICTURE_ADDRESS'],
          fit:BoxFit.cover,
        ),
        onTap: (){

        },
      ) ,
    );
  }
}
//商品推荐下层
class Floor extends StatelessWidget {
  List<Map>  floor;
  Floor({Key key,this.floor}) : super(key:key);
  void jumpDetail(context,String gooId){
  }
  @override
  Widget build(BuildContext context){
    double width= ScreenUtil.getInstance().width;
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 4),
                  height: ScreenUtil().setHeight(400),
                  child: InkWell(
                    child: Image.network(
                      floor[0]['image'],
                      fit:BoxFit.cover
                    ),
                    onTap: (){
                      jumpDetail(context,floor[0]['goodsId']);
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 4),
                  height: ScreenUtil().setHeight(200),
                  child: InkWell(
                    child: Image.network(
                        floor[1]['image'],
                        fit:BoxFit.cover
                    ),
                    onTap: (){
                      jumpDetail(context,floor[1]['goodsId']);
                    },
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 4,left: 1,bottom: 1),
                  height: ScreenUtil().setHeight(200),
                  child: InkWell(
                    child: Image.network(
                        floor[2]['image'],
                        fit:BoxFit.cover
                    ),
                    onTap: (){
                      jumpDetail(context,floor[2]['goodsId']);
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 1,left: 1),
                  height: ScreenUtil().setHeight(200),
                  child: InkWell(
                    child: Image.network(
                        floor[3]['image'],
                        fit:BoxFit.cover
                    ),
                    onTap: (){
                      jumpDetail(context,floor[3]['goodsId']);
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 1,left: 1),
                  height: ScreenUtil().setHeight(200),
                  child: InkWell(
                    child: Image.network(
                        floor[4]['image'],
                        fit:BoxFit.fitWidth
                    ),
                    onTap: (){
                      jumpDetail(context,floor[4]['goodsId']);
                    },
                  ),
                )

              ],
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,//等间
        mainAxisSize:MainAxisSize.min ,
      ),
    );
  }
}

//class FloorPic extends StatelessWidget {
//  final Map floorPic;
//  FloorPic({Key key,this.floorPic}) : super(key:key);
//  @override
//  Widget build(BuildContext context){
//
//  }
//}