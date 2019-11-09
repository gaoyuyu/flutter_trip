import 'package:flutter/material.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';

///网格导航
class GridNav extends StatelessWidget {
  final GridNavModel gridNavModel;

  const GridNav({Key key, @required this.gridNavModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 7, right: 7),
      child: Column(
        children: <Widget>[
          _createRow(gridNavModel.hotel, 0),
          _createRow(gridNavModel.flight, 1),
          _createRow(gridNavModel.travel, 2),
        ],
      ),
    );
  }

  ///生成一行的Widget
  Container _createRow(GridNavItem gridNavItem, int index) {
    Color startColor = Color(int.parse('0xff${gridNavItem.startColor}'));
    Color endColor = Color(int.parse('0xff${gridNavItem.endColor}'));
    BorderRadius borderRadius = BorderRadius.all(Radius.circular(0));
    //根据位置来设置圆角的位置
    switch (index) {
      case 0:
        borderRadius = BorderRadius.only(
            topLeft: Radius.circular(5), topRight: Radius.circular(5));
        break;
      case 2:
        borderRadius = BorderRadius.only(
            bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5));
        break;
      default:
        borderRadius = BorderRadius.all(Radius.circular(0));
        break;
    }

    //设置渐变背景色
    BoxDecoration boxDecoration = BoxDecoration(
        gradient: LinearGradient(colors: [startColor, endColor]),
        borderRadius: borderRadius);

    return Container(
      decoration: boxDecoration,
      margin: EdgeInsets.only(bottom: 2),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _createLeftMainItem(
                  gridNavItem.mainItem.title, gridNavItem.mainItem.icon),
              _createRight(gridNavItem),
            ],
          )
        ],
      ),
    );
  }

  ///生成左边的大Item
  Widget _createLeftMainItem(String text, String imgUrl) {
    return Container(
      height: 88,
      width: 121,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 12),
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Image.network(
            imgUrl,
            fit: BoxFit.fill,
            height: 58,
          )
        ],
      ),
    );
  }

  //生成右边的2行
  Widget _createRight(GridNavItem gridNavItem) {
    return Expanded(
      flex: 1,
      child: Container(
          height: 88,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  _createItem(true, gridNavItem.item1.title),
                  _createItem(true, gridNavItem.item2.title),
                ],
              ),
              Row(
                children: <Widget>[
                  _createItem(false, gridNavItem.item3.title),
                  _createItem(false, gridNavItem.item4.title),
                ],
              ),
            ],
          )),
    );
  }

  //生成右边的单个的Item
  Expanded _createItem(bool isTop, String text) {
    var border1w = BorderSide(width: 0.5, color: Colors.white);
    var border2w = BorderSide(width: 1, color: Colors.white);

    var box2Top =
        BoxDecoration(border: Border(left: border2w, bottom: border1w));
    var box2Bottom =
        BoxDecoration(border: Border(left: border2w, top: border1w));

    return Expanded(
      flex: 1,
      child: Container(
        decoration: isTop ? box2Top : box2Bottom,
        height: 44,
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
