//import 'dart:async'; Ist für regelmäßige Positionsabfrage nötig. Zurzeit unnötig. NICHT LÖSCHEN! ~ Lukas

// Video shit
import 'dart:io'; // Um Dateien einzulesen (Videos...)
import 'package:path_provider/path_provider.dart'; // Gibt Pfad an in dem die Videos sind

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:klosterguide/constants.dart';
import 'package:klosterguide/touren.dart';
import 'package:latlong2/latlong.dart';

//import 'package:geolocator/geolocator.dart'; Ist für regelmäßige Positionsabfrage nötig. Zurzeit unnötig. NICHT LÖSCHEN! ~ Lukas

import 'globals.dart' as globals;
import 'data.dart';
import 'navigation_detail_page.dart';
import 'StationAssetVideo.dart';

class Navigation extends StatefulWidget {
  //State*ful* Widget, deswegen werden die folgenen Variablen immer mit widget.[var] angegeben
  final List tourlist;
  final int index;
  final bool mapvideo;

  const Navigation(
      {Key? key,
      required this.tourlist,
      required this.index,
      required this.mapvideo})
      : super(key: key);
  //Übergabe Variablen beim Erstellen

  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<Navigation> {
  bool _visible =
      true; //_visible bestimmt, ob das Navigationsvideo angezeigt wird

  Future<File> getFile(filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = directory.path + "/Klosterguide-Videos-main" + filename;
    print("Dateipfad: " + filePath);
    return File(filePath);
  }

  @override
  Widget build(BuildContext context) {
    final StationInfo stationInfo = stationen[widget.tourlist[widget.index]];

    //Welche Tour wird angezeigt
    if (widget.tourlist == tour_lang) {
      globals.letzteposition = widget.index;
    }
    if (widget.tourlist == tour_mittel) {
      globals.letztepositionmittel = widget.index;
    }
    // StreamSubscription<Position> positionStream =
    //     Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high)
    //         .listen((Position position) {
    //   if (position != null) {
    //     //TODO: Check if position in range... // Das isses. Das Skript, dass die Position gibt: position.latitude.toString() + position.longitude.toString()
    //   }
    //});

    return Scaffold(

        ///App-Bar

        appBar: AppBar(
          automaticallyImplyLeading:
              false, // Kein Automatischer Home Knopf in App Bar
          title: const Text(
            'Tour',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: appbarcolor,
          //Home-Button
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.home),
          ),
        ),

        ///Weiter-Knopf

        floatingActionButtonLocation: FloatingActionButtonLocation
            .centerDocked, //ButtonPosition wird von der Mitte des Bildschirms berechnet
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(16.0), //Padding Größe
          child: Stack(children: [
            //Der Mapvideo Ein/Aus Button
            AnimatedPositioned(
              //Bewegung des Buttons wird animiert
              duration: const Duration(milliseconds: 230),
              bottom:
                  (_visible) //_visible: Ob Mapvideo minimiert ist oder nicht
                      //Höhe des Buttons wenn _visible true ist:
                      ? (MediaQuery.of(context).size.width - 50 >=
                              270 * MediaQuery.of(context).size.height * 0.002)
                          ? 147 * MediaQuery.of(context).size.height * 0.002
                          : (MediaQuery.of(context).size.width - 50) *
                              (147 / 270)
                      //Höhe des Buttons wenn _visible false ist:
                      : 15,
              left: (MediaQuery.of(context).size.width / 2) - 40,
              child: SizedBox(
                height: 40,
                width: 60,
                child: (stationen[widget.index].mapvideo != "" &&
                        widget.mapvideo &&
                        widget.tourlist[widget.index] + 1 ==
                            widget.tourlist[widget.index + 1])
                    //Das dritte if-statement checkt, ob die darauffolgende Station auch die darauffolgende Nummer hat,
                    //denn wir wollen kein Video wenn nach Station 5 Station 8 folgt
                    ? FloatingActionButton(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        )),
                        onPressed: () {
                          setState(() {
                            _visible = !_visible;
                          }); //Änderung der Stateful-Variable _visible
                        },
                        child: Icon((_visible) ? Icons.remove : Icons.add),
                        backgroundColor: primarymapbuttoncolor,
                      )
                    : Container(),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, //Abstand zwischen Buttons
                  children: <Widget>[
                    _getZurueckButton(context, stationInfo, widget.mapvideo),
                    (widget.mapvideo) //hä
                        ? FloatingActionButton(
                            //Buttons rechts
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, a, b) => DetailPage(
                                    //stationInfo: stationen[stationInfo.position - 1],
                                    tourlist: widget.tourlist,
                                    index: widget.index,
                                    mapvideo: widget.mapvideo,
                                  ),
                                  transitionsBuilder:
                                      (context, anim, b, child) =>
                                          FadeTransition(
                                              opacity: anim, child: child),
                                  transitionDuration:
                                      Duration(milliseconds: animationlength),
                                ),
                              );
                            },
                            child: const Icon(Icons.navigate_next),
                            backgroundColor: primarymapbuttoncolor,
                          )
                        : Container()
                  ],
                ),
              ],
            ),
          ]),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ///Mapcontainer
            FlutterMap(
              options: MapOptions(
                  center: LatLng(51.07594003947888, 6.753587966358769),
                  zoom: 15.7,
                  minZoom: 14,
                  maxZoom: 18,
                  swPanBoundary: LatLng(
                    51.0727696061025,
                    6.74033047115352,
                  ),
                  nePanBoundary: LatLng(51.0834444361947, 6.76094581023449),
                  plugins: [const LocationMarkerPlugin()]),
              layers: [
                TileLayerOptions(
                  tileProvider: const AssetTileProvider(),
                  maxZoom: 18.0,
                  urlTemplate: 'assets/map/{z}/{x}/{y}.png',
                ),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 50.0,
                      height: 50.0,
                      point: LatLng(stationInfo.xcoord, stationInfo.ycoord),
                      builder: (ctx) => ClipRRect(
                        borderRadius: BorderRadius.circular(72.5),
                        child: Image.asset(stationInfo.iconImage,
                            width: 200, height: 200),
                      ),
                    ),
                  ],
                ),
                LocationMarkerLayerOptions(),
              ],
            ),

            ///Der Mapvideo Container:
            (widget.mapvideo &&
                    stationen[widget.index].mapvideo != "" &&
                    widget.tourlist[widget.index] + 1 ==
                        widget.tourlist[widget.index + 1])
                ? Positioned(
                    bottom: 10,
                    child: AnimatedOpacity(
                        opacity: _visible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          //Passt die Mapvideo Größe der Bildschirmhöhe an, außer wenn es die Breite übersteigen würde, dann wird es nach der Breite angepasst
                          //Kann evtl. überarbeitet werden
                          //Wenn sich Videoformate ändern, müssen sie hier seperat nochmal geändert werden
                          width: (MediaQuery.of(context).size.width - 50 >=
                                  270 *
                                      MediaQuery.of(context).size.height *
                                      0.002)
                              ? 270 * MediaQuery.of(context).size.height * 0.002
                              : MediaQuery.of(context).size.width - 50,
                          height: (MediaQuery.of(context).size.width - 50 >=
                                  270 *
                                      MediaQuery.of(context).size.height *
                                      0.002)
                              ? 147 * MediaQuery.of(context).size.height * 0.002
                              : (MediaQuery.of(context).size.width - 50) *
                                  (147 / 270),
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 10.0,
                                    spreadRadius: 0.1)
                              ]),
                          child: Container(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: // Wartet auf Pfad, in dem die Videos sind und zeigt dann das Video
                                FutureBuilder<File?>(
                              future: getFile(stationen[widget.index].mapvideo),
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
                          ),
                        )),
                  )
                : Container(), //Sonst wird einfach ein leerer Container übergeben
          ],
        ));
  }

  Widget _getZurueckButton(
      BuildContext context, StationInfo stationInfo, bool mapvideo) {
    if (widget.index == 0) {
      //Bei Station 1 verschwindet der Button
      return FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: (mapvideo)
            ? const Icon(Icons.home)
            : const Icon(Icons.navigate_before),
        backgroundColor: primarymapbuttoncolor,
      ); //Wenn mit "Container();" ersetzt, gibt es gar keinen Button(wird Probleme beim positionieren geben)
    } else {
      return FloatingActionButton(
        //Button links
        onPressed: () {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, a, b) => DetailPage(
                //stationInfo: stationen[stationInfo.position -2], //Nummerrierung muss überarbeitet werden
                tourlist: widget.tourlist,
                index: widget.index - 1,
                mapvideo: widget.mapvideo,
              ),
              transitionsBuilder: (context, anim, b, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: animationlength),
            ),
          );
        },
        child: const Icon(Icons.navigate_before),
        backgroundColor: primarymapbuttoncolor,
      );
    }
  }
}
