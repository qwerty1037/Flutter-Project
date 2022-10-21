import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:snu_lecture_map/googlemap.dart';
import 'package:snu_lecture_map/search.dart';
import 'package:snu_lecture_map/setting.dart';
import 'package:snu_lecture_map/timetable.dart';
import 'package:flutter/services.dart';

void main() {
  /*runapp에 비동기 작업이 있을 경우 넣어주는 코드*/
  WidgetsFlutterBinding.ensureInitialized();

  /*depreciated 되어있어서 새로 수정함, 네비게이션과 상태바를 숨겨준다*/
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    /*부모 클래스에 있는 initstate 메소드를 호출하기 위한 코드*/
    super.initState();
    _init();
  }

  /*async는 await를 쓸 수 있게 해주는 키워드*/
  void _init() async {
    /*sql_ ~ 함수가 모두 실행되어서 값을 리턴할때까지 기다림*/
    dataclass = await sql_GetDataFromSql();
    preProcessingData();
    print("sql finish");
    // int i=0;
    // print("a ${dataclass[i].idx}: ${dataclass[i].curriculum_division},${dataclass[i].department},${dataclass[i].major},${dataclass[i].comple_course},${dataclass[i].grade},${dataclass[i].class_number},${dataclass[i].lecture_number},${dataclass[i].name},${dataclass[i].credit},${dataclass[i].lecture_credit},${dataclass[i].experiment_credit},${dataclass[i].time},${dataclass[i].n14},${dataclass[i].professor},${dataclass[i].capacity},${dataclass[i].note},${dataclass[i].language}");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SNUMap()));
  }

  @override
  Widget build(BuildContext context) {
    /*기종별로 화면 사이즈가 다를 수 있기 때문에 mediaquery를 이용해서 현재 실행되는 환경에서의 width를 가져옴*/
    var screenWidth = MediaQuery.of(context).size.width;
    return //WillPopScope(
        //onWillPop: () async => false,
        //child: MediaQuery(
        //data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        //child:
        new Scaffold(
          /*앱 켜질때 플러터 로고 띄우는 그 부분*/
            backgroundColor: Color(0xffaeddef),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: screenWidth * 0.3,
                    height: screenWidth * 0.3,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/images/flutterlogo.png'),
                    )),
                  ),
                ),
                SizedBox(
                  height: screenWidth * 0.4,
                ),
                Text(
                  '© SNU APPEYROAD 2022, -----',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                )
              ],
            )
            //),
            //),
            );
  }
}

/*중간에 왜 거치는지 모를 stless widget*/
class SNUMap extends StatelessWidget {
  const SNUMap({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SNUMap',
      theme: ThemeData(
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.black,
                displayColor: Colors.blue,
              )),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Matrix4 transform_matrix = Matrix4.identity();
  /*처음에 실행했을 때 뜨는 창의 index -> 0으로 되어있으면 map이 뜨고 3으로 되어있으면 settings*/
  int _selectedIndex = 0;
  double bottomBarHeight = 60;

  @override
  Widget build(BuildContext context) {
    // double screen_height = MediaQuery.of(context).size.height;
    // double screen_width = MediaQuery.of(context).size.width;
    // double menubar_height = 50;
    // double appbar_height = AppBar().preferredSize.height;

    // return CupertinoTabScaffold(
    //   backgroundColor: Colors.white,
    //   tabBar: CupertinoTabBar(
    //     backgroundColor: Color(0xffaeddef),
    //     items: const <BottomNavigationBarItem>[
    //       BottomNavigationBarItem(
    //           icon: Icon(Icons.map_outlined),
    //           title: Text("map")),
    //       BottomNavigationBarItem(
    //           icon: Icon(Icons.search_outlined),
    //           title: Text("search")),
    //       BottomNavigationBarItem(
    //           icon: Icon(Icons.schedule_outlined),
    //           title: Text("schedule")),
    //       BottomNavigationBarItem(
    //           icon: Icon(Icons.settings_applications_outlined),
    //           title: Text("settings")),
    //     ],
    //     activeColor: Color(0xff7e7c7a),
    //     inactiveColor: Color(0xffa3b6c5),
    //   ),
    //   tabBuilder: (context, index) {
    //     switch (index) {
    //       case 0:
    //         return CupertinoTabView(builder: (context) {
    //           return CupertinoPageScaffold(child: MapScreen());
    //         });
    //         break;
    //       // case 1:
    //       //   return CupertinoTabView(builder: (context) {
    //       //     return CupertinoPageScaffold(child: SearchScreen());
    //       //   });
    //       //   break;
    //       case 2:
    //         return CupertinoTabView(builder: (context) {
    //           return CupertinoPageScaffold(child: TimeTable());
    //         });
    //         break;
    //       case 3:
    //         return CupertinoTabView(builder: (context) {
    //           return CupertinoPageScaffold(child: SettingScreen());
    //         });
    //         break;
    //       default:
    //         return const CupertinoTabView();
    //     }
    //   },
    // );
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('SNU Lecture Map'),
      // ),
      body: Builder(
        builder: (context) {
          double _appBarHeight = Scaffold.of(context).appBarMaxHeight ?? 0;
          List<Widget> _widgetOption = [
            googlemapscreen(),
            SearchScreen(),
            TimeTable(
              bottomBarHeight: bottomBarHeight,
              appBarHeight: _appBarHeight,
            ),
            SettingScreen(),
          ];
          return IndexedStack(
            index: _selectedIndex,
            children: _widgetOption,
          );
        },
      ),

      /*bottom navigationbar widget 자체에서 페이지 전환 기능을 지원한다*/
      bottomNavigationBar: SizedBox(
        height: bottomBarHeight,
        child: BottomNavigationBar(
          backgroundColor: Color(0xffaeddef),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              label: 'map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              label: 'search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule_outlined),
              label: 'schedule',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: 'setting',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
