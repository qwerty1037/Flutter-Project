class LectureTime {
  int? day;
  double? StartTime;
  double? EndTime;
}

class LectureBR {
  String? Building;
  String? Room;
}

class Dataclass {
  int? idx;
  String? curriculum_division;
  String? department;
  String? major;
  String? comple_course;
  String? grade;
  String? class_number;
  String? lecture_number;
  String? name;
  String? credit;
  String? lecture_credit;
  String? experiment_credit;
  String? time;
  String? type;
  String? n14;
  String? professor;
  String? capacity;
  String? note;
  String? language;
  List<LectureTime>? lecture_time;
  List<LectureBR>? lecture_buildingroom;

  Dataclass({
    this.idx,
    this.curriculum_division,
    this.department,
    this.major,
    this.comple_course,
    this.grade,
    this.class_number,
    this.lecture_number,
    this.name,
    this.credit,
    this.lecture_credit,
    this.experiment_credit,
    this.time,
    this.type,
    this.n14,
    this.professor,
    this.capacity,
    this.note,
    this.language,
  });

  factory Dataclass.fromJson(dynamic json) {
    return Dataclass(
      curriculum_division: "${json['교과구분']}",
      department: "${json['개설대학']}",
      major: "${json['개설학과']}",
      comple_course: "${json['이수과정']}",
      grade: "${json['학년']}",
      class_number: "${json['교과목번호']}",
      lecture_number: "${json['강좌번호']}",
      name: "${json['교과목명']}",
      credit: "${json['학점']}",
      lecture_credit: "${json['강의']}",
      experiment_credit: "${json['실습']}",
      time: "${json['수업교시']}",
      type: "${json['수업형태']}",
      n14: "${json['강의실']}",
      professor: "${json['담당교수']}",
      capacity: "${json['정원']}",
      note: "${json['비고']}",
      language: "${json['강의언어']}",
    );
  }

  Map toJson() => {
        "교과구분": curriculum_division,
        "개설대학": department,
        "개설학과": major,
        "이수과정": comple_course,
        "학년": grade,
        "교과목번호": class_number,
        "강좌번호": lecture_number,
        "교과목명": name,
        "학점": credit,
        "강의": lecture_credit,
        "실습": experiment_credit,
        "수업교시": time,
        "수업형태": type,
        "강의실": n14,
        "담당교수": professor,
        "정원": capacity,
        "비고": note,
        "강의언어": language,
      };

  Map<String, dynamic> toMap() {
    return {
      'idx': idx,
      'curriculum_division': curriculum_division,
      'department': department,
      'major': major,
      'comple_course': comple_course,
      'grade': grade,
      'class_number': class_number,
      'lecture_number': lecture_number,
      'name': name,
      'credit': credit,
      'lecture_credit': lecture_credit,
      'experiment_credit': experiment_credit,
      'time': time,
      'type': type,
      'n14': n14,
      'professor': professor,
      'capacity': capacity,
      'note': note,
      'language': language,
    };
  }
}
