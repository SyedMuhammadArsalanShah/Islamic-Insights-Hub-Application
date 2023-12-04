import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchQuran extends StatefulWidget {
  const SearchQuran({super.key});

  @override
  State<SearchQuran> createState() => _SearchQuranState();
}

class _SearchQuranState extends State<SearchQuran> {
  Map mapResponse = {};
  Map dataResponse = {};
  List datalist = [];
  List<dynamic> datalist1 = [];

  String searchInput = "";
  bool isLoading = false;

  void apicall() async {
    isLoading = true;
    http.Response response;

    response = await http.get(Uri.parse(
        "https://api.alquran.cloud/v1/search/$searchInput/all/quran-simple-clean"));
    if (response.statusCode == 200) {
      setState(() {
        mapResponse = jsonDecode(response.body);
        dataResponse = mapResponse['data'];
        datalist = dataResponse['matches'];

        print("WA910=>$datalist");

        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
                decoration: InputDecoration(
                    hintText: " ..... تلاش کریں ",
                    suffixIcon: Icon(Icons.search_rounded)),
                onChanged: (value) {
                  searchInput = value;
                  print("search value smas=>" + value);
                },
                style: TextStyle(fontFamily: "alq"),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl),
          ),
          ElevatedButton(
              onPressed: () {
                apicall();
              },
              child: Text("Search")),
          Center(
            child:
           Text(  " $searchInput  ${searchInput.isEmpty ? '' : "="+dataResponse['count'].toString()+"تعداد"}",
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontFamily: 'alq',
                        fontSize: 25
                      )),
             ),
        
          Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        var surahcard = datalist[index]["surah"];

                        return Card(
                          color: const Color(0XFFD9D9D9),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Card(
                                  color: const Color(0XFFF2F2F2),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(datalist[index]["text"],
                                            style: TextStyle(fontFamily: "alq"),
                                            textAlign: TextAlign.right,
                                            textDirection: TextDirection.rtl)),
                                  ),
                                ),
                                Center(
                                  child: Card(
                                    color:Color(0xff010D26),
                                    child: ListTile(
                             
                                      textColor: Colors.white,
                                      trailing: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Text(
                                          surahcard["number"].toString(),
                                          style:
                                              TextStyle(color: Color(0xff055BA6)),
                                        ),
                                      ),
                                      title: Text(
                                        "سورہ نمبر ${surahcard["number"].toString()} : ${surahcard["name"]} - آیت نمبر ${datalist[index]["numberInSurah"].toString()}",
                                        textAlign: TextAlign.right,
                                        textDirection: TextDirection.rtl,
                                        style: const TextStyle(
                                          fontFamily: 'alq',
                                        ),
                                      ),
                                      leading:
                                          surahcard["revelationType"] == 'Meccan'
                                              ? Image.asset('images/kaaba.png',
                                                  width: 20, height: 30)
                                              : Image.asset('images/madina.png',
                                                  width: 20, height: 30),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: datalist.length,
                    )),
        ],
      ),
    );
  }
}
