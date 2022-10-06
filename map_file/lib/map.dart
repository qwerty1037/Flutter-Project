// import 'dart:ffi';
import 'dart:math';

import 'package:snu_lecture_map/search.dart';
import 'package:snu_lecture_map/timetable.dart';
import 'package:snu_lecture_map/buildingdata.dart';
import 'package:snu_lecture_map/setting.dart';
import 'package:snu_lecture_map/menuCrawling.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/animation.dart';
import 'package:provider/provider.dart';

//test1
//for saving current screen number


class CurrentScreenNumber {
  int? currentNum;

  CurrentScreenNumber({this.currentNum});

  void changeCurrentNum(int changeTo) {
    this.currentNum = changeTo;
  }
}

// class _MapState extends State<Home>
// with AutomaticKeepAliveClientMixin {
//   int _count = 0;
// }

class MapScreen extends StatefulWidget {
  double bottomBarHeight;
  double appBarHeight;

  MapScreen({Key? key, required this.bottomBarHeight, required this.appBarHeight}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {

  List<String> _showInfo = [];
  String _buildingNum = "0";
  bool _showMenu = false;
  String _showMark = "0";
  void showingOn(String bn) {
    setState(() {
      _showInfo.clear();
      _showInfo.add(bn);
    });

  }
  void showingOff() {
    setState(() {
      _showInfo.clear();
    });
  }
  void currentBuildingNum(String bn) {
    setState(() {
      this._buildingNum = bn;
    });
  }
  void showingMenu(String bn) {
    setState(() {
      this._showMenu = BUILDINGDATA[bn]![2];
    });
  }
  void showingMark(String bn) {
    setState(() {
      this._showMark = bn;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    // Showing showing = Provider.of<Showing>(context);
    return Scaffold(
      backgroundColor: Color(0xffffffdd),
      appBar: AppBar(
        title: Text("지도", style: TextStyle(color: Colors.black),),
        backgroundColor: Color(0xffaeddef),
        //elevation: 5,
        iconTheme: IconThemeData(),
        actions: [
          IconButton(
            icon: Icon(Icons.restaurant_menu_sharp),
            onPressed: (){
              getMenuInfo();
            },
          )
        ],
      ),
      drawer: Drawer(
        elevation: 10,
        child: ListView(
          children: [
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "요일별 동선",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text("월요일",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text("화요일",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    )
                  ]),
            ),
          ],
        ),
      ),
      body: Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: _height - 105,
            width: _width,
            child: Stack(children: [
              PhotoView.customChild(
                child: Stack(children: [
                  MapContainer(
                    imagePath: "assets/images/snumap.jpg",
                  ),
                  Buildings(showInfo: _showInfo, buildingNum: _buildingNum,
                  showMenu: _showMenu, showMark: _showMark, sOn: showingOn,
                  sOff: showingOff, cBN: currentBuildingNum, sMenu: showingMenu,
                  sMark: showingMark,),
                ]),
                backgroundDecoration: BoxDecoration(color: Colors.white10),
                minScale: PhotoViewComputedScale.contained * 1,
                maxScale: PhotoViewComputedScale.covered * 3.5,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedSize(
                  vsync: this,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  child: Container(
                      height: _showInfo.isNotEmpty ? 150 : 0,
                      child: Stack(
                          children: [
                            Infobox(buildingnum: _buildingNum, showingmenu: _showMenu,),
                            Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                  icon: Icon(Icons.arrow_back),
                                  padding: EdgeInsets.all(17),
                                  onPressed: () {
                                    setState(() {
                                      showingOff();
                                    });
                                    print(_showInfo);
                                  }),
                            ),
                          ]),
                  ),
                ),
              ),
            ]),
          ),
      ),
    );
  }
}

//modify this class
class MapContainer extends StatelessWidget {
  final Widget? child;
  final String imagePath;

  MapContainer({this.child, required this.imagePath, Key? key})
      : super(key: key);

  //const MapBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screen_height = MediaQuery.of(context).size.height - 50;
    double screen_width = MediaQuery.of(context).size.width;
    //number of pixel of snu map image
    double image_height = 3508;
    double image_width = 2481;

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(imagePath),
        fit: (image_height / screen_height < image_width / screen_width)
            ? BoxFit.fitWidth
            : BoxFit.fitHeight,
      )),
      child: Center(
        child: Container(
          height: (image_height / screen_height < image_width / screen_width)
              ? screen_width * image_height / image_width
              : screen_height,
          width: (image_height / screen_height < image_width / screen_width)
              ? screen_width
              : screen_height * image_width / image_height,
          //color: Colors.black54,
          child: child,
        ),
      ),
    );
  }
}

class Buildings extends StatefulWidget {
  List<String> showInfo;
  String buildingNum;
  bool showMenu;
  String showMark;
  Function sOn;
  Function sOff;
  Function cBN;
  Function sMenu;
  Function sMark;
  Buildings({Key? key, required this.showInfo, required this.buildingNum,
  required this.showMenu, required this.showMark, required this.sOn,
  required this.sOff, required this.cBN, required this.sMenu, required this.sMark}) : super(key: key);

  @override
  _BuildingsState createState() => _BuildingsState();
}

class _BuildingsState extends State<Buildings> {
  /*List<String> showInfo = super.showInfo;
  String buildingNum;
  bool showMenu;
  String showMark;*/
  @override
  Widget build(BuildContext context) {
    double screen_height = MediaQuery.of(context).size.height - 50;
    double screen_width = MediaQuery.of(context).size.width;
    //number of pixel of snu map image
    double image_height = 3508;
    double image_width = 2481;
    var bn = BUILDINGDATA.keys;
    return Center(
      child: Container(
        height: (image_height / screen_height < image_width / screen_width)
            ? screen_width * image_height / image_width
            : screen_height,
        width: (image_height / screen_height < image_width / screen_width)
            ? screen_width
            : screen_height * image_width / image_height,
        child: Stack(children: [
          for (String j in bn)
            Visibility(
              visible: widget.showMark == j,
              child: Align(
                alignment: Alignment(BUILDINGDATA[j]![0]-0.005, BUILDINGDATA[j]![1]),
                child: Icon(
                  Icons.add_location,
                  color: Colors.red, size: 6,
                ),
              ),
            ),
          for (String i in bn)
          GestureDetector(
            onTap: () {
              setState(() {
                if (!widget.showInfo.remove(i)) {
                  widget.sOn(i);
                  widget.sMenu(i);
                } else {
                  widget.sOff();
                }
                widget.cBN(i);
                widget.sMark(i);
              });
              print(widget.showInfo);
              print(widget.buildingNum);
              print(BUILDINGDATA[i]![0]);
              print(BUILDINGDATA[i]![1]);
              print(widget.showMenu);
            },
            child: Align(
                alignment: Alignment(BUILDINGDATA[i]![0], BUILDINGDATA[i]![1]),
                child: Container(
                  width: 10,
                  height: 10,
                  color: Color.fromRGBO(80, 176, 209, 100),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}

/*
class Showing with ChangeNotifier {
  List<String> _showInfo = [];
  String _buildingNum = "0";
  bool _showMenu = false;
  String _showMark = "0";

  get showInfo => _showInfo;

  showingOn(String bn) {
    _showInfo.clear();
    _showInfo.add(bn);
    notifyListeners();
  }

  showingOff() {
    _showInfo.clear();
    notifyListeners();
  }

  currentBuildingNum(String bn) {
    this._buildingNum = bn;
    notifyListeners();
  }

  showingMenu(String bn) {
    this._showMenu = BUILDINGDATA[bn]![2];
    notifyListeners();
  }

  showingMark(String bn) {
    this._showMark = bn;
    notifyListeners();
  }
}
*/

class Infobox extends StatefulWidget {
  final String buildingnum;
  final bool showingmenu;
  const Infobox({Key? key, required this.buildingnum, required this.showingmenu,}) : super(key: key);

  @override
  _InfoboxState createState() => _InfoboxState();
}

class _InfoboxState extends State<Infobox> {
  bool _showResMenu = false;

  @override
  Widget build(BuildContext context) {
    //Showing showing = Provider.of<Showing>(context);
    return Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xffc5dad1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Stack(
                  children: [
                    Align(
                         alignment: Alignment.topCenter,
                         child: BuildingInfo(buildingnumber: widget.buildingnum,)
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            // showing._showLectures = !showing._showLectures;
                            // Navigator.push(context,
                            // MaterialPageRoute(builder: (context) => SearchLecture()));
                            // showSearch(context: context, delegate: DataSearch(), query: widget.buildingnum);
                          });
                        },
                        child: Text("강의 보기"),
                      ),
                    ),
                    Visibility(
                      visible: widget.showingmenu,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(child: Container()),
                                IconButton(
                                  icon: Icon(Icons.restaurant_rounded),
                                  onPressed: () {
                                    setState(() {
                                      _showResMenu = !_showResMenu;
                                    });
                                  },
                                ),
                              ],
                            ),
                            Visibility(
                              visible: _showResMenu,
                              child: ResMenuBox(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
    );
  }
}

class BuildingInfo extends StatefulWidget {

  BuildingInfo({required this.buildingnumber, Key? key}) : super(key: key);
  String buildingnumber;
  @override

  _BuildingInfoState createState() => _BuildingInfoState();
}

class _BuildingInfoState extends State<BuildingInfo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.buildingnumber + "동 - ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
            BUILDINGDATA[widget.buildingnumber]?[3] ?? '---',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
      // Text(BUILDINGDATA[widget.buildingnumber]![4] + " - " + BUILDINGDATA[widget.buildingnumber]![5],
      //     style: TextStyle(fontSize: 15),),
      //],
    );
  }
}

class ResMenuBox extends StatefulWidget {
  const ResMenuBox({Key? key}) : super(key: key);

  @override
  _ResMenuBoxState createState() => _ResMenuBoxState();
}

class _ResMenuBoxState extends State<ResMenuBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(const Radius.circular(5)),
      ),
    );
  }
}

class ShowLectures extends StatefulWidget {
  const ShowLectures({Key? key}) : super(key: key);

  @override
  _ShowLecturesState createState() => _ShowLecturesState();
}

class _ShowLecturesState extends State<ShowLectures> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 20, 20, 50),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: const BorderRadius.all(const Radius.circular(5)),
      ),
      child: Stack(
        children: [],
      ),
    );
  }
}


