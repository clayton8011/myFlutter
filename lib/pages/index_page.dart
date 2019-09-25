import 'package:provide/provide.dart';
import 'package:flutter/material.dart';
import '../config/index.dart';
import 'home_page.dart';
import 'cart_page.dart.';
import 'category_page.dart';
import 'member_page.dart';
import '../provide/current_index_provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; //屏幕尺寸兼容


class IndexPage extends StatelessWidget {
  final List<BottomNavigationBarItem> bottomTabs =[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text(KString.homeTitle) //首页
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.category),
      title: Text(KString.categoryTitle) //分类
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.shopping_cart),
      title: Text(KString.shoppingCartTitle) //购物车
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      title: Text(KString.memberTitle) //会员中心
    ),
  ];
  final List<Widget> tabBodies = [
    HomePage(),
    CategoryPage(),
    CartPage(),
    MemberPage()
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance= ScreenUtil(width: 750,height: 1334)..init(context);//屏幕兼容
    // TODO: implement build
    return Provide<CurrentIndexProvide>(
      builder:(context,child,val){
        int currentIndex = Provide.value<CurrentIndexProvide>(context).currentIndex;
        return Scaffold(
          backgroundColor: KColor.bannerColor,
          bottomNavigationBar: BottomNavigationBar(
            type:BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            items: bottomTabs,
            onTap: (index){
              Provide.value<CurrentIndexProvide>(context).chageIndex(index);
            },
          ),
          body: IndexedStack(
            index:currentIndex ,
            children: tabBodies,
          ),
        );
      }
    );
  }

}