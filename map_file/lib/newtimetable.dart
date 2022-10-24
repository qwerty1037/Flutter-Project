import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

import 'package:snu_lecture_map/dataclass.dart';
import 'package:snu_lecture_map/search.dart';

List week = ['월', '화', '수', '목', '금'];
var kColumnLength = 22;
double kFirstColumnHeight = 20;
double kBoxSize = 52;

Expanded buildTimeColumn() {
  return Expanded(
    child: Column(
      children: [
        SizedBox(
          height: kFirstColumnHeight,
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
            return SizedBox(
              height: kBoxSize,
              child: Center(child: Text('${index ~/ 2 + 9}')),
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
              SizedBox(
                height: 20,
                child: Text(
                  '${week[index]}',
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
                  return SizedBox(
                    height: kBoxSize,
                    child: Container(),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '시간표',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 1,
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
            icon: Icon(Icons.settings),
            color: Colors.black,
            onPressed: () {
              // _onButtonPressed();
            },
          ),
        ],
      ),
      drawer: MyDrawer,
      body: Container(
          height: kColumnLength / 2 * kBoxSize + kColumnLength,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              buildTimeColumn(),
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