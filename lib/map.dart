import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:klosterguide/constants.dart';
import 'package:latlong2/latlong.dart';
import 'package:audioplayers/audioplayers.dart';

import 'data.dart';
import 'detail_page.dart';

class Karte extends StatelessWidget {
  List<Marker> markierungen = [];

  Karte({Key? key}) : super(key: key);

  get localPath => null;

  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache player = AudioCache(prefix: 'assets/audio/');

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < stationen.length; i++) {
      markierungen.add(Marker(
          width: 50.0,
          height: 50.0,
          point: LatLng(stationen[i].xcoord, stationen[i].ycoord),
          builder: (ctx) => InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, a, b) => DetailPage(
                        //stationInfo: stationen[i],
                        tourlist: [i],
                        index: 0,
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(72.5),
                  child: Image.asset(stationen[i].iconImage,
                      width: 200, height: 200),
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
            Positioned(
              bottom: 10,
              child: Container(
                width: 200,
                height: 100,
                padding: EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10.0, spreadRadius: 0.1)]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      onPressed: (){
                        player.play('test.mp3');
                      },

                        icon: Icon(Icons.play_arrow, color: Colors.grey, size: 30 )),
                    IconButton(
                        onPressed: (){
                          player.play('test.mp3');
                        },

                        icon: Icon(Icons.play_arrow, color: Colors.grey, size: 30 ))
                  ],
                )
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 100),
              child:FlutterMap(

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
                    // For example purposes. It is recommended to use
                    // TileProvider with a caching and retry strategy, like
                    // NetworkTileProvider or CachedNetworkTileProvider
                  ),
                  LocationMarkerLayerOptions(),
                  MarkerLayerOptions(markers: markierungen),
                ],
              ),
            ),
          ],
        ));
  }
  
  void playAudio(){
    playLocal() async {
      int result = await audioPlayer.play(localPath, isLocal: true);
    }
  }
}

