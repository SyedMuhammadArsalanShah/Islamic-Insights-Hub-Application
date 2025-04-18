import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;
import 'surahindex.dart';

Map mapResponse = {};
Map dataResponse = {};
List listResponse = [];
List listResponse1 = [];

class Surahs extends StatefulWidget {
  final Surahindex name;
  Surahs({Key? key, required this.name}) : super(key: key);

  @override
  State<Surahs> createState() => _SurahsState();
}

class _SurahsState extends State<Surahs> {
  Future apicall() async {
    http.Response response;

    response = await http
        .get(Uri.parse("http://api.alquran.cloud/v1/quran/quran-uthmani"));
    if (response.statusCode == 200) {
      setState(() {
        mapResponse = jsonDecode(response.body);
        dataResponse = mapResponse['data'];
        int indexofsurah = widget.name.numm - 1;
        listResponse = dataResponse['surahs'][indexofsurah]['ayahs'];
        print("WA910=>$listResponse");
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
        appBar: AppBar(
          title: Text("Surah ${widget.name.namee}",
              style: const TextStyle(fontFamily: 'alq', color: Colors.white)),
          backgroundColor: Color(0xff023E73),
        ),
        body: Column(
          children: [
            Center(
              child: Card(
                elevation: 8,
                color: Color(0xff023E73),
                shadowColor: Colors.indigo,
                margin: const EdgeInsets.all(10),
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
                child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        "${widget.name.numm}",
                        style: TextStyle(color: Color(0xff023E73)),
                      ),
                    ),
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Surah ${widget.name.namee} ",
                            textAlign: TextAlign.center,
                               style: GoogleFonts.amiriQuran(
                                fontSize: 15,
                                color: Colors.white)),
                        Text(widget.name.englishNameTranslation,
                            textAlign: TextAlign.center,
                             style: GoogleFonts.amiriQuran( color: Colors.white)),
                      ],
                    ),
                    title: Text(widget.name.urname,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                         style: GoogleFonts.amiriQuran( color: Colors.white)),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        widget.name.revelationType == 'Meccan'
                            ? Image.asset('images/kaaba.png',
                                width: 20, height: 30)
                            : Image.asset('images/madina.png',
                                width: 20, height: 30),
                        Text(
                          "verses ${widget.name.nummv}",
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ],
                    )),
              ),
            ),
            listResponse.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                    itemBuilder: (context, index) {
                      // ignore: unnecessary_null_comparison
                      if (listResponse != null) {
                        return Card(
                          margin: const EdgeInsets.all(10),
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.white)),
                          child: ListTile(
                            // onTap: () {},

                            title: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                listResponse[index]['text'],
                                textDirection: TextDirection.rtl,
                                  style: GoogleFonts.amiriQuran( color: Colors.black),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                    itemCount: listResponse.length,
                  ))
                : Center(
                    child: LinearProgressIndicator(),
                  )
          ],
        ));
  }
}
