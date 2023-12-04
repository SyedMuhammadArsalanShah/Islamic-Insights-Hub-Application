import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';

class SearchHadith extends StatefulWidget {
  const SearchHadith({super.key});

  @override
  State<SearchHadith> createState() => _SearchHadithState();
}

class _SearchHadithState extends State<SearchHadith> {
  late Map rawdatamap = {};
  late List datalist = [];
  late String searchInput = "";
  late String selectlang = "";
  bool isLoading = false;

  void getapi(String value) async {
    setState(() {
      isLoading = true;
    });

    var apiKey =
        "\$2y\$10\$BylaBcXs5Lw7ZOtYmQ3PXO1x15zpp26oc1FeGktdmF6YeYoRd88e";

    var hadithApiBase =
        "https://hadithapi.com/public/api/hadiths?apiKey=$apiKey&paginate=100000";

    String queryParam = '';

    if (value == 'Arabic') {
      queryParam = 'hadithArabic';
    } else if (value == 'Urdu') {
      queryParam = 'hadithUrdu';
    } else if (value == 'English') {
      queryParam = 'hadithEnglish';
    } else if (value == 'Hadith No') {
      queryParam = 'hadithNumber';
    } else {
      print("Please select a search type first.");
      return;
    }

    var res =
        await http.get(Uri.parse("$hadithApiBase&$queryParam=$searchInput"));
    if (res.statusCode == 200) {
      setState(() {
        rawdatamap = jsonDecode(res.body);
        datalist = rawdatamap["hadiths"]["data"];
        isLoading = false;
      });
    }
    // print("SMASB" + res.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search In All Hadith Books ",
          style: TextStyle(
            color: Color(0XFFF2F2F2),
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Color(0XFF010D26),
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "سرچ کے لیے مندرجہ ذیل آپشن کو پہلے  منتخب کیجیے",
                style: const TextStyle(
                  fontFamily: "jameel",
                  fontSize: 20,
                ),
                textAlign: TextAlign.justify,
                textDirection: TextDirection.rtl,
              )),
          CustomRadioButton(
            absoluteZeroSpacing: true,
            elevation: 0,
            unSelectedBorderColor: Color(0XFFD9D9D9),
            enableShape: true,
            selectedBorderColor: Color(0xff010D26),
            selectedColor: Color(0xff010D26),
            unSelectedColor: Color(0XFFD9D9D9),
            buttonLables: ['Arabic', 'Urdu', 'English', 'H-No'],
            buttonValues: ['Arabic', 'Urdu', 'English', 'Hadith No'],
            buttonTextStyle: const ButtonTextStyle(
                selectedColor: Colors.white,
                unSelectedColor: Colors.black,
                textStyle: TextStyle(fontSize: 16)),
            radioButtonValue: (value) {
              setState(() {
                selectlang = value;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: selectlang == 'Urdu' || selectlang == 'Arabic'
                  ? InputDecoration(
                      hintText: " ..... تلاش کریں ",
                      suffixIcon: Icon(Icons.search_rounded))
                  : InputDecoration(
                      hintText: "Search Here.....  ",
                      prefixIcon: Icon(Icons.search_rounded)),
              onChanged: (value) {
                searchInput = value;
                print("search value smas=>" + searchInput);
              },
              style: selectlang == 'Urdu' || selectlang == 'Arabic'
                  ? TextStyle(fontFamily: "jameel")
                  : TextStyle(fontFamily: "alq"),
              textAlign: selectlang == 'Urdu' || selectlang == 'Arabic'
                  ? TextAlign.right
                  : TextAlign.left,
              textDirection: selectlang == 'Urdu' || selectlang == 'Arabic'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
            ),
          ),
          ElevatedButton(
              onPressed: () {
                getapi(selectlang);
              },
              child: Text("Search")),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) {
                      String hadithdata = '';

                      if (selectlang == 'Arabic') {
                        hadithdata = 'hadithArabic';
                      } else if (selectlang == 'Urdu') {
                        hadithdata = 'hadithUrdu';
                      } else if (selectlang == 'English') {
                        hadithdata = 'hadithEnglish';
                      } else if (selectlang == 'Hadith No') {
                        hadithdata = 'hadithNumber';
                      } else {
                        print("Please select a search type first.");
                      }

                      String searchResult =
                          datalist[index][hadithdata].toString();
                      print("below smas" + hadithdata);
                      String searchTerm = searchInput;
                      int startIndex = searchResult.indexOf(searchTerm);

                      if (startIndex != -1) {
                        String first20Words = searchResult.substring(startIndex,
                            min(startIndex + 50, searchResult.length));

                        return InkWell(
                          onTap: () {
                            String number =
                                datalist[index]["hadithNumber"].toString();
                            String status =
                                datalist[index]["status"].toString();

                            String detail = selectlang == 'Hadith No'
                                ? datalist[index]["hadithUrdu"].toString()
                                : searchResult;

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchDetail(
                                      number, status, detail, selectlang),
                                ));
                          },
                          child: Card(
                            color: Color(0XFFD9D9D9),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  ListTile(
                                      leading: CircleAvatar(
                                        radius: 50,
                                          backgroundColor: Color(0xff023E73),
                                          child:  Text("#" +
                                          datalist[index]["hadithNumber"]
                                              .toString(),
                                            style: TextStyle(
                                                color: Color(0XFFF2F2F2)),
                                          )),
                                      title: Text(
                                          datalist[index]["book"]["bookName"]
                                              .toString()),
                                     
                                      trailing: Text("Status :" +
                                          datalist[index]["status"].toString())),
                                  Card(
                                    color: Color(0XFFF2F2F2),
                                    child: Container(
                                      width: double.infinity,
                                      child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            selectlang == 'Hadith No'
                                                ? datalist[index]["hadithUrdu"]
                                                    .toString()
                                                : first20Words.toString(),
                                            style: selectlang == 'Urdu' ||
                                                    selectlang == 'Arabic'||selectlang == 'Hadith No'
                                                ? TextStyle(fontFamily: "jameel")
                                                : TextStyle(fontFamily: "alq"),
                                            textAlign: selectlang == 'Urdu' ||
                                                    selectlang == 'Arabic'||selectlang == 'Hadith No'
                                                ? TextAlign.right
                                                : TextAlign.left,
                                            textDirection: selectlang == 'Urdu' ||
                                                    selectlang == 'Arabic'||selectlang == 'Hadith No'
                                                ? TextDirection.rtl
                                                : TextDirection.ltr,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    itemCount: datalist.length,
                  ),
          ),
        ],
      ),
    );
  }
}

class SearchDetail extends StatefulWidget {
  String number;
  String status;
  String detail;
  String selectlang;
  SearchDetail(this.number, this.status, this.detail, this.selectlang,
      {super.key});

  @override
  State<SearchDetail> createState() => _SearchDetailState();
}

class _SearchDetailState extends State<SearchDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hadith Detail"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            color: Color(0XFFD9D9D9),
            child: Column(
              children: [
                ListTile(
                    title: Text("Hadith Number #" +
                        "${widget.number.toString()}".toString()),
                    trailing: Text("Status :" + "${widget.status.toString()}")),
              Card(
                    color: Color(0XFFF2F2F2),
                    child: Container(
                      width: double.infinity,
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "${widget.detail.toString()}",
                            style: widget.selectlang == 'Urdu' ||
                                    widget.selectlang == 'Arabic'
                                ? TextStyle(fontFamily: "jameel")
                                : TextStyle(fontFamily: "alq"),
                            textAlign: widget.selectlang == 'Urdu' ||
                                    widget.selectlang == 'Arabic'
                                ? TextAlign.right
                                : TextAlign.left,
                            textDirection: widget.selectlang == 'Urdu' ||
                                    widget.selectlang == 'Arabic'
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                          )),
                    ),
                  ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
