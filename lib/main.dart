import 'package:flutter/material.dart';
import 'package:flutter_trip/navigator/tab_navigator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TabNavigator(),
    );
  }
}


//void main() {
//  List<String> strList = ["asdasdasdasdasd","啊是大三大四的"];
//   String text = "";
//   strList.forEach((value){
//     text +=value;
//
//   });
//   print(text);
//}

