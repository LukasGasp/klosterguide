import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:klosterguide/constants.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import 'data.dart';
import 'detail_page.dart';

class Navigation extends StatelessWidget {
  final StationInfo stationInfo;

  const Navigation({Key? key, required this.stationInfo}) : super(key: key);

  Widget _getZurueckButton(BuildContext context) {
    if (stationInfo.position==2) {   //Bei Station 1 verschwindet der Button
      return FloatingActionButton(onPressed: () {  },backgroundColor: primarymapbuttoncolor.withOpacity(1),); //Wenn mit "Container();" ersetzt, gibt es gar keinen Button(wird Probleme beim positionieren geben)
    } else {
      return FloatingActionButton( //Button links
        onPressed: () {
          if(stationInfo.position!=2) { ///Station 1 ist mal wieder als Position 2 bezeichnet
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, a, b) =>
                    DetailPage(
                      stationInfo: stationen[stationInfo.position - 3], //Nummerrierung muss überarbeitet werden
                    ),
              ),
            );
          }

        },
        child: const Icon(Icons.navigate_before),
        backgroundColor: primarymapbuttoncolor,
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high)
            .listen((Position position) {
      if (position != null) {
        //TODO: Check if position in range... // Das isses. Das Skript, dass die Position gibt: position.latitude.toString() + position.longitude.toString()
      }
    });

    return Scaffold(

        // APP-Bar

        appBar: AppBar(
          automaticallyImplyLeading:
              false, // Kein Automatischer Home Knopf in App Bar
          title: const Text('Navigation'),
          backgroundColor: appbarcolor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.home),
          ),
        ),

        // Weiter Knopf

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, //ButtonPosition wird von der Mitte des Bildschirms berechnet
        floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0), //Padding Größe
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, //Abstand zwischen Buttons
              children: <Widget>[
              _getZurueckButton(context),
              FloatingActionButton( //Buttons rechts
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, a, b) => DetailPage(
                        stationInfo: stationen[stationInfo.position - 1],
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.navigate_next),
                backgroundColor: primarymapbuttoncolor,
              ),
            ],
          ),
        ),


        body: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                  center: LatLng(51.07761902538088, 6.752730047496091),
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
          ],
        ));
  }
}
