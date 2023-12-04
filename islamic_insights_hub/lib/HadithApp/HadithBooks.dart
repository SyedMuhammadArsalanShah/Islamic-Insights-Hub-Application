import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'HadithChapters.dart';

class HadithBooks extends StatefulWidget {
  const HadithBooks({super.key});

  @override
  State<HadithBooks> createState() => _HadithBooksState();
}

class _HadithBooksState extends State<HadithBooks> {
  late Map rawdatamap = {};
  late List datalist = [];
  
  void getapi() async {
    var apiKey =
        "\$2y\$10\$BylaBcXs5Lw7ZOtYmQ3PXO1x15zpp26oc1FeGktdmF6YeYoRd88e";
    var res = await http
        .get(Uri.parse("https://hadithapi.com/api/books?apiKey=$apiKey"));
// print("SMASB" + res.body);

    if (res.statusCode == 200) {
      setState(() {
        rawdatamap = jsonDecode(res.body);

        datalist = rawdatamap["books"];
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
      // appBar: AppBar(
      //   title: Text(
      //     "Hadith Books Collection",
      //     style: TextStyle(color: Color(0XFFF2F2F2)),
      //   ),
      //   centerTitle: true,
      //   backgroundColor: Color(0XFF010D26),
      // ),
      body: datalist.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListTile(
                    onTap: () {
                      var bookSlug = datalist[index]["bookSlug"];
                
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HadithChapters(bookSlug),
                          ));
                    },
                    tileColor:Color(0xff023E73),
                    textColor: Color(0XFFF2F2F2),
                    title: Text(
                      datalist[index]["bookName"].toString(),
                      style: TextStyle(fontFamily: "alq"),
                    ),
                    // subtitle: Text(datalist[index]["writerName"].toString()),
                    leading: Text("${index + 1}"),
                    trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        datalist[index]["hadiths_count"] == "0"
                            ? Text("")
                            :
                
                        Text("Ahadiths :" +
                            datalist[index]["hadiths_count"].toString()),
                        Text("Chapters :" +
                            datalist[index]["chapters_count"].toString()),
                      ],
                    ),
                  ),
                );
              },
              itemCount: datalist.length,
            ),
      backgroundColor: Color(0XFFF2F2F2),
    );
  }
}
