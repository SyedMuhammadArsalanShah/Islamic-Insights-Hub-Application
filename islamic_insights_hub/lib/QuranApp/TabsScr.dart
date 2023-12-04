import 'package:flutter/material.dart';
import 'Quranlist.dart';
import 'SearchQuran.dart';


class TabsScr extends StatefulWidget {
  const TabsScr({super.key});

  @override
  State<TabsScr> createState() => _TabsScrState();
}

class _TabsScrState extends State<TabsScr> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "المصحف",
              style: TextStyle(fontFamily: "alq",),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.justify,
            ),
            centerTitle: true,
            bottom: TabBar(
             labelColor: Color(0XFF023E73),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xff010D26),
              tabs: [
                Tab(
                  text: "Quran",
                ),
                Tab(
                  text: "Search Quran",
                ),
              ],
            ),
          ),
          body: TabBarView(children: [
            Quranlist(),
            SearchQuran(),
          ])),
    );
  }
}
