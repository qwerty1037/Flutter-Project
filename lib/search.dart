import 'dart:core';
import 'dart:ffi';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:snu_lecture_map/dataclass.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:korea_regexp/get_regexp.dart';
import 'package:korea_regexp/models/regexp_options.dart';
import 'package:fluttertoast/fluttertoast.dart';

List<Dataclass> dataclass = [];
List<String> lectureNameList = [];

class SearchScreen extends StatefulWidget {
  double bottomBarHeight;
  double appBarHeight;

  SearchScreen(
      {Key? key, required this.bottomBarHeight, required this.appBarHeight})
      : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _filter = new TextEditingController();

  String _searchText = ""; // 검색창에 user가 타이핑한 문자열

  List totalList = []; // 전체 리스트

  List filteredList = []; // searchtext에 의해 필터링된 리스트

  Icon _searchIcon = Icon(Icons.search); // 검색 아이콘

  Widget _appBarTitle = Text('Search Example'); // Search Example의 단축어?

  //리스트를 변수로 가져오는 함수
  void getLectureName() async {
    setState(() {
      totalList = lectureNameList;
      filteredList = lectureNameList;
    });
  }

  _SearchScreenState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredList = totalList;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    getLectureName();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _appBarTitle,
        leading: IconButton(
          icon: _searchIcon,
          onPressed: () {
            if (whenSearchBarActivated()) {
              activateSearchBar();
            } else {
              deactivateSearchBar();
            }
          },
        ),
      ),
      body: Container(
        child: _buildList(),
      ),
    );
  }
  
  bool whenSearchBarActivated() {
    if (_searchIcon.icon == Icons.search) {
      return true;
    } else {
      return false;
    }
  }

  void activateSearchBar() {
    _searchIcon = Icon(Icons.close);
    _appBarTitle = TextField(
      controller: _filter,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.search), hintText: 'Search...'),
    );
  }

  void deactivateSearchBar() {
    _searchIcon = Icon(Icons.search);
    _appBarTitle = Text('Search Example');
    filteredList = totalList;
    _filter.clear();
  }

  Widget _buildList() {
    if (_searchText.isNotEmpty) {
      filteredList = filterTotalListBySearchText();
    }
    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(filteredList[index]),
          // ignore: avoid_print
          onTap: () => print(filteredList[index]),
        );
      },
    );
  }

  List filterTotalListBySearchText() {
    List tempList = [];
    RegExp regExp = getRegExp(
      _searchText,
      RegExpOptions(
        initialSearch: true,
        startsWith: false,
        endsWith: false,
        fuzzy: true,
        ignoreSpace: true,
        ignoreCase: true,
      ),
    );
    for (int i = 0; i < totalList.length; i++) {
      if (regExp.hasMatch(totalList[i])) {
        //입력한 문자와 일치하는 검색 결과 필터
        tempList.add(totalList[i]);
      }
    }
    return tempList;
  }
}

void button_Update() async {
  dataclass.clear();
  await update();
  print("update complete");
  showToast("Update Complete");
  preProcessingData();
  print("preprocessing complete");
  sql_DeleteSql();
  print("delete complete");
  showToast("Delete complete");
  sql_InsertAllData();
  print("insert complete");
  showToast("Insert complete");
}

void button_Load() async {
  dataclass.clear();
  dataclass = await sql_GetDataFromSql();
  preProcessingData();
  showToast("${dataclass.length} components load complete");
}

update() async {
  var raw = await http.get(Uri.parse(
      "https://script.google.com/macros/s/AKfycbxuF-i3S7TGsgYTSAma5Nc0PryGK5LqakWP9xMOzw/exec"));

  var jsonData = convert.jsonDecode(raw.body);

  jsonData.forEach((element) {
    Dataclass data = Dataclass();
    data.curriculum_division = element['교과구분'];
    data.department = element['개설대학'];
    data.major = element['개설학과'];
    data.comple_course = element['이수과정'];
    data.grade = element['학년'];
    data.class_number = element['교과목번호'];
    data.lecture_number = element['강좌번호'];
    data.name = element['교과목명'];
    data.credit = element['학점'];
    data.lecture_credit = element['강의'];
    data.experiment_credit = element['실습'];
    data.time = element['수업교시'];
    data.type = element['수업형태'];
    data.n14 = element['강의실'];
    data.professor = element['담당교수'];
    data.capacity = element['정원'];
    data.note = element['비고'];
    data.language = element['강의언어'];

    dataclass.add(data);
  });

  jsonData.clear();

  // preProcessingData();
  // saveData();
}

void preProcessingData() {
  for (int i = 0; i < dataclass.length; i++) {
    dataclass[i].idx = i;
  }
  for (int i = 0; i < dataclass.length; i++) {
    //수업 교시 전처리
    int NumOfSlash_time = 0;
    List<LectureTime> lecturetime = [];

    if (dataclass[i].time != '^^^') {
      for (int j = 0; j < dataclass[i].time!.length; j++) {
        if (dataclass[i].time![j] == '/') {
          NumOfSlash_time++;
        }
      }

      for (int j = 0; j < NumOfSlash_time + 1; j++) {
        LectureTime newlecturetime = LectureTime();
        newlecturetime.day = 999;
        newlecturetime.StartTime = 999;
        newlecturetime.EndTime = 999;

        //day 지정
        switch (dataclass[i].time![15 * j]) {
          case '월':
            newlecturetime.day = 1;
            break;
          case '화':
            newlecturetime.day = 2;
            break;
          case '수':
            newlecturetime.day = 3;
            break;
          case '목':
            newlecturetime.day = 4;
            break;
          case '금':
            newlecturetime.day = 5;
            break;
          case '토':
            newlecturetime.day = 6;
            break;
          case '일':
            newlecturetime.day = 0;
            break;
        }
        //StartTime 지정
        double temp = double.tryParse(
            dataclass[i].time!.substring(2 + 15 * j, 4 + 15 * j))!;
        double temp_end = double.tryParse(
                dataclass[i].time!.substring(5 + 15 * j, 7 + 15 * j))! /
            60;
        if (temp_end >= 0.15 && temp_end <= 0.5) {
          temp_end = 0.5;
        }
        if (temp_end >= 0.65 && temp_end <= 0.99) {
          temp_end = 1;
        }
        temp += temp_end;

        double new_temp = 0;
        new_temp = 2 * temp - 17;

        newlecturetime.StartTime = new_temp;
        //EndTime 지정
        temp = 0;
        temp_end = 0;
        temp = double.tryParse(
            dataclass[i].time!.substring(8 + 15 * j, 10 + 15 * j))!;
        temp_end = double.tryParse(
                dataclass[i].time!.substring(11 + 15 * j, 13 + 15 * j))! /
            60;
        if (temp_end >= 0.15 && temp_end <= 0.5) {
          temp_end = 0.5;
        }
        if (temp_end >= 0.65 && temp_end <= 0.99) {
          temp_end = 1;
        }
        temp += temp_end;

        new_temp = 0;
        new_temp = 2 * temp - 17;

        newlecturetime.EndTime = new_temp;

        lecturetime.add(newlecturetime);
      }
    } else {
      LectureTime newlecturetime = LectureTime();
      newlecturetime.day = 999;
      newlecturetime.StartTime = 999;
      newlecturetime.EndTime = 999;
      lecturetime.add(newlecturetime);
    }
    lectureNameList.clear();
    for (int i = 0; i < dataclass.length; i++) {
      lectureNameList.add(dataclass[i].name!);
    }
    dataclass[i].lecture_time = lecturetime;
    lecturetime.clear();
    //print('${dataclass[i].lecture_time![0].StartTime!}');
  }

  //강의동 전처리
/*
  for (int i = 0; i < dataclass.length; i++) {
    int NumOfSlash_time = 0;
    List<int> SlashIndex = List.generate(10, (index) => 0);
    List<String> SlicedString = List.generate(10, (index) => "0");
    if (dataclass[i].n14![0] == '/' || dataclass[i].n14![0] == '*') {
      dataclass[i].n14 = dataclass[i].n14!.substring(1);
    }
    if (dataclass[i].n14![dataclass[i].n14!.length - 1] == '/') {
      dataclass[i].n14 =
          dataclass[i].n14!.substring(0, dataclass[i].n14!.length - 1);
    }
    for (int j = 0; j < dataclass[i].n14!.length; j++) {
      if (dataclass[i].n14![j] == '/') {
        NumOfSlash_time++;
        SlashIndex[NumOfSlash_time] = j;
      }
    }
    if (NumOfSlash_time > 0) {
      for (int k = 0; k <= NumOfSlash_time; k++) {
        if (k == 0) {
          SlicedString[k] = dataclass[i].n14!.substring(0, SlashIndex[k + 1]);
        } else if (k == NumOfSlash_time) {
          SlicedString[k] = dataclass[i].n14!.substring(SlashIndex[k] + 1);
        } else {
          SlicedString[k] =
              dataclass[i].n14!.substring(SlashIndex[k] + 1, SlashIndex[k + 1]);
        }
        //print("${SlicedString[k]}");
      }
      var temp = '0';
      bool coincidence = true;

      int idx = SlicedString[0].indexOf("-");
      temp = SlicedString[0].substring(0, idx);

      for (int l = 1; l <= NumOfSlash_time; l++) {
        int idx_new = SlicedString[l].indexOf("-");
        var temp_new = SlicedString[l].substring(0, idx_new);
        //print("${temp_new}");
        if (temp_new != temp) {
          coincidence = false;
        }
        temp = temp_new;
        idx = idx_new;
        //print("${coincidence}");
      }
    }

    if (NumOfSlash_time == 0) {
      int NumOfHyphen = 0;
      List<int> HyphenIndex = List.generate(10, (index) => 0);
      for (int j = 0; j < dataclass[i].n14!.length; j++) {
        if (dataclass[i].n14![j] == '-') {
          NumOfHyphen++;
          HyphenIndex[NumOfHyphen] = j;
        }
      }
      if (NumOfHyphen == 1) {
        var temp_building = dataclass[i].n14!.substring(0, HyphenIndex[1]);
        var temp_room = dataclass[i].n14!.substring(HyphenIndex[1] + 1);
        LectureBR temp_lecturebr = LectureBR();
        temp_lecturebr.Building = temp_building;
        temp_lecturebr.Room = temp_room;
        dataclass[i].lecture_buildingroom = [];
        dataclass[i].lecture_buildingroom!.add(temp_lecturebr);
        //print("${dataclass[i].lecture_buildingroom![0].Building}");
      }
      HyphenIndex.clear();
      /*
      if (NumOfHyphen == 0) {
        var temp_building = dataclass[i].n14!.substring(0, HyphenIndex[1]);
        var temp_room = dataclass[i].n14!.substring(HyphenIndex[1] + 1);
        LectureBR temp_lecturebr = new LectureBR();
        temp_lecturebr.Building = temp_building;
        temp_lecturebr.Room = temp_room;
        dataclass[i].lecture_buildingroom=[];
        dataclass[i].lecture_buildingroom!.add(temp_lecturebr);
        //print("${dataclass[i].lecture_buildingroom![0].Building}");
      }
      */
    }


    SlicedString.clear();
    SlashIndex.clear();


  }
*/
  //수업 교시 전처리
}

List<int> searchingName(String info) {
  List<int> coincidence = [];
  for (int i = 0; i < dataclass.length; i++) {
    var haystack_size = dataclass[i].name!.length;
    var needle_size = info.length;
    for (int j = 0; j < haystack_size - needle_size; ++j) {
      int k = 0;
      for (k = 0; k < needle_size; ++k) {
        if (dataclass[i].name![j + k] == info[k]) {
          continue;
        }
        break;
      }
      if (k == needle_size) {
        coincidence.add(i);
      }
    }
  }
  return coincidence;
}

List<int> searchingBuilding(String info) {
  List<int> coincidence = [];
  for (int i = 0; i < dataclass.length; i++) {
    for (int j = 0; j < dataclass[i].lecture_buildingroom!.length; j++) {
      var haystack_size =
          dataclass[i].lecture_buildingroom![j].Building!.length;
      var needle_size = info.length;
      for (int l = 0; l < haystack_size - needle_size; ++l) {
        int k = 0;
        for (k = 0; k < needle_size; ++k) {
          if (dataclass[i].lecture_buildingroom![j].Building![l + k] ==
              info[k]) {
            continue;
          }
          break;
        }
        if (k == needle_size) {
          coincidence.add(i);
        }
      }
    }
  }
  return coincidence;
}

void sql_OpenGenerate() async {
  //dataclass 적용용 test
  //Generate or Open Database
  Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'dataclass2.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE dataclass(idx INTEGER PRIMARY KEY, curriculum_division TEXT, department TEXT, major TEXT, comple_course TEXT, grade TEXT, class_number TEXT, lecture_number TEXT, name TEXT, credit TEXT, lecture_credit TEXT, experiment_credit TEXT, time TEXT, type TEXT, n14 TEXT, professor TEXT, capacity TEXT, note TEXT, language TEXT)",
      );
    },
    version: 1,
  );
  print("done");
}

void sql_InsertAllData() async {
  Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'dataclass2.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE dataclass(idx INTEGER PRIMARY KEY, curriculum_division TEXT, department TEXT, major TEXT, comple_course TEXT, grade TEXT, class_number TEXT, lecture_number TEXT, name TEXT, credit TEXT, lecture_credit TEXT, experiment_credit TEXT, time TEXT, type TEXT, n14 TEXT, professor TEXT, capacity TEXT, note TEXT, language TEXT)",
      );
    },
    version: 1,
  );
  Database db = await database;

  //Function : insert Dataclass into DB
  Future<void> insertDataclass(Dataclass dataclass) async {
    await db.insert(
      'dataclass',
      dataclass.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  for (int i = 0; i < dataclass.length; i++) {
    await insertDataclass(dataclass[i]);
  }
  db.close();
}

Future<List<Dataclass>> sql_GetDataFromSql() async {
  Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'dataclass2.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE dataclass(idx INTEGER PRIMARY KEY, curriculum_division TEXT, department TEXT, major TEXT, comple_course TEXT, grade TEXT, class_number TEXT, lecture_number TEXT, name TEXT, credit TEXT, lecture_credit TEXT, experiment_credit TEXT, time TEXT, type TEXT, n14 TEXT, professor TEXT, capacity TEXT, note TEXT, language TEXT)",
      );
    },
    version: 1,
  );
  Database db = await database;

  final List<Map<String, dynamic>> maps = await db.query('dataclass');

  return List.generate(maps.length, (i) {
    return Dataclass(
      idx: maps[i]['idx'],
      curriculum_division: maps[i]['curriculum_division'],
      department: maps[i]['department'],
      major: maps[i]['major'],
      comple_course: maps[i]['comple_course'],
      grade: maps[i]['grade'],
      class_number: maps[i]['class_number'],
      lecture_number: maps[i]['lecture_number'],
      name: maps[i]['name'],
      credit: maps[i]['credit'],
      lecture_credit: maps[i]['lecture_credit'],
      experiment_credit: maps[i]['experiment_credit'],
      time: maps[i]['time'],
      type: maps[i]['type'],
      n14: maps[i]['n14'],
      professor: maps[i]['professor'],
      capacity: maps[i]['capacity'],
      note: maps[i]['note'],
      language: maps[i]['language'],
    );
  });
}

//db 제거 함수
Future<void> sql_DeleteSql() async {
  Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'dataclass2.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE dataclass(idx INTEGER PRIMARY KEY, curriculum_division TEXT, department TEXT, major TEXT, comple_course TEXT, grade TEXT, class_number TEXT, lecture_number TEXT, name TEXT, credit TEXT, lecture_credit TEXT, experiment_credit TEXT, time TEXT, type TEXT, n14 TEXT, professor TEXT, capacity TEXT, note TEXT, language TEXT)",
      );
    },
    version: 1,
  );
  Database db = await database;

  for (int i = 0; i < dataclass.length; i++) {
    await db.delete(
      'dataclass',
      where: "idx = ?",
      whereArgs: [i],
    );
  }
  db.close();
}

//db 수정 함수
Future<void> sql_UpdateSql(Dataclass dataclass) async {
  Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'dataclass2.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE dataclass(idx INTEGER PRIMARY KEY, curriculum_division TEXT, department TEXT, major TEXT, comple_course TEXT, grade TEXT, class_number TEXT, lecture_number TEXT, name TEXT, credit TEXT, lecture_credit TEXT, experiment_credit TEXT, time TEXT, type TEXT, n14 TEXT, professor TEXT, capacity TEXT, note TEXT, language TEXT)",
      );
    },
    version: 1,
  );
  Database db = await database;

  await db.update(
    'dataclass',
    dataclass.toMap(),
    where: "idx = ?",
    whereArgs: [dataclass.idx],
  );
  db.close();
}

void saveData() async {
  print("sql_start");

  // update();
  //dataclass용 test
  // await sql_DeleteSql();

  // print("delete complete");

  // await sql_InsertAllData();

  print("insert complete");

  dataclass = await sql_GetDataFromSql();
  print("load complete");
  preProcessingData();
  print("preprocessing complete");

  for (int i = 0; i < dataclass.length; i++) {
    print(
        "a ${dataclass[i].idx}: ${dataclass[i].curriculum_division},${dataclass[i].department},${dataclass[i].major},${dataclass[i].comple_course},${dataclass[i].grade},${dataclass[i].class_number},${dataclass[i].lecture_number},${dataclass[i].name},${dataclass[i].credit},${dataclass[i].lecture_credit},${dataclass[i].experiment_credit},${dataclass[i].time},${dataclass[i].n14},${dataclass[i].professor},${dataclass[i].capacity},${dataclass[i].note},${dataclass[i].language}");
    //print("b ${dataclass[i].idx}: ${dataclasss[i].curriculum_division},${dataclasss[i].department},${dataclasss[i].major},${dataclasss[i].comple_course},${dataclasss[i].grade},${dataclasss[i].class_number},${dataclasss[i].lecture_number},${dataclasss[i].name},${dataclasss[i].credit},${dataclasss[i].lecture_credit},${dataclasss[i].experiment_credit},${dataclasss[i].time},${dataclasss[i].n14},${dataclasss[i].professor},${dataclasss[i].capacity},${dataclasss[i].note},${dataclasss[i].language}");
  }
}

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: Colors.white,
    textColor: Colors.black,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
  );
}
