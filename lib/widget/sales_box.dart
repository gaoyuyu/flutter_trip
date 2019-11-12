import 'package:flutter/material.dart';
import 'package:flutter_trip/model/sales_box_model.dart';

class SalesBox extends StatelessWidget {
  final SalesBoxModel salesBoxData;

  const SalesBox({Key key, @required this.salesBoxData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(7, 4, 7, 4),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(2.0)),
      child: _create(),
    );
  }

  Widget _create() {
    return Column(
      children: <Widget>[
        createTitleRow(),
        createItemRow(salesBoxData.bigCard1.icon,salesBoxData.bigCard2.icon),
        createItemRow(salesBoxData.smallCard1.icon,salesBoxData.smallCard2.icon),
        createItemRow(salesBoxData.smallCard3.icon,salesBoxData.smallCard3.icon),
      ],
    );
  }

  Widget createTitleRow() {
    String imgUrl = salesBoxData.icon;
    return Container(
      padding: EdgeInsets.fromLTRB(7, 10, 7, 10),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.black12, width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.network(imgUrl, fit: BoxFit.fill, width: 80),
          Container(
            padding: EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
            decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [Colors.pink, Colors.pinkAccent]),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              "获取更多福利 >",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget createItemRow(String imgUrl1, String imgUrl2) {
    BorderSide borderSide = BorderSide(color: Colors.black12, width: 0.5);
    return Container(
      decoration: BoxDecoration(border: Border(bottom: borderSide)),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(border: Border(right: borderSide)),
              child: Image.network(
                imgUrl1,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Image.network(
              imgUrl2,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
