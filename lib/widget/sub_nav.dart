import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';

///子网格导航
class SubNav extends StatelessWidget {
  final List<CommonModel> subNavData;

  const SubNav({Key key, @required this.subNavData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(7, 4, 7, 4),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        children: <Widget>[
          Row(
            children: _createData(subNavData.sublist(0, 5)),
          ),
          Row(
            children: _createData(subNavData.sublist(5, 10)),
          ),
        ],
      ),
    );
  }

  List<Widget> _createData(List<CommonModel> list) {
    List<Widget> data = [];
    list.forEach((item) {
      String imgUrl = item.icon;
      String title = item.title;
      data.add(_buildItem(imgUrl, title));
    });
    return data;
  }

  Widget _buildItem(String imgUrl, String title) {
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        child: Column(
          children: <Widget>[
            Image.network(
              imgUrl,
              fit: BoxFit.fill,
              width: 18,
              height: 18,
            ),
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 5),
              child: Text(
                title,
                style: TextStyle(fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}
