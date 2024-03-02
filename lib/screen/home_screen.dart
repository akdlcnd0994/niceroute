import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        // leading: IconButton(
        //     onPressed: () {}, icon: const Icon(Icons.menu)), // 왼쪽 메뉴버
        leadingWidth: 10,
        title: ListTile(
          title: Text(
            "Home",
            style: TextStyle(
                fontSize: 20,
                color: Colors.grey[100],
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: Container(
          child: const Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Text("jongt"),
        ],
      )),
    );
  }
}
