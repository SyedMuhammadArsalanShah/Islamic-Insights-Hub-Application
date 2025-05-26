import 'package:flutter/material.dart';
import 'package:islamic_insights_hub/QuranApp/QuranAudioScr.dart';
import 'package:islamic_insights_hub/QuranApp/QuranJuzScr.dart';
import 'package:islamic_insights_hub/QuranApp/QuranTranslationScr.dart';
import 'QuranCloudScr.dart';
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
      length: 6,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "المصحف",
              style: TextStyle(
                fontFamily: "alq",
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.justify,
            ),
            centerTitle: true,
            bottom: TabBar(
              isScrollable: true,
              labelColor: Color(0XFF023E73),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xff010D26),
              tabs: [
  Tab(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.book),
        SizedBox(width: 8), // Add spacing between icon and text
        Text("Quranic Surahs"),
      ],
    ),
  ),
    Tab(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.cloud),
        SizedBox(width: 8),
        Text("QuranCloud"),
      ],
    ),
  ),
  Tab(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.search),
        SizedBox(width: 8),
        Text("Search"),
      ],
    ),
  ),
  Tab(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.audiotrack),
        SizedBox(width: 8),
        Text("Recitation"),
      ],
    ),
  ),
  Tab(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.translate_rounded),
        SizedBox(width: 8),
        Text("Translation"),
      ],
    ),
  ),
  Tab(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.book_rounded),
        SizedBox(width: 8),
        Text("Juz Quran"),
      ],
    ),
  ),
],

              
            ),
          ),
          body: TabBarView(children: [
            Quranlist(),
            QuranCloudScr(),
            SearchQuran(),
            QuranAudioScr(),
            QuranTranslationScr(),
            QuranJuzScr(),
          ])),
    );
  }
}
