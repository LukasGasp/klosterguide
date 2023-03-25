import 'dart:io'; // Um Dateien einzulesen (Videos...)
import 'package:path_provider/path_provider.dart'; // Gibt Pfad an in dem die Videos sind

import 'package:flutter/material.dart';
import 'main.dart';
import 'constants.dart';
import 'package:url_launcher/url_launcher.dart';

// Um Rotation festzulegen. Flutter Native...

import 'StationAssetVideo.dart';

class Endcard extends StatelessWidget {
  const Endcard({Key? key}) : super(key: key);

  Future<File> getFile(filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = directory.path + "/Klosterguide-Videos-main" + filename;
    print("Dateipfad: " + filePath);
    return File(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.home),
        backgroundColor: primarymapbuttoncolor,
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

                  Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(72.5),
                        child: Image.asset("assets/icons/app2.png",
                            width: 250,
                            height: 250,
                            alignment: Alignment.center)),
                  ),
                  // Stationsname, "Knechtsteden"

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Text(
                            "Abschied",
                            style: TextStyle(
                              fontFamily: 'Avenir',
                              fontSize: 50,
                              color: primaryTextColor,
                              fontWeight: FontWeight.w900,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Divider(color: endcardTextColor),
                      ],
                    ),
                  ),

                  // Video: Klassen unten

                  // Wartet auf Pfad, in dem die Videos sind und zeigt dann das Video
                  FutureBuilder<File?>(
                    future: getFile("/guidevideos/Endcard.mp4"),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      final file = snapshot.data;
                      if (file != null) {
                        return StationAssetVideo(videopath: file);
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
                          DemoLocalizations.of(context)!.getText(
                              "endcard"), //Es wird sogar ein womöglicher englischer Text geladen
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 20,
                            color: contentTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  // Knöpfe

                  // Knöpfe

                  Divider(color: endcardTextColor),
                  const SizedBox(height: 55),

                  Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        //Feedback und Kontakt
                        height: 60,
                        width: 200,
                        child: FloatingActionButton(
                          backgroundColor: primarybuttoncolor,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          )),
                          child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                DemoLocalizations.of(context)!
                                    .getText("endcard1stbutton"),
                                textAlign: TextAlign.center,
                              )),
                          onPressed: () {
                            launch(DemoLocalizations.of(context)!
                                .getText("kontaktlink"));
                          },
                        ),
                      )),
                  const SizedBox(height: 55),

                  Center(
                    child: Text(
                      DemoLocalizations.of(context)!.getText("endcard2ndtitle"),
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 42,
                        color: primaryTextColor,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Divider(color: endcardTextColor),
                  const SizedBox(height: 25),

                  Row(
                    //Spenden
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(children: [
                        SizedBox(
                          height: 50,
                          width: (MediaQuery.of(context).size.width >= 500)
                              ? 180
                              : MediaQuery.of(context).size.width * 180 * 0.002,
                          child: FloatingActionButton(
                            backgroundColor: primarybuttoncolor,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            )),
                            child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  DemoLocalizations.of(context)!
                                      .getText("endcard2ndbutton"),
                                  textAlign: TextAlign.center,
                                )),
                            onPressed: () {
                              launch(DemoLocalizations.of(context)!
                                  .getText("spendenlinkmh"));
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          child:
                              Image.asset('assets/icons/logo-missionshaus.png'),
                          height: 100,
                          width: 100,
                        ),
                      ]),
                      Column(children: [
                        SizedBox(
                          height: 50,
                          width: (MediaQuery.of(context).size.width >= 500)
                              ? 180
                              : MediaQuery.of(context).size.width * 180 * 0.002,
                          child: FloatingActionButton(
                            backgroundColor: primarybuttoncolor,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            )),
                            child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  DemoLocalizations.of(context)!
                                      .getText("endcard3rdbutton"),
                                  textAlign: TextAlign.center,
                                )),
                            onPressed: () {
                              launch(DemoLocalizations.of(context)!
                                  .getText("spendenlinkngk"));
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          child:
                              Image.asset('assets/icons/logo-ngk-campus.png'),
                          height: 100,
                          width: 100,
                        ),
                      ]),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
