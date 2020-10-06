import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zerogarbage/Models/Common/Common.dart';
import 'package:zerogarbage/Views/Login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zero Garbage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Size displaySize = MediaQuery.of(context).size;

    ModelCommon.displayWidth = displaySize.width;
    ModelCommon.displayHeight = displaySize.height;

    Timer(
        Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => Login())));

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: displaySize.width * 0.22,
                width: displaySize.width * 0.22,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Zero Garbage",
              style: TextStyle(color: Colors.white, fontSize: 15.0),
            )
          ],
        ),
      ),
    );
  }
}
