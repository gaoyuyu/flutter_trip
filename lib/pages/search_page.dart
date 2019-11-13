import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _hasSearchValue = false;
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _searchBar(),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      height: 80,
      padding: EdgeInsets.only(top: 35, bottom: 9),
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        children: <Widget>[
          _searchArea(),
          Container(
            child: Text("搜索"),
            margin: EdgeInsets.only(left: 8, right: 8),
          ),
        ],
      ),
    );
  }

  Widget _searchArea() {
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.only(left: 8),
        padding: EdgeInsets.only(left: 5, top: 8, bottom: 8, right: 5),
        decoration: BoxDecoration(
            color: Color(0xffececec), borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: <Widget>[
            Icon(Icons.search),
            Expanded(
              flex: 1,
              child: _buildTextField(),
            ),
            _buildRightIcon()
          ],
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _controller,
      onChanged: _onChanged,
      style: TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.w300),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          border: InputBorder.none,
          hintText: "输入搜索内容",
          hintStyle: TextStyle(fontSize: 15)),
    );
  }

  ///右边的Icon
  Widget _buildRightIcon() {
    return _hasSearchValue?
    InkWell(child: Icon(Icons.close),onTap: (){
      setState(() {
        _controller.clear();
      });
      _onChanged('');
    },)
    :InkWell(child: Icon(Icons.keyboard_voice,color: Colors.blue,),onTap: (){
    });
  }

  //输入框内容改变
  void _onChanged(String text) {
    if (text.length > 0) {
      setState(() {
        _hasSearchValue = true;
      });
    } else {
      setState(() {
        _hasSearchValue = false;
      });
    }
  }
}
