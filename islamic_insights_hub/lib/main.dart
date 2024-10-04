import 'dart:async';

import 'package:flutter/material.dart';
import 'package:islamic_insights_hub/HadithApp/SplashScreen.dart';
import 'package:islamic_insights_hub/QuranApp/SplashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Islamic Insights Hub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff023E73)),
        useMaterial3: true,
      ),
      home: const SplashScr(),
    );
  }
}

class SplashScr extends StatefulWidget {
  const SplashScr({super.key});

  @override
  State<SplashScr> createState() => _SplashScrState();
}

class _SplashScrState extends State<SplashScr> {
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(seconds: 3), (() {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => TabsScr()));
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff010D26),
              Color(0xff023E73),
            ]),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Text(
            "Islamic Insights Hub",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "jameel",
                fontSize: 30,
                color: Color(0XFFF2F2F2)),
          )),
          Center(
              child: Text(
            "مرکزِعلومِ اسلامی",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "jameel",
                fontSize: 30,
                color: Color(0XFFF2F2F2)),
          )),
        ],
      ),
    ))
        // backgroundColor: Color(0XFFD9D9D9)
        );
  }
}

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
              "Islamic Insights Hub",
              style: TextStyle(
                color: Color(0xff010D26),
              ),
            ),
            centerTitle: true,
            // backgroundColor: Color(0XFF010D26),
            bottom: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xff010D26),
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
              shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(50), // Creates border
                  color: Color(0xff010D26)),
              tabs: [
                Tab(
                  text: "Quran",
                ),
                Tab(
                  text: "Hadith",
                ),
              ],
            ),
          ),
          body: TabBarView(children: [
            SplashScreenH(),
            SplashScreen(),
          ])),
    );
  }
}
