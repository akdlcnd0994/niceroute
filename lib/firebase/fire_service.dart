import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:niceroute/firebase/start_model.dart';

class FireService {
  // 싱글톤 패턴
  static final FireService _fireService = FireService._internal();
  factory FireService() => _fireService;
  FireService._internal();

  //Create
  Future createMemo(Map<String, dynamic> json) async {
    // 초기화
    await FirebaseFirestore.instance.collection("start").add(json);
  }

  Future<List<StartModel>> getFireModel() async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection("start");
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await collectionReference.orderBy("date").get();

    List<StartModel> mottos = [];
    for (var doc in querySnapshot.docs) {
      StartModel fireModel = StartModel.fromQuerySnapshot(doc);
      mottos.add(fireModel);
    }
    return mottos;
  }
}
