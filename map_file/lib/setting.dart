import 'package:flutter/material.dart';
import 'dart:math';
import 'package:snu_lecture_map/search.dart';

class SettingScreen extends StatefulWidget {
  double bottomBarHeight;
  double appBarHeight;

  SettingScreen(
      {Key? key, required this.bottomBarHeight, required this.appBarHeight})
      : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool containerVisible = true;
  List<Color> _containerColorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.brown,
    Colors.yellow
  ];
  int colorNum = 0;
  void containerinvert() {
    setState(() {
      // containerVisible = !containerVisible;
      colorNum = Random().nextInt(_containerColorList.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    double _currentScreenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Align(
            alignment: Alignment(0.8, 0.9),
            child: InkWell(
              onTap: () {
                print("update");
                button_Update();
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                ),
                child: Padding(
                  child: Text("update"),
                  padding: EdgeInsets.all(10.0),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.8, 0.7),
            child: InkWell(
              onTap: () {
                print("load");
                button_Load();
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                ),
                child: Padding(
                  child: Text("load"),
                  padding: EdgeInsets.all(10.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
class TempButton extends StatelessWidget {
  Function inFunction;
  TempButton({Key? key, required this.inFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 50,
        width: 100,
        child: Text("This is Button"),
      ),
      onTap: () {
        inFunction();
      },
    );
  }
}

*/