import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              child: _createBanner(),
              height: 160,
            ),
          ],
        ),
      ),
    );
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
}
