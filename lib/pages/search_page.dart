import 'package:flutter/material.dart';
import 'package:flutter_trip/dao/search_dao.dart';
import 'package:flutter_trip/model/search_model.dart';
import 'package:flutter_trip/widget/web_view.dart';

const TextStyle normalStyle = TextStyle(fontSize: 16, color: Colors.black87);
const TextStyle keywordStyle = TextStyle(fontSize: 16, color: Colors.orange);
const TextStyle greyStyle = TextStyle(fontSize: 12, color: Colors.grey);

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _hasSearchValue = false;
  TextEditingController _controller = TextEditingController();
  String _keyword = "";
  SearchModel _searchModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[_searchBar(), _buildListView(_searchModel)],
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
          InkWell(
            onTap: () {
              _doSearch();
            },
            child: Container(
              child: Text(
                "搜索",
                style: TextStyle(color: Colors.blue),
              ),
              margin: EdgeInsets.only(left: 8, right: 8),
            ),
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
          fontSize: 18, color: Colors.black, fontWeight: FontWeight.w300),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          border: InputBorder.none,
          hintText: "输入搜索内容",
          hintStyle: TextStyle(fontSize: 15)),
    );
  }

  ///右边的Icon
  Widget _buildRightIcon() {
    return _hasSearchValue
        ? InkWell(
            child: Icon(Icons.close),
            onTap: () {
              setState(() {
                _controller.clear();
                _searchModel = null;
              });
              _onChanged('');
            },
          )
        : InkWell(
            child: Icon(
              Icons.keyboard_voice,
              color: Colors.blue,
            ),
            onTap: () {});
  }

  //输入框内容改变
  void _onChanged(String text) {
    _keyword = text;
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

  ///根据关键字来搜索
  void _doSearch() {
    SearchDao.fetch(_keyword).then((SearchModel value) {
      setState(() {
        _searchModel = value;
      });
    });
  }

  ///创建ListView
  Widget _buildListView(SearchModel searchModel) {
    int count = searchModel == null ? 0 : searchModel.data.length;
    //这里需要用Expanded包一层，否则高度撑不开
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: Expanded(
        flex: 1,
        child: ListView.builder(
            itemCount: count,
            itemBuilder: (BuildContext context, int index) {
              return _buildItem(searchModel, index);
            }),
      ),
    );
  }

  ///创建ListView的Item
  Widget _buildItem(SearchModel searchModel, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebView(
                      url: searchModel.data[index].url,
                      statusBarColor: null,
                      hideAppBar: false,
                      title: "",
                    )));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(color: Colors.black26, width: 1))),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.home,
              color: Colors.blue,
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                        text: TextSpan(
                            children: _buildTitle(searchModel.data[index]))),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: RichText(
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: searchModel.data[index].price ?? "",
                              style: keywordStyle),
                          TextSpan(
                              text: searchModel.data[index].type ?? "",
                              style: greyStyle),
                        ]),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ///第一行的文本
  List<TextSpan> _buildTitle(SearchItem item) {
    List<TextSpan> data = _buildRichText(item);
    data.add(_buildGreyText([item.districtname ?? "", item.zonename ?? ""]));
    return data;
  }

  ///标题的高亮文本
  List<TextSpan> _buildRichText(SearchItem searchItem) {
    String title = searchItem.word;
    List<TextSpan> spans = [];

    List<String> titleArr = title.split("");
    List<String> keyArr = _keyword.split("");
    for (int i = 0; i < titleArr.length; i++) {
      if (keyArr.contains(titleArr[i])) {
        spans.add(TextSpan(text: titleArr[i], style: keywordStyle));
      } else {
        spans.add(TextSpan(text: titleArr[i], style: normalStyle));
      }
    }
    return spans;
  }

  ///灰色文字TextSpan
  ///districtname+zonename
  ///type
  ///传递一个数组
  TextSpan _buildGreyText(List<String> strList) {
    String text = "";
    strList.forEach((value) {
      text += (value + " ");
    });
    return TextSpan(
      text: text,
      style: greyStyle,
    );
  }
}
