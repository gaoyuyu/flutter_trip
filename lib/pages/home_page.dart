import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/widget/grid_nav.dart';

import 'package:flutter_trip/widget/local_nav.dart';
import 'package:flutter_trip/widget/sales_box.dart';
import 'package:flutter_trip/widget/sub_nav.dart';

const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _appBarAlpha = 0;

  //轮播图数据
  List<CommonModel> bannerData = [];

  //本地导航数据
  List<CommonModel> localNavData = [];

  //网格导航数据
  GridNavModel gridNavModel;

  //子网格导航
  List<CommonModel> subNavData = [];

  //销售格子
  SalesBoxModel salesBoxData;

  void loadData() {
    HomeDao.fetch().then((homeModel) {
      setState(() {
        //轮播图
        bannerData = homeModel.bannerList;
        //本地导航
        localNavData = homeModel.localNavList;
        //网格导航数据
        gridNavModel = homeModel.gridNav;
        //子网格导航数据
        subNavData = homeModel.subNavList;
        //销售格子数据
        salesBoxData = homeModel.salesBox;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Stack(
      children: <Widget>[
        MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: NotificationListener(
                onNotification: (scrollNotification) {
                  //第0个元素也就是ListView滚动的时候触发监听
                  if (scrollNotification is ScrollUpdateNotification &&
                      scrollNotification.depth == 0) {
                    _onScroll(scrollNotification.metrics.pixels);
                  }
                  return false;
                },
                child: ListView(
                  children: <Widget>[
                    _createBanner(),
                    _createLocalNav(),
                    _createGridNav(),
                    _createSubNav(),
                    _createSalesBox(),
                  ],
                ))),
        _createAppBar(),
      ],
    ));
  }

  ///banner
  Widget _createBanner() {
    return Container(
      height: 180,
      child: Swiper(
        itemCount: bannerData.length,
        autoplay: true,
        loop: true,
        pagination: new SwiperPagination(),
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            bannerData[index].icon,
            fit: BoxFit.fill,
          );
        },
      ),
    );
  }

  ///appBar
  Widget _createAppBar() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 35, bottom: 9, left: 8),
            decoration: BoxDecoration(
                color: Color.fromARGB(
                    (_appBarAlpha * 255).toInt(), 255, 255, 255)),
            child: Row(
              children: <Widget>[
                Text(
                  "西安市",
                  style: TextStyle(
                      fontSize: 14,
                      color:
                          _appBarAlpha < 0.2 ? Colors.white : Colors.black54),
                ),
                Icon(Icons.expand_more,
                    size: 22,
                    color: _appBarAlpha < 0.2 ? Colors.white : Colors.black54),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 33,
                    padding: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Color(0xFFececec)),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.search,
                          color: Colors.blue,
                        ),
                        Expanded(
                          flex: 1,
                          child: Text("网红打卡地 景点 酒店 美食"),
                        ),
                        Icon(
                          Icons.keyboard_voice,
                          color: Color(0xFF969696),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 7, right: 7),
                  child: Icon(Icons.message,
                      color:
                          _appBarAlpha < 0.2 ? Colors.white : Colors.black54),
                ),
              ],
            ),
          ),
          //底部小阴影
          Container(
            height: _appBarAlpha < 0.2 ? 0 : 0.5,
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]),
          )
        ],
      ),
    );
  }

  ///本地导航
  Widget _createLocalNav() {
    return LocalNav(localNavData: localNavData);
  }

  ///网格导航
  Widget _createGridNav() {
    return GridNav(
      gridNavModel: gridNavModel,
    );
  }

  ///子网格导航
  Widget _createSubNav() {
    return SubNav(
      subNavData: subNavData,
    );
  }

  //销售格子
  Widget _createSalesBox() {
    return SalesBox(
      salesBoxData: salesBoxData,
    );
  }

  void _onScroll(double offset) {
    //顶部不动的时候offset=0
    print("_onScroll offset:$offset");
    double alpha = 0;
    if (offset == 0) {
      alpha = 0;
    } else {
      alpha = offset > APPBAR_SCROLL_OFFSET ? 1 : offset / APPBAR_SCROLL_OFFSET;
    }
    setState(() {
      _appBarAlpha = alpha;
    });
  }
}
