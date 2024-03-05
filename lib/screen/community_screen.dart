import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:niceroute/constants.dart';
import 'package:niceroute/firebase/fire_service.dart';
import 'package:niceroute/firebase/start_model.dart';
import 'package:niceroute/screen/writing_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  var googlePlace = GooglePlace(apiKey);
  List<AutocompletePrediction> predictions = [];
  final valueList = [
    '서울',
    '인천',
    '부산',
    '대전',
    '광주',
    '대구',
    '울산',
    '경상남도',
    '경상북도',
    '전라남도',
    '전라북도',
    '충청남도',
    '충청북도',
    '경기도',
    '강원도',
    '제주도'
  ];
  var selectValue = '서울';
  late Visibility local;
  late Visibility chart;
  late Visibility news;

  bool isLocal = true;
  bool isChart = false;
  bool isNews = false;
  late List<bool> isSelected;

  @override
  void initState() {
    isSelected = [isLocal, isChart, isNews];
    super.initState();
  }

  final CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection("start");

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  void btnAction() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WritingScreen(),
      ),
    );
  }

  void readAction() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30,
        shadowColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleSpacing: 10,
        backgroundColor: Colors.indigo[200],
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
        ),
        leadingWidth: 10,
        title: ListTile(
          title: Text(
            "커뮤니티",
            style: TextStyle(
                fontSize: 20,
                color: Colors.grey[100],
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleButtons(
                  isSelected: isSelected,
                  onPressed: toggleSelect,
                  children: const [
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('지역별', style: TextStyle(fontSize: 18))),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('인기순', style: TextStyle(fontSize: 18))),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('여행뉴스', style: TextStyle(fontSize: 18))),
                  ],
                ),
              ],
            ),
            local = localMethod(),
            chart = chartMethod(),
            news = newsMethod(),
            FutureBuilder<List<StartModel>>(
              future: FireService().getFireModel(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<StartModel> datas = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                        itemCount: datas.length,
                        itemBuilder: (BuildContext context, int index) {
                          StartModel data = datas[index];
                          if (selectValue == data.local) {
                            return Card(
                                child: ListTile(
                              onTap: readAction,
                              title: Text("${data.endName}"),
                              subtitle: Text("${(data.date)!.toDate()}"),
                            ));
                          }
                          return const SizedBox();
                        }),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            const Spacer(),
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: btnAction,
                    tooltip: '글쓰기',
                    child: const Icon(
                      Icons.create_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Visibility localMethod() {
    return Visibility(
      visible: isLocal,
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            '지역별 지름길 Top 5',
            style: TextStyle(fontSize: 22),
          ),
          DropdownButton(
              value: selectValue,
              items: valueList.map(
                (value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                },
              ).toList(),
              onChanged: (value) {
                setState(() {
                  selectValue = value!;
                });
              }),
        ],
      ),
    );
  }

  Visibility chartMethod() {
    return Visibility(
      visible: isChart,
      child: const Column(
        children: [
          SizedBox(height: 20),
          Text(
            '추천 지름길 리스트',
            style: TextStyle(fontSize: 22),
          ),
        ],
      ),
    );
  }

  Visibility newsMethod() {
    return Visibility(
      visible: isNews,
      child: const Column(
        children: [
          SizedBox(height: 20),
          Text(
            '최신 여행뉴스',
            style: TextStyle(fontSize: 22),
          ),
        ],
      ),
    );
  }

  void toggleSelect(value) {
    if (value == 0) {
      isLocal = true;
      isChart = false;
      isNews = false;
    } else if (value == 1) {
      isLocal = false;
      isChart = true;
      isNews = false;
    } else {
      isLocal = false;
      isChart = false;
      isNews = true;
    }
    setState(() {
      isSelected = [isLocal, isChart, isNews];
    });
  }
}
