import 'package:flutter/material.dart';
import 'TabsScr.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
                      Color(0XFFD9D9D9),
                      Color(0XFFF2F2F2),
                    ]),
              ),
              child: Column(
                children: [
                  Image.asset(
                    "images/book.png",
                    width: 300,
                    height: 300,
                  ),
                  Text(
                    " احادیث نبوی ﷺ سیکشن",
                    style: TextStyle(
                        fontFamily: "alq",
                        fontSize: 30,
                        color: Color(0XFF023E73)),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.justify,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => TabsScr()));
                      },
                      child: Text("Get Started"))
                ],
              )),
        ),
        backgroundColor: Color(0XFFD9D9D9));
  }
}
