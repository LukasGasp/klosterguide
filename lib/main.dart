//Sprache
import 'dart:convert'; //Die String/language files brauchen jede Menge imports
import 'dart:core';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
//Sprache ende
import 'package:flutter/material.dart';
import 'guideactivity.dart';
import 'discover.dart';
import 'map.dart';
import 'constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale("de"), //Hier Sprache angeben
      localizationsDelegates: [
        const DemoLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate, //Flutter sagt man braucht das, Stackoverflow typ hat das nicht gesagt
        GlobalWidgetsLocalizations.delegate, // "
        GlobalCupertinoLocalizations.delegate,], // "
      supportedLocales: [const Locale('en', ''), const Locale('de', '')],
      title: 'Klosterführer',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: const MyHomePage(title: 'Klosterführer Knechtsteden'),
    );
  }
}

//Sprachzeug

//Habe alles kommentiert, was ich von der Stackoverflow-Version geändert habe

class DemoLocalizations {
  static DemoLocalizations? of(BuildContext context) { //Fragezeichen musste hinzugefügt werden
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations);
  }

  String getText(String key) => language![key]; //! eingefügt
}


Map<String, dynamic>? language; //? eingefügt


class DemoLocalizationsDelegate extends LocalizationsDelegate<DemoLocalizations> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'de'].contains(locale.languageCode); //Hier können neue Sprachen hinzugefügt werden

  @override
  Future<DemoLocalizations> load(Locale locale) async {
    String string = await rootBundle.loadString("assets/strings/${locale.languageCode}.json");
    language = jsonDecode(string);
    return SynchronousFuture<DemoLocalizations>(DemoLocalizations());
  }

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}



//Sprachzeug Ende


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appbarcolor,
          title: Text(widget.title),
        ),
        body: Container(
          color: primarybackgroundcolor,
          child: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              // Test: Eventuell ist center besser
              children: <Widget>[
                // Tour
                buildunifinishedcard("assets/home/002.jpg", DemoLocalizations.of(context)!.getText("text2"), //"?? "Error"" entfernt
                    'Lassen sie sich durch Knechtsteden führen', "tour"),
                const SizedBox(height: 50),

                // Discover
                buildunifinishedcard("assets/home/083.jpg", "Entdecken",
                    "Entdecken sie die vielen Wunder", "discover"),
                const SizedBox(height: 50),

                // Längenschnitt
                buildunifinishedcard("assets/home/039.jpg", "Karte",
                    "Eine detaillierte Karte Knechtstedens", "map")
              ],
            ),
          ),
        ));
  }

  void makesnackbar(String text) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 1),
      content: Text(text),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void menueclick(String onclick) {
    switch (onclick) {
      case "tour":
        {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Guideactivity()));
        }
        break;
      case "discover":
        {
          //Body of value2
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Discoverpage()));
        }
        break;
      case "map":
        {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Karte()));
        }
        break;
    }
  }

  Widget buildunifinishedcard(
      String imagepath, String title, String description, String option) {
    return GestureDetector(
        onTap: () {
          menueclick(option);
        },
        child: Container(
          padding: const EdgeInsets.all(24),
          width: MediaQuery.of(context).size.width - 12,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
                image: AssetImage(imagepath),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.25),
                  BlendMode.darken,
                )),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              )
            ],
          ),
        ));
  }
}
