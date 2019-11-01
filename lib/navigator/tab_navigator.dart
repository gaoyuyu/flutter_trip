import 'package:flutter/material.dart';
import 'package:flutter_trip/pages/home_page.dart';
import 'package:flutter_trip/pages/my_page.dart';
import 'package:flutter_trip/pages/search_page.dart';
import 'package:flutter_trip/pages/travel_page.dart';

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = Colors.blue;
  var _currentIndex = 0;
  final PageController _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: <Widget>[
          HomePage(),
          SearchPage(),
          TravelPage(),
          MyPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            print(index);
            _controller.jumpToPage(index);
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            createBottomBarItem("首页", 0, Icons.home),
            createBottomBarItem("搜索", 1, Icons.search),
            createBottomBarItem("旅拍", 2, Icons.camera_alt),
            createBottomBarItem("我的", 3, Icons.account_circle),
          ]),
    );
  }

  ///生成底部Item
  BottomNavigationBarItem createBottomBarItem(
      String titleName, var selectIndex, IconData icon) {
    return BottomNavigationBarItem(
        title: Text(
          titleName,
          style: TextStyle(
              color:
                  _currentIndex != selectIndex ? _defaultColor : _activeColor),
        ),
        icon: Icon(
          icon,
          color: _defaultColor,
        ),
        activeIcon: Icon(
          icon,
          color: _activeColor,
        ));
  }
}
