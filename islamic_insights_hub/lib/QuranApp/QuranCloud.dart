import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

import 'surahindex.dart';

Map mapResponse = {};
Map dataResponse = {};
List listResponse = [];

class QuranCloudScr extends StatefulWidget {
  const QuranCloudScr({Key? key}) : super(key: key);

  @override
  State<QuranCloudScr> createState() => _QuranCloudScrState();
}

class _QuranCloudScrState extends State<QuranCloudScr> {
  Future apicall() async {
    http.Response response;

    response = await http.get(Uri.parse("http://api.alquran.cloud/v1/meta"));
    if (response.statusCode == 200) {
      setState(() {
        // stringresponse = response.body;
        mapResponse = jsonDecode(response.body);
        dataResponse = mapResponse['data']['surahs'];
        listResponse = dataResponse['references'];
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
                child: RefreshProgressIndicator(),
              ));
  }
}

class QuranCloud extends StatefulWidget {
  final Surahindex name;
  QuranCloud({Key? key, required this.name}) : super(key: key);

  @override
  State<QuranCloud> createState() => _QuranCloudState();
}

class _QuranCloudState extends State<QuranCloud> {
  Map mapResponse = {};
  Map dataResponse = {};
  List listResponse = [];
  List listResponse1 = [];
  late Map<String, dynamic> mapresp = {};
  late List<dynamic> languagesList = []; // Holds language data from API
  late List<dynamic> iList = []; //
  late List<dynamic> listresp = []; //
  String? selectedLanguage; // Stores the selected language
  String? selectedLanaguageData; // Stores the selected language identifier
  // List of language names
  final List<String> languages = [
    "Arabic",
    "Amharic",
    "Azerbaijani",
    "Berber",
    "Bengali",
    "Czech",
    "German",
    "Divehi",
    "English",
    "Spanish",
    "Persian",
    "French",
    "Hausa",
    "Hindi",
    "Indonesian",
    "Italian",
    "Japanese",
    "Korean",
    "Kurdish",
    "Malayalam",
    "Dutch",
    "Norwegian",
    "Polish",
    "Pashto",
    "Portuguese",
    "Romanian",
    "Russian",
    "Sindhi",
    "Somali",
    "Albanian",
    "Swedish",
    "Swahili",
    "Tamil",
    "Tajik",
    "Thai",
    "Turkish",
    "Tatar",
    "Uyghur",
    "Urdu",
    "Uzbek"
  ];

// to get surah
  Future apicall() async {
    http.Response response;

    response = await http.get(
        Uri.parse("https://api.alquran.cloud/v1/surah/${widget.name.numm}"));
    if (response.statusCode == 200) {
      setState(() {
        mapResponse = jsonDecode(response.body);
        dataResponse = mapResponse['data'];
        // int indexofsurah = widget.name.numm;
        listResponse = dataResponse['ayahs'];
        // print("WA910=>$listResponse");
      });
    }
  }

  // API call to fetch languages
  Future<void> languageapicodes() async {
    final response = await http
        .get(Uri.parse("https://api.alquran.cloud/v1/edition/language"));

    if (response.statusCode == 200) {
      setState(() {
        mapresp = jsonDecode(response.body);
        languagesList = mapresp["data"]; // Assuming "data" contains languages
      });
    } else {
      // Handle error appropriately
      print("Error fetching languages: ${response.statusCode}");
    }
  }

  // API call to fetch language details based on selected language
  Future<void> languageapi(String selectedLanguage) async {
    final response = await http.get(Uri.parse(
        "https://api.alquran.cloud/v1/edition/language/$selectedLanguage"));

    if (response.statusCode == 200) {
      setState(() {
        mapresp = jsonDecode(response.body);
        iList = mapresp["data"]; // Assuming "data" contains languages
        selectedLanaguageData = null; // Reset the identifier selection
      });
    } else {
      // Handle error appropriately
      print("Error fetching language details: ${response.statusCode}");
    }
  }

  Future<void> identifierApi(var identifier) async {
    final response = await http.get(Uri.parse(
        "https://api.alquran.cloud/v1/surah/${widget.name.numm}/${identifier}"));

    if (response.statusCode == 200) {
      setState(() {
        mapresp = jsonDecode(response.body);
        listresp =
            mapresp["data"]["ayahs"]; // Assuming "data" contains languages
        // selectedLanaguageData = null; // Reset the identifier selection
      });
    } else {
      // Handle error appropriately
      print("Error fetching language details: ${response.statusCode}");
    }
  }

@override
void initState() {
  super.initState();
  apicall();
  languageapicodes(); // Call API when the widget is initialized

  // Listen for the completion of the audio and update the UI accordingly
    audioPlayer.processingStateStream.listen((processingState) {
      if (processingState == ProcessingState.completed) {
        setState(() {
          isPlaying = false;
          currentlyPlayingIndex = null; // Reset when playback completes
        });
      }
    });
}


  // Audio player variables
  AudioPlayer audioPlayer = AudioPlayer();
  int? currentlyPlayingIndex; // Track the index of the playing Ayah
  bool isPlaying = false;

 Future<void> togglePlayPause(String audioUrl, int index) async {
  try {
    // If audio is playing and the user taps the currently playing Ayah, pause it
    if (isPlaying && currentlyPlayingIndex == index) {
      await audioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      // If a different Ayah is tapped, stop the previous audio and play the new one
      await audioPlayer.stop();
      await audioPlayer.setUrl(audioUrl);
      await audioPlayer.play();
      setState(() {
        currentlyPlayingIndex = index;
        isPlaying = true;
      });
    }
  } catch (e) {
    print("Error playing audio: $e");
  }
}


  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
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
                                fontSize: 15, color: Colors.white)),
                        Text(widget.name.englishNameTranslation,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.amiriQuran(color: Colors.white)),
                      ],
                    ),
                    title: Text(widget.name.urname,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.amiriQuran(color: Colors.white)),
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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  icon: const Icon(
                    Icons.arrow_drop_down_circle,
                    size: 16,
                  ),
                  isDense: true,
                  value: selectedLanguage,
                  hint: Center(
                    child: const Text("Select Language", style: TextStyle(
                                    fontFamily: "jameel",
                                    color: Color(0XFF023E73)),
                                    textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,),
                  ), // Hint for the dropdown
                  items: languagesList.isNotEmpty
                      ? languagesList.asMap().entries.map((entry) {
                          int index =
                              entry.key; // Get the index of the language
                          String languageCode =
                              entry.value; // Get the language code from the API

                          return DropdownMenuItem<String>(
                            value:
                                languageCode, // Use the language code as the value
                            child: Center(
                              child: Text(languages[
                                  index], style: TextStyle(
                                    fontFamily: "jameel",
                                    color: Color(0XFF023E73)),
                                    textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,),
                            ), // Display the corresponding language name by index
                          );
                        }).toList()
                      : null, // Set items to null if languagesList is empty
                  onChanged: (value) {
                    setState(() {
                      selectedLanguage = value; // Update the selected language
                      if (selectedLanguage != null) {
                        languageapi(
                            selectedLanguage!); // Fetch details for the selected language
                      }
                    });
                  },
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  icon: const Icon(
                    Icons.arrow_drop_down_circle,
                    size: 16,
                  ),
                  isDense: true,
                  value: selectedLanaguageData,
                  hint:
                      Center(
                        child: const Text("Select Identifier", style: TextStyle(
                                    fontFamily: "jameel",
                                    color: Color(0XFF023E73)),
                                    textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,),
                      ), // Hint for the dropdown
                  items: iList.isNotEmpty
                      ? iList.asMap().entries.map((entry) {
                          return DropdownMenuItem<String>(
                            value: entry.value[
                                "identifier"], // Use the language code as the value
                            child: Center(
                              child: Text(
                                entry.value["name"],
                                style: TextStyle(
                                    fontFamily: "jameel",
                                    color: Color(0XFF023E73)),
                                    textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                              ),
                            ), // Display the corresponding language name
                          );
                        }).toList()
                      : null, // Set items to null if iList is empty
                  onChanged: (value) {
                    setState(() {
                      selectedLanaguageData = value;
                      // Update the selected identifier
                      if (selectedLanaguageData != null) {
                        identifierApi(selectedLanaguageData);
                      }
                    });
                  },
                ),
              ),
            ),
            listResponse.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        if (listResponse.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        // Safely access listResponse and listresp
                        final ayahText = index < listresp.length
                            ? listresp[index]['text'] ?? 'No Text Available'
                            : ' ';
                        final audioUrl = index < listresp.length
                            ? listresp[index]["audio"]
                            : null;

                        return Card(
                          margin: const EdgeInsets.all(10),
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                child: Text(
                                  listResponse[index]['text'],
                                  style: GoogleFonts.amiriQuran(
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            subtitle: Column(
                              children: [
                                if (audioUrl == null)
                                  Center(child: Text(ayahText, style: TextStyle(
                                  fontFamily: "jameel",
                                  fontSize: 20,
                                  color: Color(0XFF023E73)),
                       
                              textAlign: TextAlign.center,))
                                else
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Card(
                                      elevation: 6,
                                      shadowColor: Colors.indigo[900],
                                      child: Center(
                                        child: IconButton(
                                          icon: Icon(
                                            
                                            currentlyPlayingIndex == index &&
                                                    isPlaying
                                                ? Icons.pause_circle_rounded
                                                : Icons
                                                    .play_circle_fill_rounded,
                                            color: Colors.indigo[900],
                                          ),
                                          onPressed: () {
                                            togglePlayPause(audioUrl, index);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: listResponse.length,
                    ),
                  )
                : Center(
                    child: LinearProgressIndicator(),
                  )
          ],
        ));
  }
}