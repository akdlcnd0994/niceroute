import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:niceroute/constants.dart';
import 'package:niceroute/firebase/fire_service.dart';
import 'package:niceroute/firebase/start_model.dart';

class WritingScreen extends StatefulWidget {
  const WritingScreen({super.key});

  @override
  State<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> {
  var googlePlace = GooglePlace(apiKey);

  List<AutocompletePrediction> predictions = [];
  bool _visibility = false;

  DetailsResult detailsResult = DetailsResult();
  final _textController = TextEditingController();
  final _textController2 = TextEditingController();
  final _textController3 = TextEditingController();
  final _tempController = TextEditingController();
  int check = 0;
  String stName = '';
  String midName = '';
  String endName = '';
  String stComment = '';
  String midComment = '';
  String valueText = '';
  String contentStr = '';
  String stLatLng = '';
  String midLatLng = '';
  String endLatLng = '';

  String stText = '시작 지점 : ', endText = '도착 지점 : ', midText = '경유지 : ';

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

  void autoCompleteSearch(String value) async {
    if (value == "") {
      predictions = List.empty();
    } else {
      var result = await googlePlace.autocomplete.get(value);
      if (result != null && result.predictions != null && mounted) {
        setState(() {
          predictions = result.predictions!;
        });
      }
    }
    if (predictions.isNotEmpty) {
      _visibility = true;
    } else {
      _visibility = false;
    }
    setState(() {});
  }

  void getDetails(String placeId) async {
    var result = await googlePlace.details.get(placeId);
    if (result != null && result.result != null && mounted) {
      setState(() {
        detailsResult = result.result!;
      });
    }
  }

  Future<dynamic> commentButton(int num, String text) {
    // 메시지창 띄워서 내용적고 시작장소, 경유지에 따라 다른 변수에 저장
    _tempController.text = text;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: num == 0 ? const Text('출발 정보') : const Text('경유 정보'),
          content: SizedBox(
            width: 500,
            height: 400,
            child: Flexible(
              child: TextField(
                controller: _tempController,
                maxLines: null,
                onChanged: (value) {
                  setState(() {
                    valueText = value;
                  });
                },
                //controller: ,
                decoration: const InputDecoration(hintText: "내용을 입력해주세요."),
              ),
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              color: Colors.green,
              textColor: Colors.white,
              child: const Text('OK'),
              onPressed: () {
                setState(() {
                  if (num == 0) {
                    stComment = valueText;
                  } else {
                    midComment = valueText;
                  }
                  Navigator.pop(context);
                });
              },
            ),
            MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('CANCEL'),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 50,
        shadowColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleSpacing: 10,
        backgroundColor: Colors.indigo[200],
        leadingWidth: 25,
        iconTheme: const IconThemeData(color: Colors.white),
        title: ListTile(
          title: Text(
            "글쓰기",
            style: TextStyle(
                fontSize: 20,
                color: Colors.grey[100],
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: Column(
        children: [
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
          const SizedBox(height: 30),
          TextField(
            controller: _textController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: "시작 장소",
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  _textController.clear();
                  autoCompleteSearch('');
                },
                child: const Icon(
                  Icons.close,
                  size: 24,
                ),
              ),
              contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                  width: 2.0,
                ),
              ),
            ),
            onChanged: (value) {
              check = 0;
              autoCompleteSearch(value);
            },
          ),
          Text(stText),
          Row(
            children: [
              Flexible(
                child: stComment == ''
                    ? TextButton(
                        onPressed: () {
                          commentButton(0, '');
                        },
                        child: const Text('내용 추가'),
                      )
                    : Text(
                        stComment,
                        style: const TextStyle(fontSize: 25),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
              ),
              if (stComment != '')
                TextButton(
                  onPressed: () {
                    commentButton(0, stComment);
                  },
                  child: const Text('수정'),
                ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _textController3,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: "경유지",
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  _textController3.clear();
                  autoCompleteSearch('');
                },
                child: const Icon(
                  Icons.close,
                  size: 24,
                ),
              ),
              contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                  width: 2.0,
                ),
              ),
            ),
            onChanged: (value) {
              check = 1;
              autoCompleteSearch(value);
            },
          ),
          Text(midText),
          Row(
            children: [
              Flexible(
                child: midComment == ''
                    ? TextButton(
                        onPressed: () {
                          commentButton(1, '');
                        },
                        child: const Text('내용 추가'),
                      )
                    : Text(
                        midComment,
                        style: const TextStyle(fontSize: 25),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
              ),
              if (midComment != '')
                TextButton(
                  onPressed: () {
                    commentButton(1, midComment);
                  },
                  child: const Text('수정'),
                ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _textController2,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: "도착 장소",
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  _textController2.clear();
                  autoCompleteSearch('');
                },
                child: const Icon(
                  Icons.close,
                  size: 24,
                ),
              ),
              contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                  width: 2.0,
                ),
              ),
            ),
            onChanged: (value) {
              check = 2;
              autoCompleteSearch(value);
            },
          ),
          Text(endText),
          Visibility(
            visible: _visibility,
            child: Flexible(
              child: Card(
                color: const Color(0x00ff0000),
                child: ListView.builder(
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const CircleAvatar(
                        child: Icon(
                          Icons.pin_drop,
                          color: Colors.white,
                        ),
                      ),
                      title: Text("${predictions[index].description}"),
                      onTap: () async {
                        //getDetails 첫 작업이 실패할 가능성이 있으므로 추후 해결이 안된다면 activity의 초기화 파트에서 getDetails를 호출해줄 것
                        getDetails(predictions[index].placeId!);

                        if (detailsResult.geometry != null &&
                            detailsResult.geometry!.location != null) {
                          if (check == 0) {
                            stText =
                                "시작 지점 : ${predictions[index].description}";
                            stName = predictions[index].description!;
                            stLatLng =
                                '${detailsResult.geometry!.location!.lat}/${detailsResult.geometry!.location!.lng}';
                            _textController.clear();
                          } else if (check == 1) {
                            midText = "경유지 : ${predictions[index].description}";
                            midName = predictions[index].description!;
                            midLatLng =
                                '${detailsResult.geometry!.location!.lat}/${detailsResult.geometry!.location!.lng}';
                            _textController3.clear();
                          } else {
                            endText =
                                "도착 지점 : ${predictions[index].description}";
                            endName = predictions[index].description!;
                            endLatLng =
                                '${detailsResult.geometry!.location!.lat}/${detailsResult.geometry!.location!.lng}';
                            _textController2.clear();
                          }
                        }
                        _textController.clear();
                        _visibility = false;
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          TextButton(
              onPressed: () async {
                StartModel fireModel = StartModel(
                  local: selectValue,
                  stName: stName,
                  midName: midName,
                  endName: endName,
                  stCoord: stLatLng,
                  midCoord: midLatLng,
                  endCoord: endLatLng,
                  stComment: stComment,
                  midComment: midComment,
                  date: Timestamp.now(),
                );
                await FireService().createMemo(fireModel.toJson());
              },
              child: const Icon(Icons.send)),
        ],
      ),
    );
  }
}
