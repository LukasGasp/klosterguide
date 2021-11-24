import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';

import 'data.dart';
import 'detail_page.dart';

class Navigation extends StatelessWidget {
  final StationInfo stationInfo;

  Navigation({Key? key, required this.stationInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            center: LatLng(51.07761902538088, 6.752730047496091),
            zoom: 15.7,
            maxZoom: 19,
          ),
          layers: [
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: 50.0,
                  height: 50.0,
                  point: LatLng(stationInfo.xcoord, stationInfo.ycoord),
                  builder: (ctx) => Container(
                      child: ClipRRect(
                    borderRadius: BorderRadius.circular(72.5),
                    child: Image.asset(stationInfo.iconImage,
                        width: 200, height: 200),
                  )),
                ),
              ],
            ),
          ],
          children: [
            TileLayerWidget(
              options: TileLayerOptions(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
                maxZoom: 19,
              ),
            ),
            LocationMarkerLayerWidget(),
          ],
        ),

        // Knopf: Nächste Station

        Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              child: Text("Erreicht"),
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
            )),

        // Knopf: Home

        Align(
            alignment: Alignment.bottomLeft,
            child: ElevatedButton(
              child: Text("Home"),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
      ],
    ));
  }
}
