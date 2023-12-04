import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Hadiths extends StatefulWidget {
  var slug;
  var number;
  Hadiths(this.slug, this.number, {super.key});

  @override
  State<Hadiths> createState() => _HadithsState();
}

class _HadithsState extends State<Hadiths> {
  late Map rawdatamap = {};
  late List datalist = [];
  void getapi() async {
    var bookslug = widget.slug;
    var number = widget.number;
    var apiKey =
        "\$2y\$10\$BylaBcXs5Lw7ZOtYmQ3PXO1x15zpp26oc1FeGktdmF6YeYoRd88e";
    var res = await http.get(Uri.parse(
        "https://hadithapi.com/public/api/hadiths?apiKey=$apiKey&book=$bookslug&chapter=$number&paginate=100000"));

    // print("SMASB" + res.body);

    if (res.statusCode == 200) {
      setState(() {
        rawdatamap = jsonDecode(res.body);

        datalist = rawdatamap["hadiths"]["data"];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getapi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hadith Books Collection",
          style: TextStyle(
            color: Color(0XFFF2F2F2),
          ),
        ),
        centerTitle: true,
        backgroundColor:Color(0xff023E73),
      ),
      body: datalist.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  color: Color(0XFFD9D9D9),
                  child: Column(
                    children: [
                      ListTile(
                          title: Text("Hadith Number #" +
                              datalist[index]["hadithNumber"].toString()),
                          trailing: Text("Status :" +
                              datalist[index]["status"].toString())),
                      Card(
                        color: Color(0XFFF2F2F2),
                        child: Container(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              datalist[index]["hadithArabic"].toString(),
                              style: const TextStyle(
                                  fontFamily: "alq",
                                  fontSize: 20,
                                  color: Color(0xff023E73)),
                              textAlign: TextAlign.justify,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                String urdu =
                                    datalist[index]["hadithUrdu"].toString();

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UrduScreen(urdu),
                                    ));
                              },
                              child: Text("Urdu")),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                String english =
                                    datalist[index]["hadithEnglish"].toString();

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EnglishScreen(english),
                                    ));
                              },
                              child: Text("English")),
                        ],
                      ),
                      // Card(
                      //   color: Color(0XFFF2F2F2),
                      //   child: Container(
                      //     width: double.infinity,
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(16.0),
                      //       child: Text(
                      //         datalist[index]["hadithUrdu"].toString(),
                      //         style: const TextStyle(
                      //           fontFamily: "jameel",
                      //           fontSize: 20,
                      //         ),
                      //         textAlign: TextAlign.justify,
                      //         textDirection: TextDirection.rtl,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                );
              },
              itemCount: datalist.length,
            ),
    );
  }
}

class UrduScreen extends StatefulWidget {
  String urdu;
  UrduScreen(this.urdu, {super.key});

  @override
  State<UrduScreen> createState() => _UrduScreenState();
}

class _UrduScreenState extends State<UrduScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Urdu Translation"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Card(
              color: Color(0XFFF2F2F2),
              child: Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    " ${widget.urdu.toString()}",
                    style: const TextStyle(
                      fontFamily: "jameel",
                      
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.justify,
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

class EnglishScreen extends StatefulWidget {
  String english;
  EnglishScreen(this.english, {super.key});

  @override
  State<EnglishScreen> createState() => _EnglishScreenState();
}

class _EnglishScreenState extends State<EnglishScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("English Translation"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            color: Color(0XFFF2F2F2),
            child: Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  " ${widget.english.toString()}",
                  style: const TextStyle(
                    fontFamily: "alq",
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.justify,
                  textDirection: TextDirection.ltr,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
