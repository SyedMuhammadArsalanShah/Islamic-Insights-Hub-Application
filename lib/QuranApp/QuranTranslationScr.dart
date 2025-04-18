import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:mushaf/QuranReadScr.dart';
import 'package:quran/quran.dart' as quran;

class QuranTranslationScr extends StatefulWidget {
  const QuranTranslationScr({super.key});

  @override
  State<QuranTranslationScr> createState() => _QuranTranslationScrState();
}

class _QuranTranslationScrState extends State<QuranTranslationScr> {
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
                    builder: (context) => SurahTranslation(
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
              quran.getSurahNameEnglish(index + 1),
              style: TextStyle(fontFamily: 'alq', color: Color(0Xff0367A6)),
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

class SurahTranslation extends StatefulWidget {
  final Surahindex name;
  SurahTranslation({Key? key, required this.name}) : super(key: key);

  @override
  State<SurahTranslation> createState() => _SurahTranslationState();
}

class _SurahTranslationState extends State<SurahTranslation> {
  dynamic selectedTranslation =
      quran.Translation.enSaheeh; // Default translation
  Map<String, dynamic> translations = {
    "English (Saheeh International)": quran.Translation.enSaheeh,
    "English (Clear Quran)": quran.Translation.enClearQuran,
    "French (Muhammad Hamidullah)": quran.Translation.frHamidullah,
    "Turkish": quran.Translation.trSaheeh,
    "Malayalam": quran.Translation.mlAbdulHameed,
    "Farsi": quran.Translation.faHusseinDari,
    "Portuguese": quran.Translation.pt,
    "Italian": quran.Translation.itPiccardo,
    "Dutch": quran.Translation.nlSiregar,
    "Russian": quran.Translation.ruKuliev
  };

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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<dynamic>(
                  icon: Icon(
                    Icons.arrow_drop_down_circle,
                    size: 16,
                  ),
                  isDense: true,
                  iconSize: 16,
                  value: selectedTranslation,
                  items: translations.entries.map((entry) {
                    return DropdownMenuItem<dynamic>(
                      value: entry.value,
                      child: Text(entry.key),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTranslation = value!;
                    });
                  },
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
                child: ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                    margin: const EdgeInsets.all(10),
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white)),
                    child: ListTile(
                      // onTap: () {},

                      title: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child:
                            quran.isSajdahVerse(widget.name.numm, index + 1) ==
                                    true
                                ? Text(
                                    quran.getVerse(widget.name.numm, index + 1,
                                            verseEndSymbol: true) +
                                        "" +
                                        quran.sajdah,
                                    textDirection: TextDirection.rtl,
                                    style: GoogleFonts.amiriQuran(
                                        fontSize: 20,
                                     
                                        color: Colors.green),
                                  )
                                : Text(
                                    quran.getVerse(widget.name.numm, index + 1,
                                        verseEndSymbol: true),
                                    textDirection: TextDirection.rtl,
                                    style: GoogleFonts.amiriQuran(
                                        fontSize: 20,
                                        color: Color.fromARGB(255, 0, 63, 118)),
                                  ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child:
                            quran.isSajdahVerse(widget.name.numm, index + 1) ==
                                    true
                                ? Text(
                                    quran.getVerseTranslation(widget.name.numm, index + 1,
                                            
                                            translation: selectedTranslation) +
                                        "" +
                                        quran.sajdah,
                                    // textDirection: TextDirection.rtl,
                                    style: GoogleFonts.roboto(
                                        fontSize: 15,
                                       
                                        color: Colors.green),
                                  )
                                : Text(
                                    quran.getVerseTranslation(widget.name.numm, index + 1,
                                      translation: selectedTranslation
                                      ),
                                    // textDirection: TextDirection.rtl,
                                    style: GoogleFonts.roboto(
                                        fontSize: 15,
                                     
                                        color: Color.fromARGB(255, 0, 63, 118)),
                                  ),
                      ),
                    ));
              },
              itemCount: quran.getVerseCount(widget.name.numm),
            ))
          ],
        ));
  }
}

class Surahindex {
  final int numm;
  final int nummv;
  final String namee;
  final String urname;
  final String englishNameTranslation;
  final String revelationType;
  Surahindex(this.numm, this.nummv, this.namee, this.urname,
      this.englishNameTranslation, this.revelationType);
}