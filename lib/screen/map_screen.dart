import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:niceroute/constants.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  var googlePlace = GooglePlace(apiKey);
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  List<AutocompletePrediction> predictions = [];
  bool _visibility = false;
  DetailsResult detailsResult = DetailsResult();
  final _textController = TextEditingController();

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

  Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  void getDetails(String placeId) async {
    var result = await googlePlace.details.get(placeId);
    if (result != null && result.result != null && mounted) {
      setState(() {
        detailsResult = result.result!;
      });
    }
  }

  static const LatLng schoolLatlng = LatLng(
    //위도와 경도 값 지정
    35.148554,
    129.035460,
  );

  static const CameraPosition initialPosition = CameraPosition(
    //지도를 바라보는 카메라 위치
    target: schoolLatlng, //카메라 위치(위도, 경도)
    zoom: 17, //확대 정도
  );

  @override
  void dispose() {
    // TODO: implement dispose
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          GoogleMap(
            //구글 맵 사용
            onMapCreated: (GoogleMapController controller) =>
                _controller.complete(controller),
            mapType: MapType.normal, //지도 유형 설정 hybrid, normal
            initialCameraPosition: initialPosition, //지도 초기 위치 설정

            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
          ),
          Column(
            children: [
              const SizedBox(height: 40),
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Search",
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
                  autoCompleteSearch(value);
                },
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      onPressed: () async {
                        final GoogleMapController controller =
                            await _controller.future;
                        var gps = await getCurrentLocation();

                        controller.animateCamera(CameraUpdate.newLatLng(
                            LatLng(gps.latitude, gps.longitude)));
                      },
                      backgroundColor: const Color(0xFfffffff),
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
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
                            final GoogleMapController controller =
                                await _controller.future;
                            getDetails(predictions[index].placeId!);

                            if (detailsResult.geometry != null &&
                                detailsResult.geometry!.location != null) {
                              controller.animateCamera(CameraUpdate.newLatLng(
                                  LatLng(detailsResult.geometry!.location!.lat!,
                                      detailsResult.geometry!.location!.lng!)));
                            }
                            _textController.clear();
                            _visibility = false;
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
