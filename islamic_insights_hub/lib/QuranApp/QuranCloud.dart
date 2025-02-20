import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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
  "Chechen",
  "German",
  "Dhivehi",
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

  // Audio player variables
  AudioPlayer audioPlayer = AudioPlayer();
  int? currentlyPlayingIndex; // Track the index of the playing Ayah
  bool isPlaying = false;
  @override
  void initState() {
    super.initState();
    apicall();
    languageapicodes(); // Call API when the widget is initialized

    // Listen for playback completion to play the next Ayah
    audioPlayer.processingStateStream.listen((processingState) {
      if (processingState == ProcessingState.completed) {
        playNextAyah();
      }
    });
  }

  // Play the next Ayah automatically
  void playNextAyah() {
    if (currentlyPlayingIndex != null &&
        currentlyPlayingIndex! < listResponse.length - 1) {
      int nextIndex = currentlyPlayingIndex! + 1;
      togglePlayPause(listResponse[nextIndex]['audio'], nextIndex);
    } else {
      setState(() {
        isPlaying = false;
        currentlyPlayingIndex = null;
      });
    }
  }

  // Toggle play/pause and handle switching between Ayahs
  Future<void> togglePlayPause(String audioUrl, int index) async {
    try {
      // Check if the same Ayah is playing to avoid reloading
      if (isPlaying && currentlyPlayingIndex == index) {
        setState(() => isPlaying = false);
        await audioPlayer.pause();
      } else {
        if (currentlyPlayingIndex != null && currentlyPlayingIndex != index) {
          await audioPlayer.stop(); // Only stop if switching Ayahs
        }
        await audioPlayer.setUrl(audioUrl);
        setState(() {
          currentlyPlayingIndex = index;
          isPlaying = true;
        });
        await audioPlayer.play();
      }
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  // Future<void> togglePlayPause(String audioUrl, int index) async {
  //   try {
  //     // If audio is playing and the user taps the currently playing Ayah, pause it
  //     if (isPlaying && currentlyPlayingIndex == index) {
  //       await audioPlayer.pause();
  //       setState(() {
  //         isPlaying = false;
  //       });
  //     } else {
  //       // If a different Ayah is tapped, stop the previous audio and play the new one
  //       await audioPlayer.stop();
  //       await audioPlayer.setUrl(audioUrl);
  //       await audioPlayer.play();
  //       setState(() {
  //         currentlyPlayingIndex = index;
  //         isPlaying = true;
  //       });
  //     }
  //   } catch (e) {
  //     print("Error playing audio: $e");
  //   }
  // }
   Future<void> downloadAudio(String audioUrl, String filename) async {
    try {
      // Get the application's documents directory
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath = '${appDocDir.path}/$filename';

      // Create Dio instance
      Dio dio = Dio();
      await dio.download(audioUrl, filePath);

      // Show a success message with Snackbar action
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Downloaded: $filename"),
          duration: Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Open',
            onPressed: () {
              // Open the downloaded file location
              OpenFile.open(filePath);
            },
          ),
        ),
      );
    } catch (e) {
      // Handle any errors
      print("Error downloading file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to download: $filename")),
      );
    }
  }

  // Method to share text or audio link
  Future<void> shareContent(String arabic, String text, String audioUrl) async {
    await Share.share(
        'Ayah Text: $arabic\nTranslation Text: $text\nAudio Link: $audioUrl');
  }

  // Method to show dialog for actions
  void showActionDialog(
      String arabic, String ayahText, String audioUrl, index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an Action'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.download),
                title: Text('Download Audio'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the dialog
                  if (audioUrl != null) {
                    downloadAudio(audioUrl,
                        "Surah ${widget.name.namee} | ayah_${index + 1}.mp3"); // Download the audio
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.share),
                title: Text('Share'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the dialog
                  shareContent(arabic, ayahText, audioUrl ?? '');
                },
              ),
            ],
          ),
        );
      },
    );
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
                    child: const Text(
                      "Select Language",
                      style: TextStyle(
                          fontFamily: "jameel", color: Color(0XFF023E73)),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                    ),
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
                              child: Text(
                                languages[index],
                                style: TextStyle(
                                    fontFamily: "jameel",
                                    color: Color(0XFF023E73)),
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                              ),
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
                  hint: Center(
                    child: const Text(
                      "Select Identifier",
                      style: TextStyle(
                          fontFamily: "jameel", color: Color(0XFF023E73)),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                    ),
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
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: currentlyPlayingIndex == index
                                  ? Color(0XFF023E73)
                                  : Colors
                                      .transparent, // Highlight playing Ayah
                              width: 2.0,
                            ),
                          ),
                          color: currentlyPlayingIndex == index
                              ? Color(0xffececec)
                              : Colors.white,
                          child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Center(
                                  child: Text(
                                    listResponse[index]['text'],
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.amiriQuran(
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              subtitle: Column(
                                children: [
                                  if (audioUrl == null)
                                    Center(
                                        child: Text(
                                      ayahText,
                                      style: TextStyle(
                                          fontFamily: "jameel",
                                          fontSize: 20,
                                          color: Color(0XFF023E73)),
                                               textDirection: TextDirection.rtl,
                                    // textAlign: TextAlign.right,
                                      textAlign: TextAlign.center,
                                    ))
                                  else
                                    // Padding(
                                    //   padding: const EdgeInsets.all(16.0),
                                    //   child: Card(
                                    //     elevation: 6,
                                    //     shadowColor: Colors.indigo[900],
                                    //     child: Center(
                                    //       child: IconButton(
                                    //         icon: Icon(
                                    //           currentlyPlayingIndex == index &&
                                    //                   isPlaying
                                    //               ? Icons.pause_circle_rounded
                                    //               : Icons
                                    //                   .play_circle_fill_rounded,
                                    //           color: Colors.indigo[900],
                                    //         ),
                                    //         onPressed: () {
                                    //           togglePlayPause(audioUrl, index);
                                    //         },
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),

                                    Card(
                                      color: Color(0XFF023E73),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.skip_previous,
                                              color: Colors.white,
                                              size:
                                                  36, // Increase this value to make the icon larger
                                            ),
                                            onPressed: index > 0
                                                ? () => togglePlayPause(
                                                    listresp[index - 1]
                                                        ['audio'],
                                                    index - 1)
                                                : null,
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              isPlaying &&
                                                      currentlyPlayingIndex ==
                                                          index
                                                  ? Icons.pause
                                                  : Icons.play_arrow,
                                              color: Colors.white,
                                              size:
                                                  36, // Increase this value to make the icon larger
                                            ),
                                            onPressed: () {
                                              if (audioUrl != null) {
                                                togglePlayPause(
                                                    audioUrl, index);
                                              }
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.skip_next,
                                              color: Colors.white,
                                              size:
                                                  36, // Increase this value to make the icon larger
                                            ),
                                            onPressed:
                                                index < listResponse.length - 1
                                                    ? () => togglePlayPause(
                                                        listresp[index + 1]
                                                            ['audio'],
                                                        index + 1)
                                                    : null,
                                          ),

                                          // button in dialog
                                          // IconButton(
                                          //   icon: Icon(Icons.download),
                                          //   onPressed: () {
                                          //     if (audioUrl != null) {
                                          //       downloadAudio(audioUrl,
                                          //           "Surah ${widget.name.namee} | ayah_${index + 1}.mp3"); // Download the audio
                                          //     }
                                          //   },
                                          // ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            onTap: () {
                              
                            
                                  // Show the action dialog when tapping on the ListTile
                                  showActionDialog(
                                    listResponse[index]['text'].toString(),
                                    ayahText.isNotEmpty
                                        ? ayahText
                                        : 'No text available', // Ensure ayahText is not null
                                    audioUrl ??
                                        '', // Provide an empty string if audioUrl is null
                                    index + 1,
                                  );
                                },
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
