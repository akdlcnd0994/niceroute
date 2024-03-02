import 'package:cloud_firestore/cloud_firestore.dart';

class StartModel {
  // 사용되는 자료형
  // 지역분류 + 시작지명 + 경유지명 + 도착지명 +  좌표3개 + 시작 내용 + 경유지 내용 + 작성시간
  String? local;
  String? stName;
  String? midName;
  String? endName;
  String? stCoord;
  String? midCoord;
  String? endCoord;
  String? stComment;
  String? midComment;
  Timestamp? date;
  DocumentReference? reference;

  //생성자
  StartModel({
    this.local,
    this.stName,
    this.midName,
    this.endName,
    this.stCoord,
    this.midCoord,
    this.endCoord,
    this.stComment,
    this.midComment,
    this.date,
    this.reference,
  });

  //json => Object로, firestore에서 불러올때
  StartModel.fromJson(dynamic json, this.reference) {
    local = json['local'];
    stName = json['stName'];
    midName = json['midName'];
    endName = json['endName'];
    stCoord = json['stCoord'];
    midCoord = json['midCoord'];
    endCoord = json['endCoord'];
    stComment = json['stComment'];
    midComment = json['midComment'];
    date = json['date'];
  }

  // Named Constructor with Initializer
  // fromSnapShot Named Constructor로 snapshot 자료가 들어오면 이걸 다시 Initializer를 통해
  // fromJson Named Constructor를 실행함
  // DocumentSnapshot 자료형을 받아 올때 사용하는 Named Constructor
  // 특정한 자료를 받아 올때 사용한다.
  StartModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.reference);

  // Named Constructor with Initializer
  // 컬렉션 내에 특정 조건을 만족하는 데이터를 다 가지고 올때 사용한다.
  StartModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.reference);

  //Object => json, firestore에 저장할때
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['local'] = local;
    map['stName'] = stName;
    map['midName'] = midName;
    map['endName'] = endName;
    map['stCoord'] = stCoord;
    map['midCoord'] = midCoord;
    map['endCoord'] = endCoord;
    map['stComment'] = stComment;
    map['midComment'] = midComment;
    map['date'] = date;
    return map;
  }
}
