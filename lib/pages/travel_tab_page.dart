import 'package:flutter/material.dart';
import 'package:flutter_trip/dao/travel_dao.dart';
import 'package:flutter_trip/model/travel_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_trip/widget/loading_container.dart';
import 'package:flutter_trip/widget/web_view.dart';

const TRAVEL_URL =
    'https://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031014111431397988&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5';
const PAGE_SIZE = 10;

///flutter_staggered_grid_view 插件升级到0.3.0才能滚动和左右滑动
class TravelTabPage extends StatefulWidget {
  final String travelUrl;
  final Map params;
  final String groupChannelCode;
  final int type;

  const TravelTabPage(
      {Key key, this.travelUrl, this.params, this.groupChannelCode, this.type})
      : super(key: key);

  @override
  _TravelTabPageState createState() => _TravelTabPageState();
}

class _TravelTabPageState extends State<TravelTabPage> {
  List<TravelItem> travelItems;
  int pageIndex = 1;
  bool _loading = true;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _loadData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadData(loadMore: true);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingContainer(
        isLoading: _loading,
        child: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: StaggeredGridView.countBuilder(
                    controller: _scrollController,
                    itemCount: travelItems?.length ?? 0,
                    crossAxisCount: 2,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildTravelItem(travelItems[index]);
                    },
                    staggeredTileBuilder: (int index) {
                      return StaggeredTile.fit(1);
                    }))),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  ///下拉刷新
  Future<Null> _handleRefresh() async {
    _loadData();
    return null;
  }

  ///loadMore：是否是上拉加载更多
  void _loadData({loadMore = false}) async {
    if (loadMore) {
      //是上拉加载更多，页数+1
      pageIndex++;
    } else {
      //下拉刷新，页数=1
      pageIndex = 1;
    }
    try {
      TravelModel model = await TravelDao.fetch(
          widget.travelUrl ?? TRAVEL_URL,
          widget.params,
          widget.groupChannelCode,
          widget.type,
          pageIndex,
          PAGE_SIZE);
      setState(() {
        List<TravelItem> items = _filterItems(model.resultList);
        if (travelItems != null) {
          travelItems.addAll(items);
        } else {
          travelItems = items;
        }
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }
  }

  ///数据过滤
  List<TravelItem> _filterItems(List<TravelItem> resultList) {
    if (resultList == null) return [];
    List<TravelItem> filterItems = [];
    resultList.forEach((item) {
      if (item.article != null) {
        filterItems.add(item);
      }
    });
    return filterItems;
  }

  Widget _buildTravelItem(TravelItem item) {
    return InkWell(
      onTap: () {
        if (item.article.urls != null && item.article.urls.length > 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WebView(
                        url: item.article.urls[0].h5Url,
                        title: "详情",
                      )));
        }
      },
      child: Card(
        child: PhysicalModel(
            color: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(5),
            child: Column(
              children: <Widget>[
                _buildImgHeader(item),
                _buildTitle(item),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildAvaRow(item),
                    _buildLikeRow(item),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  ///头部布局=图片+位置
  Widget _buildImgHeader(TravelItem item) {
    return Stack(
      children: <Widget>[
        Image.network(item.article.images[0]?.dynamicUrl),
        Positioned(
          left: 8,
          bottom: 8,
          child: Container(
            padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.black54),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 3),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
                Text(
                  _poiName(item),
                  style: TextStyle(fontSize: 12, color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  ///标题
  Widget _buildTitle(TravelItem item) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Text(
        item.article.articleTitle,
        style: TextStyle(fontSize: 13),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }

  Widget _buildAvaRow(TravelItem item) {
    return Container(
      margin: EdgeInsets.only(left: 5, bottom: 5),
      child: Row(
        children: <Widget>[
          PhysicalModel(
            color: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.article.author?.coverImage?.dynamicUrl,
              width: 25,
              height: 25,
            ),
          ),
          Container(
            width: 60,
            child: Text(
              item.article.author?.nickName,
              style: TextStyle(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLikeRow(TravelItem item) {
    return Container(
      margin: EdgeInsets.only(right: 5, bottom: 5),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.thumb_up,
            color: Colors.grey,
            size: 10,
          ),
          Text(
            item.article.likeCount.toString(),
            style: TextStyle(fontSize: 10),
          )
        ],
      ),
    );
  }

  String _poiName(TravelItem item) {
    return item.article.pois == null || item.article.pois.length == 0
        ? '未知'
        : item.article.pois[0]?.poiName ?? '未知';
  }
}
