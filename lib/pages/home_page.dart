import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _imageUrls = [
    "https://dimg06.c-ctrip.com/images/350l0n000000ec6k84D0F_C_500_280_Q80.jpg",
    "https://dimg06.c-ctrip.com/images/350u0n000000ebzm66D0A_C_500_280_Q80.jpg",
    "https://dimg06.c-ctrip.com/images/35020n000000ej21e8946_C_500_280_Q80.jpg"
  ];

  double _appBarAlpha = 0;

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
                    Container(
                      child: _createBanner(),
                      height: 160,
                    ),
                    Container(
                      height: 800,
                      child: Text("ssss"),
                    ),
                  ],
                ))),
        Opacity(
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
        ),
      ],
    ));
  }

  Swiper _createBanner() {
    return Swiper(
      autoplay: true,
      itemBuilder: (BuildContext context, int index) {
        return Image.network(
          _imageUrls[index],
          fit: BoxFit.fill,
        );
      },
      itemCount: 3,
      pagination: new SwiperPagination(),
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
