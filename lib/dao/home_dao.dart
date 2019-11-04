import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_trip/model/home_model.dart';

const HOME_URL = "http://www.devio.org/io/flutter_app/json/home_page.json";

///首页大接口
class HomeDao {
  static Future<HomeModel> fetch() async {
//    final response = await http.get(HOME_URL);
//    if (response.statusCode == 200) {
//      Utf8Decoder utf8decoder = Utf8Decoder();
//      var result = json.decode(utf8decoder.convert(response.bodyBytes));
//      return HomeModel.fromJson(result);
//    } else {
//      throw Exception("Fail to load home_page.json");
//    }

    Dio dio = new Dio();
    final response = await dio.get(HOME_URL,
        options: Options(responseType: ResponseType.plain));
    print("首页大接口：" + response.data.toString());
    if (response.statusCode == 200) {
      var result = json.decode(response.data.toString());
      return HomeModel.fromJson(result);
    } else {
      throw Exception("Fail to load home_page.json");
    }
  }
}
