import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;

class navigation extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
            options: MapOptions(
              center: latLng.LatLng(51.07761902538088, 6.752730047496091),
              zoom: 16.0,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate: "https://api.mapbox.com/styles/v1/lukasgasp/ckvtzwj1g2ilw16pddyazbnno/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibHVrYXNnYXNwIiwiYSI6ImNrdnR6dmdqZjNocTMybnRraTA5NDVudTQifQ.eC1tjOYhmaLe9q97ouAKPQ",
                additionalOptions: {
                  'accesToken': 'pk.eyJ1IjoibHVrYXNnYXNwIiwiYSI6ImNrdnR6dmdqZjNocTMybnRraTA5NDVudTQifQ.eC1tjOYhmaLe9q97ouAKPQ',
                  'id': 'mapbox.mapbox-terrain-v2'
                },
                attributionBuilder: (_) {
                  return Text("© OpenStreetMap contributors");
                },
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    width: 40.0,
                    height: 40.0,
                    point: latLng.LatLng(51.07651124466322, 6.7546730663759575),
                    builder: (ctx) =>
                    Container(
                      child: Image.asset('assets/guideicons/torhaus.jpg', width: 150, height: 150),
                    ),
                  ),
                ],
              ),
            ],
          )
    );
  }
}