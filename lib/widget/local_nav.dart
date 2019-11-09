import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';

///本地导航
class LocalNav extends StatelessWidget {
  final List<CommonModel> localNavData;

  const LocalNav({Key key, @required this.localNavData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
      margin: EdgeInsets.fromLTRB(7, 4, 7, 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Row(
        //子元素平均充满
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _create(),
      ),
    );
  }

  Widget _buildItem(String imgUrl, String text) {
    return Container(
      child: Column(
        children: <Widget>[
          Image.network(
            imgUrl,
            fit: BoxFit.fill,
            width: 32,
            height: 32,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }

  List<Widget> _create() {
    List<Widget> items = [];
    localNavData.forEach((item) {
      items.add(_buildItem(item.icon, item.title));
    });
    return items;
  }
}
