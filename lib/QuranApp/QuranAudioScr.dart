import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'QuranTranslationScr.dart';
import 'package:quran/quran.dart' as quran;

class QuranAudioScr extends StatefulWidget {
  const QuranAudioScr({super.key});

  @override
  State<QuranAudioScr> createState() => _QuranAudioScrState();
}

class _QuranAudioScrState extends State<QuranAudioScr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
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
                    builder: (context) => QuranAudio(
                        name: Surahindex(
                            index + 1,
                            quran.getVerseCount(index + 1),
                            quran.getSurahName(index + 1),
                            quran.getSurahNameArabic(index + 1),
                            quran.getSurahNameEnglish(index + 1),
                            quran.getPlaceOfRevelation(index + 1)))),
              );
            },
            leading: CircleAvatar(
              backgroundColor: Color(0xff055BA6),
              child: Text(
                "${index + 1}",
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
                quran.getSurahName(index + 1) +
                    "|" +
                    quran.getSurahNameArabic(index + 1),
                style: TextStyle(fontFamily: 'alq')),
            subtitle: Text(
              "مشاري بن راشد العفاسي",
              style: TextStyle(fontFamily: 'jameel', color: Color(0Xff0367A6)),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                quran.getPlaceOfRevelation(index + 1) == 'Makkah'
                    ? Image.asset('images/kaaba.png', width: 30, height: 30)
                    : Image.asset('images/madina.png', width: 30, height: 30),
                Text(
                  "verses" + quran.getVerseCount(index + 1).toString(),
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: 114,
    ));
  }
}

class QuranAudio extends StatefulWidget {
  final Surahindex name;
  QuranAudio({Key? key, required this.name}) : super(key: key);

  @override
  State<QuranAudio> createState() => _QuranAudioState();
}

class _QuranAudioState extends State<QuranAudio> {
  AudioPlayer audioplayer = AudioPlayer();
  IconData playpauseButton = Icons.play_circle_fill_rounded;
  bool isplaying = false;

  Future<void> togglebutton() async {
    try {
      final audiourl = await quran.getAudioURLBySurah(widget.name.numm);
      audioplayer.setUrl(audiourl);
      print(audiourl);

      if (isplaying) {
        audioplayer.play();
        setState(() {
          playpauseButton = Icons.pause_circle_rounded;

          isplaying = false;
        });
      } else {
        audioplayer.pause();
        setState(() {
          playpauseButton = Icons.play_circle_fill_rounded;

          isplaying = true;
        });
      }
    } catch (e) {
      print("my error=>${e}");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose

    audioplayer.dispose();
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
                          style: const TextStyle(
                              fontFamily: 'alq',
                              fontSize: 15,
                              color: Colors.white)),
                      Text(widget.name.englishNameTranslation,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: 'alq', color: Colors.white)),
                    ],
                  ),
                  title: Text(widget.name.urname,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                          fontFamily: 'alq', color: Colors.white)),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                                radius: 100,
                                backgroundColor: Color.fromARGB(255, 0, 63, 118),
                                // backgroundImage:AssetImage("images/alaffasy.png")
                                
                             backgroundImage:     NetworkImage(
                                    'https://2.bp.blogspot.com/-RLU-DkUOWHA/ViKoDh2NjcI/AAAAAAAAFZY/hIybzxypiXQ/s1600/ALAFASY.png',
                                    scale: 1)
                                    
                                    
                                    
                                    
                                    
                                    )
                                    ,
                    ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Text(
                                "سورۃ" +
                                    quran.getSurahNameArabic(widget.name.numm) +
                                    " كاملۃ\n بصوت الشيخ مشاري العفاسي",
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'alq',
                                  color: Color.fromARGB(255, 0, 63, 118),
                                )),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 6,
                        shadowColor: Colors.indigo[900],
                        child: Center(
                          child: IconButton(
                              icon: Icon(
                                playpauseButton,
                                color: Colors.indigo[900],
                              ),
                              onPressed: togglebutton),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
