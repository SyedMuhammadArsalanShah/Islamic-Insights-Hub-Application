import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import 'package:quran/quran.dart' as quran;

class QuranJuzScr extends StatefulWidget {
  const QuranJuzScr({super.key});

  @override
  State<QuranJuzScr> createState() => _QuranJuzScrState();
}

class _QuranJuzScrState extends State<QuranJuzScr> {
  List<String> arabicParahNames = [
    "ٱلٓمٓ",
    "سَيَقُولُ",
    "تِلْكَ ٱلرُّسُلُ",
    "لَنْ تَنَالُواْ",
    "وَٱلْمُحْصَنَاتُ",
    "لَا يُحِبُّ ٱللَّهُ",
    "وَإِذَا سَمِعُواْ",
    "وَلَوْ أَنَّنَا",
    "قَدْ أَفْلَحَ",
    "وَٱعْلَمُواْ",
    "يَعْتَذِرُونَ",
    "وَمَا مِن دَآبَّةٍ",
    "وَمَا أُبَرِّئُ",
    "رُبَمَا",
    "سُبْحَانَ ٱلَّذِى",
    "قَالَ أَلَمْ",
    "ٱقْتَرَبَ لِلناس",
    "قَدْ أَفْلَحَ",
    "وَقَالَ ٱلَّذِينَ",
    "أَمَّنْ خَلَقَ",
    "أُتْلُ مَا أُوحِىَ",
    "وَمَنْ يَقْنُتْ",
    "وَمَا لِىَ",
    "فَمَنْ أَظْلَمُ",
    "إِلَيْهِ يُرَدُّ",
    "حٰمٓ",
    "قَالَ فَمَا خَطْبُكُمْ",
    "قَدْ أَفْلَحَ",
    "تَبَارَكَ ٱلَّذِى",
    "عَمَّ يَتَسَآءَلُونَ"
  ];
  List<String> englishParahNames = [
    "Alif Lam Meem",
    "Sayyakool",
    "Tilkal Rusul",
    "Lan Tana Loo",
    "Wal Mohsanat",
    "La Yuhibbullah",
    "Wa Iza Sami'oo",
    "Wa Lau Annana",
    "Qad Aflaha",
    "Wa A’lamu",
    "Ya'tazerun",
    "Wa Mamin Da'abah",
    "Wa Ma Ubarri'u",
    "Rubama",
    "Subhanallazi",
    "Qal Alam",
    "Iqtaraba Lilnas",
    "Qad Aflaha",
    "Wa Qalallazina",
    "Amman Khalaq",
    "Utlu Ma Oohi",
    "Wa Manyaqnut",
    "Wa Mali",
    "Faman Azlam",
    "Ilayhi Yurad",
    "Ha Meem",
    "Qala Fama Khatbukum",
    "Qad Aflaha",
    "Tabarakallazi",
    "Amma Yatasa'aloon"
  ];

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
                    builder: (context) => JuzRead(
                        name: JuzIndex(index + 1, arabicParahNames[index],
                            englishParahNames[index]))),
              );
            },
            leading: CircleAvatar(
              backgroundColor: Color(0xff055BA6),
              child: Text(
                "${index + 1}",
                style: TextStyle(color: Colors.white),
              ),
            ),
            title:
                Text(arabicParahNames[index], style: GoogleFonts.amiriQuran()),
            subtitle: Text(
              englishParahNames[index],
              style: GoogleFonts.amiriQuran(color: Color(0Xff0367A6)),
            ),
          ),
        );
      },
      itemCount:quran.totalJuzCount,
    ));
  }
}

class JuzRead extends StatefulWidget {
  final JuzIndex name;
  JuzRead({Key? key, required this.name}) : super(key: key);

  @override
  State<JuzRead> createState() => _JuzReadState();
}

class _JuzReadState extends State<JuzRead> {
  List<Map<String, int>> surahVerseList = [];

  @override
  void initState() {
    super.initState();
    loadVerses();
  }

  void loadVerses() {
    // Assuming getSurahAndVersesFromJuz returns a map where the key is the Surah number
    // and the value is a list containing the first and last verse number [first, last]
    Map<int, List<int>> surahVerseMap =
        quran.getSurahAndVersesFromJuz(widget.name.numm);

    // Clear previous data
    surahVerseList.clear();

    // Iterate through the map to generate a complete list of Surah and Verse pairs
    surahVerseMap.forEach((surah, verses) {
      int firstVerse = verses[0]; // Start of the range
      int lastVerse = verses[1]; // End of the range

      // Generate a list of verses from firstVerse to lastVerse
      for (var verse = firstVerse; verse <= lastVerse; verse++) {
        surahVerseList.add({'surah': surah, 'verse': verse});
      }
    });

    setState(() {}); // Update the UI after data is loaded
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
                  subtitle: Text(widget.name.englishNameTranslation,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontFamily: 'alq', color: Colors.white)),
                  title: Text(widget.name.namee,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                          fontFamily: 'alq', color: Colors.white)),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: widget.name.numm != 9
                    ? Text(
                        quran.basmala,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                            fontSize: 25,
                            fontFamily: 'alq',
                            color: Color.fromARGB(255, 0, 63, 118)),
                      )
                    : Container()),
            Expanded(
                child: surahVerseList.isNotEmpty
                    ? ListView.builder(
                        itemCount: surahVerseList.length,
                        itemBuilder: (context, index) {
                          int surahNumber = surahVerseList[index]['surah']!;
                          int verseNumber = surahVerseList[index]['verse']!;

                          return Card(
                              margin: const EdgeInsets.all(10),
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.white)),
                              child: ListTile(
                                  // onTap: () {},

                                  subtitle: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: quran.isSajdahVerse(
                                                  widget.name.numm,
                                                  index + 1) ==
                                              true
                                          ? Text(
                                              quran.getVerse(
                                                      surahNumber, verseNumber,
                                                      verseEndSymbol: true) +
                                                  "" +
                                                  quran.sajdah,
                                              textDirection: TextDirection.rtl,
                                              style: const TextStyle(
                                                  fontSize: 25,
                                                  fontFamily: 'alq',
                                                  color: Colors.green),
                                            )
                                          : Text(
                                              quran.getVerse(
                                                  surahNumber, verseNumber,
                                                  verseEndSymbol: true),
                                              textDirection: TextDirection.rtl,
                                              style: GoogleFonts.amiriQuran(
                                                  fontSize: 25,
                                                  color: Color.fromARGB(
                                                      255, 0, 63, 118)),
                                            )),
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'سورۃ نمبر $surahNumber, آیت نمبر $verseNumber',
                                      style: TextStyle(fontFamily: "jameel",
                                      
                                       color: Colors.indigo[900]
                                      ),
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                    ),
                                  )));
                        })
                    : Center(child: CircularProgressIndicator()))
          ],
        ));
  }
}

class JuzIndex {
  final int numm;
  final String namee;
  final String englishNameTranslation;
  JuzIndex(this.numm, this.namee, this.englishNameTranslation);
}
