import 'dart:async';

import 'package:flutter/material.dart';
import 'package:islamic_insights_hub/HadithApp/SplashScreen.dart';
import 'package:islamic_insights_hub/QuranApp/SplashScreen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutScreen(),
                      ));
                },
                icon: const Icon(
                  Icons.copyright_rounded,
                ),
              )
            ],
            centerTitle: true,
            // backgroundColor: Color(0XFF010D26),
            bottom: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xff010D26),
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10), // Creates border
                  color: Color(0XFF023E73)),
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



class AboutScreen extends StatelessWidget {
  final String githubProfileUrl = 'https://github.com/SyedMuhammadArsalanShah';
  final String githubRepoUrl = 'https://github.com/SyedMuhammadArsalanShah/Islamic-Insights-Hub-Application';

  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color darkBlue = const Color(0xff010D26);
    final Color mediumBlue = const Color(0xff023E73);

    return Scaffold(
      backgroundColor: darkBlue,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('About Islamic Insights Hub'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Islamic Insights Hub',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'A comprehensive Flutter app designed to deepen your connection '
              'with the Quran and Hadith through multilingual support, '
              'powerful search features, high-quality audio, and more.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Developed By:',
              style: TextStyle(
                  color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),

            // Developer name with clickable link to GitHub profile
            RichText(
              text: TextSpan(
                text: 'Syed Muhammad Arsalan Shah Bukhari',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _launchUrl(githubProfileUrl);
                  },
              ),
            ),

            const SizedBox(height: 40),

            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white70,
                ),
                children: [
                  const TextSpan(text: 'GitHub Repository: '),
                  TextSpan(
                    text: 'Islamic Insights Hub ',
                    style: TextStyle(
                       color: Colors.blue,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _launchUrl(githubRepoUrl);
                      },
                  ),
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Icon(
                        Icons.open_in_new,
                        size: 18,
                       color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            Center(
              child: Text(
                '© 2023 Islamic Insights Hub. All rights reserved.',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
