import 'package:flutter/material.dart';
import 'package:klosterguide/navigation_endcard.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';
import 'navigation.dart';
import 'data.dart';
import 'dart:io'; // Um files einzulesen
import 'constants.dart';

// Um Rotation festzulegen. Flutter Native...

import 'StationAssetVideo.dart';

class DetailPage extends StatelessWidget {
  final List tourlist;
  final int index;
  final bool mapvideo;

  const DetailPage(
      {Key? key,
      required this.tourlist,
      required this.index,
      required this.mapvideo})
      : super(key: key);

  Widget _getWeiterButton(BuildContext context, StationInfo stationInfo) {
    return Visibility(
        child: FloatingActionButton(
      onPressed: () {
        // Dann ist es der Location Marker
        if (tourlist.length <= 2) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, a, b) => Navigation(
                tourlist: tourlist,
                index: index,
                mapvideo: mapvideo,
              ),
              transitionsBuilder: (context, anim, b, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: animationlength),
            ),
          );
        }
        if (tourlist[index + 1] != 0) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, a, b) => Navigation(
                tourlist: tourlist,
                index: index + 1,
                mapvideo: mapvideo,
              ),
              transitionsBuilder: (context, anim, b, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: animationlength),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, a, b) => const Endcard(),
              transitionsBuilder: (context, anim, b, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: animationlength),
            ),
          );
        }
      },
      child: tourlist.length >= 2
          ? const Icon(Icons.navigate_next)
          : const Icon(Icons.location_on),
      backgroundColor: primarymapbuttoncolor,
    ));
  }

  Widget _getZurueckButton(BuildContext context, StationInfo stationInfo) {
    return FloatingActionButton(
      onPressed: () {
        if (tourlist.length <= 2) {
          // Falls die Liste kürzer ist, handelt es sich um keine Tour. Daher, gibt es keine Vorherige Station
          Navigator.pop(context);
          return;
        }
        if (tourlist[index + 1] != 0) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, a, b) => Navigation(
                tourlist: tourlist,
                index: index,
                mapvideo: mapvideo,
              ),
              transitionsBuilder: (context, anim, b, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: animationlength),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, a, b) => const Endcard(),
              transitionsBuilder: (context, anim, b, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: animationlength),
            ),
          );
        }
      },
      child: const Icon(Icons.navigate_before),
      backgroundColor: primarymapbuttoncolor,
    );
  }

  Future<File> getFile(filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = directory.path + "/Klosterguide-Videos-main" + filename;
    print("Dateipfad: " + filePath);
    return File(filePath);
  }

  @override
  Widget build(BuildContext context) {
    final StationInfo stationInfo = stationen[tourlist[index]];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // Kein Automatischer Home Knopf in App Bar
        title: const Text(
          'Tour',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: appbarcolor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.home),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerDocked, //Position wird von der Mitte des Bildschirms berechnet
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0), //Padding Größe
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, //Abstand zwischen Buttons
          children: <Widget>[
            _getZurueckButton(context, stationInfo),
            _getWeiterButton(context, stationInfo),
          ],
        ),
      ),

      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            // Graue Stationsnummer im Hinergrund

            Positioned(
              top: -20,
              left: 4,
              child: Text(
                stationInfo.position.toString(),
                style: (stationInfo.position >
                        9) // Falls Nummer größer als 9 ist die Zahl zweistellig
                    ? TextStyle(
                        letterSpacing:
                            -25, // Daher, sollen die Zahlen dann näher an einander
                        fontFamily: 'Avenir',
                        fontSize: 248,
                        color: primaryTextColor.withOpacity(0.08),
                        fontWeight: FontWeight.w900,
                      )
                    : TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 500,
                        color: primaryTextColor.withOpacity(0.08),
                        fontWeight: FontWeight.w900,
                      ),
                textAlign: TextAlign.left,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Icon Image der Station

                  const SizedBox(height: 50),
                  Align(
                      alignment: const Alignment(0.75, 0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(72.5),
                          child: Image.asset(stationInfo.iconImage,
                              width: 150, height: 150))),

                  // Stationsname
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          stationInfo.name,
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 36,
                            color: primaryTextColor,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.black38),
                      ],
                    ),
                  ),

                  // Video: Klassen unten

                  // Wartet auf Pfad, in dem die Videos sind und zeigt dann das Video
                  FutureBuilder<File?>(
                    future: getFile(stationInfo.video),
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
                    title: const Text(
                      'Textfassung',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 25,
                        color: Color(0xff47455f),
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    children: <Widget>[
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                        child: Text(
                          stationInfo.fulltext,
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

                  // Zusatzinfos
                  (stationInfo.zusatzvideo != "")
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(color: Colors.black38),
                            const SizedBox(height: 32),
                            Padding(
                              // Überschrift Zusatzinfos:

                              padding: const EdgeInsets.only(left: 15.0),
                              // ignore: unnecessary_null_comparison
                              child: Text(
                                stationInfo.zusatztitel,
                                style: const TextStyle(
                                  fontFamily: 'Avenir',
                                  fontSize: 25,
                                  color: Color(0xff47455f),
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            const SizedBox(height: 15),

                            // ========================================= Zusatzinfos

                            // Video mit Zusatzinfos:

                            FutureBuilder<File?>(
                              future: getFile(stationInfo.zusatzvideo),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
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

                            // Ausklappbarer Text mit Zusatzinfos:
                            ExpansionTile(
                              tilePadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              title: const Text(
                                'Textfassung',
                                style: TextStyle(
                                  fontFamily: 'Avenir',
                                  fontSize: 25,
                                  color: Color(0xff47455f),
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              children: <Widget>[
                                const SizedBox(height: 32),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 32.0, right: 32.0),
                                  child: Text(
                                    stationInfo.zusatztext,
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                                      fontSize: 20,
                                      color: contentTextColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                                const SizedBox(height: 70),
                              ],
                            ),
                            const SizedBox(height: 70),
                          ],
                        )
                      : const SizedBox(height: 70),
                  (index == 13)
                      ? Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
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
                                      child: const Text(
                                        'Speisekarte Klosterhof',
                                        textAlign: TextAlign.center,
                                      )),
                                  onPressed: () {
                                    launch(DemoLocalizations.of(context)!
                                        .getText("speisekartelink"));
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          )
                        ])
                      : Container()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
