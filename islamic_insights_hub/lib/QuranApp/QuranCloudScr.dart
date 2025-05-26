import 'QuranCloud.dart';
import 'surahindex.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class QuranCloudScr extends StatefulWidget {
  const QuranCloudScr({Key? key}) : super(key: key);

  @override
  State<QuranCloudScr> createState() => _QuranCloudScrState();
}

class _QuranCloudScrState extends State<QuranCloudScr> {
  Map mapResponse = {};
  Map dataResponse = {};
  List listResponse = [];
  Future apicall() async {
    http.Response response;

    response = await http.get(Uri.parse("https://api.alquran.cloud/v1/surah"));
    if (response.statusCode == 200) {
      setState(() {
        // stringresponse = response.body;
        mapResponse = jsonDecode(response.body);
        // dataResponse = mapResponse['data']['surahs'];
        listResponse = mapResponse['data'];
        print("SMAS=>$listResponse");
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    apicall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: listResponse.isNotEmpty
            ? ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.all(10),
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white)),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuranCloud(
                                      name: Surahindex(
                                    listResponse[index]['number'],
                                    listResponse[index]['numberOfAyahs'],
                                    listResponse[index]["englishName"],
                                    listResponse[index]['name'],
                                    listResponse[index]
                                        ['englishNameTranslation'],
                                    listResponse[index]['revelationType'],
                                  ))),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundColor: Color(0xff055BA6),
                        child: Text(
                          listResponse[index]["number"].toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(listResponse[index]['name'],
                          style: GoogleFonts.amiriQuran()),
                      subtitle: Text(
                        listResponse[index]['englishName'],
                        style: GoogleFonts.amiriQuran(color: Color(0Xff0367A6)),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          listResponse[index]['revelationType'] == 'Meccan'
                              ? Image.asset('images/kaaba.png',
                                  width: 30, height: 30)
                              : Image.asset('images/madina.png',
                                  width: 30, height: 30),
                          Text(
                            "verses ${listResponse[index]['numberOfAyahs'].toString()}",
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: listResponse == null ? 0 : listResponse.length,
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
