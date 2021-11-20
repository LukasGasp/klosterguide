import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';

import 'data.dart';
import 'detail_page.dart';

class Karte extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(children: [
        Flexible(
            child: FlutterMap(
          options: MapOptions(
            center: LatLng(51.07761902538088, 6.752730047496091),
            zoom: 15.7,
            maxZoom: 19,
          ),
          layers: [
            MarkerLayerOptions(), // TODO: Relativ Objekte hinzufügen
          ],
          children: [
            Flexible(
              child: TileLayerWidget(
                options: TileLayerOptions(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                  maxZoom: 19,
                ),
              ),
            ),
            LocationMarkerLayerWidget(),
          ],
        )),
        Align(
            alignment: Alignment.bottomLeft,
            child: ElevatedButton(
              child: Text("Zurück"),
              onPressed: () {
                Navigator.pop(context);
              },
            ))
      ])),
    );
  }
}
