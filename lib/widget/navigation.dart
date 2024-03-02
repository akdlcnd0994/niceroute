import 'package:flutter/material.dart';
import 'package:niceroute/screen/community_screen.dart';
import 'package:niceroute/screen/home_screen.dart';
import 'package:niceroute/screen/map_screen.dart';
import 'package:niceroute/screen/myInfo_screen.dart';
import 'package:niceroute/screen/oilInfo_screen.dart';

List<String> titles = <String>[
  '지도',
  '커뮤니티',
  'Home',
  '오일정보',
  '내정보',
];

List<Widget> screens = <Widget>[
  const MapScreen(),
  const CommunityScreen(),
  const HomeScreen(),
  const OilInfoScreen(),
  const MyInfoScreen(),
];

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int currentPageIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.indigo[200],
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber[100],
        elevation: 1.0,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: const Icon(Icons.map_rounded),
            icon: const Icon(Icons.map_outlined),
            label: titles[0],
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.comment),
            icon: const Icon(Icons.comment_outlined),
            label: titles[1],
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.home),
            icon: const Icon(Icons.home_outlined),
            label: titles[2],
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.oil_barrel),
            icon: const Icon(Icons.oil_barrel_outlined),
            label: titles[3],
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.person),
            icon: const Icon(Icons.person_outlined),
            label: titles[4],
          ),
        ],
      ),
      body: <Widget>[
        screens[0],
        screens[1],
        screens[2],
        screens[3],
        screens[4],
      ][currentPageIndex],
    );
  }
}
