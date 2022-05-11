//Sprache
import 'dart:convert'; //Die String/language files brauchen jede Menge imports
import 'dart:core';
import 'dart:math';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart'; // Um Rotation festzulegen. Flutter Native... + Sprache
//Sprache ende

import 'package:flutter/material.dart';
import 'package:klosterguide/spenden.dart';
import 'package:klosterguide/splash.dart';
import 'navigation_tourauswahl.dart';
import 'discover.dart';
import 'impressum.dart';
import 'map.dart';
import 'constants.dart';

// Teilen

import 'package:share/share.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Rotation festlegen

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      locale: const Locale("de"), //Hier Sprache angeben
      localizationsDelegates: const [
        DemoLocalizationsDelegate(),
        GlobalMaterialLocalizations
            .delegate, //Flutter sagt man braucht das, Stackoverflow typ hat das nicht gesagt
        GlobalWidgetsLocalizations.delegate, // "
        GlobalCupertinoLocalizations.delegate,
      ], // "
      supportedLocales: const [
        Locale('de', ''),
        //Locale('en', '')
      ], // Erstmal nur Deutsch hinzufügen. Sonst Kommentar entfernen. (UNTEN AUCH!)
      title: 'Klosterführer',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: SplashScreen(),
    );
  }
}

//Sprachzeug

//Habe alles kommentiert, was ich von der Stackoverflow-Version geändert habe

class DemoLocalizations {
  static DemoLocalizations? of(BuildContext context) {
    //Fragezeichen musste hinzugefügt werden
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations);
  }

  String getText(String key) => language![key]; //! eingefügt
}

Map<String, dynamic>? language; //? eingefügt

class DemoLocalizationsDelegate
    extends LocalizationsDelegate<DemoLocalizations> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => [
        'de',
        //'en',                           FÜR EN entfernen
      ].contains(
          locale.languageCode); //Hier können neue Sprachen hinzugefügt werden

  @override
  Future<DemoLocalizations> load(Locale locale) async {
    String string = await rootBundle
        .loadString("assets/strings/${locale.languageCode}.json");
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
  void AppBarSelect(item) {
    switch (item) {
      case 'Spenden':
        {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Spenden()));
        }
        break;
      case 'Info':
        break;
      case 'Impressum':
        {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Impressum()));
        }
        break;
      case 'Teilen':
        {
          Share.share(
              'Hi! Schau mal was ich gefunden habe: https://klosterguide.page.link/download',
              subject: 'Schau was ich gefunden habe');
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: appbarcolor,
          title: FittedBox(
              fit: BoxFit.fill,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 200, horizontal: (MediaQuery.of(context).size.width<=600)? 0 : MediaQuery.of(context).size.width),
                child: Text(
                  widget.title,
                  style: const TextStyle(fontSize: 200),
                ),
              )), //text standartmäßig extrem groß. wird dann an Gerät angepasst
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Image.asset("assets/icons/app2.png"),
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
                color: popupbuttoncolor,
                onSelected: AppBarSelect,
                itemBuilder: (BuildContext context) {
                  return [
                    'Spenden',
                    'Teilen',
                    'Impressum',
                  ].map((String choice) {
                    return PopupMenuItem<String>(
                      child: Text(choice),
                      value: choice,
                    );
                  }).toList();
                }),
          ],
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Container(
          color: primarybackgroundcolor,
          child: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                // Test: Eventuell ist center besser
                children: <Widget>[
                  // Tour
                  const SizedBox(height: 30),
                  buildunifinishedcard(
                      "assets/home/002.jpg",
                      DemoLocalizations.of(context)!
                          .getText("mainscreentext1"), //"?? "Error"" entfernt
                      DemoLocalizations.of(context)!
                          .getText("mainscreentext1info"),
                      "tour"),
                  SizedBox(height: 20 * MediaQuery.of(context).size.width * 0.002),

                  // Discover
                  buildunifinishedcard(
                      "assets/home/083.jpg",
                      DemoLocalizations.of(context)!.getText("mainscreentext2"),
                      DemoLocalizations.of(context)!
                          .getText("mainscreentext2info"),
                      "discover"),
                  SizedBox(height: 20 * MediaQuery.of(context).size.width * 0.002),

                  // Längenschnitt
                  buildunifinishedcard(
                      "assets/home/039.jpg",
                      DemoLocalizations.of(context)!.getText("mainscreentext3"),
                      DemoLocalizations.of(context)!
                          .getText("mainscreentext3info"),
                      "map"),
                  const SizedBox(height: 30),
                ],
              ),
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
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24,horizontal: 16 * pow(MediaQuery.of(context).size.width,2) * 0.000006),
          child: Container(
            padding: const EdgeInsets.all(24),
            width: 600 * MediaQuery.of(context).size.width * 0.002,
            height: 200 * MediaQuery.of(context).size.width * 0.002,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                  alignment: (option == "map")
                      ? const Alignment(0.00, -0.70)
                      : const Alignment(0.00, 0.00),
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
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: mainbuttontextcolor,
                    )),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(fontSize: 20, color: mainbuttontextcolor),
                )
              ],
            ),
          ),
        ));
  }
}
