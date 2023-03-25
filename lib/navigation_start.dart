import 'dart:io'; // Um Dateien einzulesen (Videos...)
import 'package:path_provider/path_provider.dart'; // Gibt Pfad an in dem die Videos sind

import 'package:flutter/material.dart';
import 'main.dart';
import 'constants.dart';

// Um Rotation festzulegen. Flutter Native...

import 'navigation.dart';
import 'StationAssetVideo.dart';

class NavStart extends StatelessWidget {
  final List tourlist;
  final String laenge;
  final bool mapvideo;

  const NavStart(
      {Key? key,
      required this.tourlist,
      required this.mapvideo,
      required this.laenge})
      : super(key: key);

  Future<File> getFile(filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = directory.path + "/Klosterguide-Videos-main" + filename;
    print("Dateipfad: " + filePath);
    return File(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, //Abstand zwischen Buttons
            children: <Widget>[
              Align(
                alignment: Alignment.bottomLeft,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.home),
                  backgroundColor: primarymapbuttoncolor,
                  label: const Text('Home'),
                ),
              ),
              // const SizedBox(width: 105),
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Navigation(
                                  tourlist: tourlist,
                                  index: 0,
                                  mapvideo: mapvideo,
                                )));
                  },
                  icon: const Icon(Icons.navigate_next),
                  backgroundColor: primarymapbuttoncolor,
                  label: const Text('Weiter'),
                ),
              ),
            ]),
      ),
      backgroundColor: secondarybackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Icon Image der Station

                  // Align(
                  //   alignment: Alignment.center,
                  //   child: ClipRRect(
                  //       borderRadius: BorderRadius.circular(72.5),
                  //       child: Image.asset("assets/icons/app2.png",
                  //           width: 200,
                  //           height: 200,
                  //           alignment: Alignment.center)),
                  // ),
                  // Stationsname, "Knechtsteden"

                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Willkommen",
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 40,
                            color: primaryTextColor,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          (laenge == "lang")
                              ? 'zur ausführlichen Tour'
                              : 'zur kurzen Tour',
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 25,
                            color: primaryTextColor,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Divider(color: endcardTextColor),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                    child: Text(
                        DemoLocalizations.of(context)!
                            .getText("willkommeninfo"),
                        style: TextStyle(
                          fontFamily: 'Avenir',
                          fontSize: 20,
                          color: contentTextColor,
                          fontWeight: FontWeight.w500,
                        )),
                  ),

                  const SizedBox(height: 25),

                  // Wartet auf Pfad, in dem die Videos sind und zeigt dann das Video
                  FutureBuilder<File?>(
                    future: getFile("/guidevideos/Tourstart.mp4"),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      final file = snapshot.data;
                      if (file != null) {
                        return StationAssetVideo(
                            videopath: file); // Video: Klassen unten
                      } else {
                        return const Text('File not found');
                      }
                    },
                  ),
                  // Detaillierte Beschreibung

                  ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    title: Text(
                      'Textfassung',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 25,
                        color: endcardTextfassungColor,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    children: <Widget>[
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                        child: Text(
                          DemoLocalizations.of(context)!
                              .getText("willkommentext"),
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 20,
                            color: contentTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                  const SizedBox(height: 35),

                  const SizedBox(height: 75),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
