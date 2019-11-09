import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/widget/grid_nav.dart';

import 'package:flutter_trip/widget/local_nav.dart';

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

  void loadData() {
    HomeDao.fetch().then((homeModel) {
      setState(() {
        //轮播图
        bannerData = homeModel.bannerList;
        //本地导航
        localNavData = homeModel.localNavList;
        //网格导航数据
        gridNavModel = homeModel.gridNav;
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
    return Opacity(
      opacity: _appBarAlpha,
      child: Container(
        height: 80,
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text("首页"),
          ),
        ),
      ),
    );
  }

  ///本地导航
  Widget _createLocalNav() {
    return LocalNav(localNavData: localNavData);
  }

  ///网格导航
  Widget _createGridNav()
  {
    return GridNav(gridNavModel: gridNavModel,);
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
