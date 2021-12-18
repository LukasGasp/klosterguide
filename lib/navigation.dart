import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:klosterguide/constants.dart';
import 'package:latlong2/latlong.dart';

import 'data.dart';
import 'detail_page.dart';

class Navigation extends StatelessWidget {
  final StationInfo stationInfo;

  const Navigation({Key? key, required this.stationInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

        floatingActionButton: FloatingActionButton(
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
              ),
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
              ],
              children: [
                LocationMarkerLayerWidget(),
              ],
            ),
          ],
        ));
  }
}
