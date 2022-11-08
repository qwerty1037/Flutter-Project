import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

import 'package:snu_lecture_map/dataclass.dart';
import 'package:snu_lecture_map/search.dart';

List week = ['월', '화', '수', '목', '금'];
var kColumnLength = 20;

buildTimeColumn(double width, double height) {
  return Expanded(
    flex: 1,
    child: Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
          ),
        ),
        ...List.generate(
          kColumnLength,
              (index) {
            if (index % 2 == 0) {
              return const Divider(
                color: Colors.grey,
                height: 0,
              );
            }
            return Expanded(
              flex: 5,
              child: Container(
                child: Center(child: Text('${index ~/ 2 + 9}')),
              ),
            );
          },
        ),
      ],
    ),
  );
}

List<Widget> buildDayColumn(int index) {
  return [
    const VerticalDivider(
      color: Colors.grey,
      width: 0,
    ),
    Expanded(
      flex: 4,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: Text(
                    '${week[index]}',
                  ),
                ),
              ),
              ...List.generate(
                kColumnLength,
                    (index) {
                  if (index % 2 == 0) {
                    return const Divider(
                      color: Colors.grey,
                      height: 0,
                    );
                  }
                  return Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Expanded(flex: 1, child: Container()),
                    Divider(
                      color: Colors.grey,
                      height: 0,
                    ),
                        Expanded(flex: 1, child: Container()),
                      ],
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    ),
  ];
}

class TimeTableNew extends StatefulWidget {
  const TimeTableNew({Key? key}) : super(key: key);

  @override
  State<TimeTableNew> createState() => _TimeTableNewState();
}

class _TimeTableNewState extends State<TimeTableNew> {
  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double appbarHeight = screenHeight * 0.07;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appbarHeight),
        child: AppBar(
          title: Text(
            '시간표',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              color: Colors.black,
              onPressed: () {
              },
            ),
            IconButton(
                icon: Icon(Icons.add_box_outlined),
                color: Colors.black,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) 
                  => addlectureScreen()));
                }
            ),
            IconButton(
              icon: Icon(Icons.settings),
              color: Colors.black,
              onPressed: () {
                // _onButtonPressed();
              },
            ),
          ],
        ),
      ),
      drawer: MyDrawer,
      body: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              buildTimeColumn(screenWidth, screenHeight),
              ...buildDayColumn(0),
              ...buildDayColumn(1),
              ...buildDayColumn(2),
              ...buildDayColumn(3),
              ...buildDayColumn(4),
            ],
          )
      ),
    );
  }
}

Drawer MyDrawer = new Drawer(
  child: ListView(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      children: [
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.add),
                color: Colors.black,
                onPressed: () {},
              ),]
        ),]
  ),
);

class addlectureScreen extends StatefulWidget {
  const addlectureScreen({Key? key}) : super(key: key);

  @override
  State<addlectureScreen> createState() => _addlectureScreenState();
}

class _addlectureScreenState extends State<addlectureScreen> {
  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double appbarHeight = screenHeight * 0.07;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appbarHeight),
        child: AppBar(
          title: Text("Add Lecture", style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      body: Center(
    ));
  }
}
