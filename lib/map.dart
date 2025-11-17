import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:klosterguide/constants.dart';
import 'package:latlong2/latlong.dart';

import 'data.dart';
import 'navigation_detail_page.dart';

class Karte extends StatelessWidget {
  List<Marker> markierungen = [];

  Karte({Key? key}) : super(key: key);

  get localPath => null;

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < stationen.length; i++) {
      markierungen.add(Marker(
          width: 50.0,
          height: 50.0,
          point: LatLng(stationen[i].xcoord, stationen[i].ycoord),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, a, b) => DetailPage(
                    //stationInfo: stationen[i],
                    tourlist: [i],
                    index: 0,
                    mapvideo: false,
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(72.5),
              child:
                  Image.asset(stationen[i].iconImage, width: 200, height: 200),
            ),
          )));
    }

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.home),
          backgroundColor: primarymapbuttoncolor,
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter:
                    const LatLng(51.07782168731831, 6.753696126096359),

                initialZoom: 15.7,

                minZoom: 14,
                maxZoom: 18,

                cameraConstraint: CameraConstraint.contain(
                  bounds: LatLngBounds(
                    const LatLng(51.0727696061025, 6.74033047115352),
                    const LatLng(51.0834444361947, 6.76094581023449),
                  ),
                ),

                // 'plugins' wird in MapOptions nicht mehr benötigt
              ),
              children: [
                TileLayer(
                  tileProvider: AssetTileProvider(),
                  maxZoom: 18.0,
                  urlTemplate: 'assets/map/{z}/{x}/{y}.png',
                ),
                MarkerLayer(markers: markierungen),
                const CurrentLocationLayer(),
              ],
            ),
          ],
        ));
  }
}
