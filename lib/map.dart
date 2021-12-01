import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:klosterguide/constants.dart';
import 'package:latlong2/latlong.dart';

import 'data.dart';
import 'detail_page.dart';

class Karte extends StatelessWidget {
  List<Marker> markierungen = [];

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < stationen.length; i++) {
      markierungen.add(Marker(
          width: 50.0,
          height: 50.0,
          point: LatLng(stationen[i].xcoord, stationen[i].ycoord),
          builder: (ctx) => InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, a, b) => DetailPage(
                        stationInfo: stationen[i],
                      ),
                    ),
                  );
                },
                child: Container(
                    child: ClipRRect(
                  borderRadius: BorderRadius.circular(72.5),
                  child: Image.asset(stationen[i].iconImage,
                      width: 200, height: 200),
                )),
              )));
    }

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.home),
          backgroundColor: primarymapbuttoncolor,
        ),
        body: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                center: LatLng(51.07761902538088, 6.752730047496091),
                zoom: 15.7,
                maxZoom: 19,
              ),
              layers: [MarkerLayerOptions(markers: markierungen)],
              children: [
                TileLayerWidget(
                  options: TileLayerOptions(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                    maxZoom: 19,
                  ),
                ),
                LocationMarkerLayerWidget(), // Position auf Karte
              ],
            ),
          ],
        ));
  }
}
