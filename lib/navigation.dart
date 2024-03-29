//import 'dart:async'; Ist für regelmäßige Positionsabfrage nötig. Zurzeit unnötig. NICHT LÖSCHEN! ~ Lukas

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:klosterguide/constants.dart';
import 'package:klosterguide/touren.dart';
import 'package:latlong2/latlong.dart';
import 'package:klosterguide/videoplayer_fullscreen.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

//import 'package:geolocator/geolocator.dart'; Ist für regelmäßige Positionsabfrage nötig. Zurzeit unnötig. NICHT LÖSCHEN! ~ Lukas

import 'globals.dart' as globals;
import 'data.dart';
import 'navigation_detail_page.dart';

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
  bool _visible = true; //_visible bestimmt, ob das Navigationsvideo angezeigt wird
  @override
  Widget build(BuildContext context) {
    final StationInfo stationInfo = stationen[widget.tourlist[widget.index]];

    //Welche Tour wird angezeigt
    if(widget.tourlist==tour_lang) {
      globals.letzteposition = widget.index;
    }
    if(widget.tourlist==tour_mittel) {
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
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
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
          child: Stack(
            children: [
              //Der Mapvideo Ein/Aus Button
              AnimatedPositioned(
                //Bewegung des Buttons wird animiert
                duration: Duration(milliseconds: 230),
                bottom: (_visible) //_visible: Ob Mapvideo minimiert ist oder nicht
                //Höhe des Buttons wenn _visible true ist:
                    ?(MediaQuery.of(context).size.width-50 >=270 * MediaQuery.of(context).size.height * 0.002 )
                      ?147 * MediaQuery.of(context).size.height * 0.002
                      :(MediaQuery.of(context).size.width-50) * (147/270)
                //Höhe des Buttons wenn _visible false ist:
                    :15,
                left: (MediaQuery.of(context).size.width/2)-40,
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
                                    transitionsBuilder: (context, anim, b, child) =>
                                        FadeTransition(opacity: anim, child: child),
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
            ),]
          ),
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
                          width: (MediaQuery.of(context).size.width-50 >=270 * MediaQuery.of(context).size.height * 0.002 )
                              ?270 * MediaQuery.of(context).size.height * 0.002
                              :MediaQuery.of(context).size.width-50,
                          height: (MediaQuery.of(context).size.width-50 >=270 * MediaQuery.of(context).size.height * 0.002 )
                              ?147 * MediaQuery.of(context).size.height * 0.002
                              :(MediaQuery.of(context).size.width-50) * (147/270),
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
                            child: _StationAssetVideo(
                              videopath: stationen[widget.index].mapvideo,
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

class _StationAssetVideo extends StatefulWidget {
  final String videopath;

  const _StationAssetVideo({Key? key, required this.videopath})
      : super(key: key);

  @override
  _StationAssetVideoState createState() =>
      // Falsche interpretation der IDE
      // ignore: no_logic_in_create_state
      _StationAssetVideoState(
          videopath:
              "https://raw.githubusercontent.com/LukasGasp/Klosterguide-Videos/main" +
                  videopath);
}

/// Video stuff
//Alles ist notwendig

class _StationAssetVideoState extends State<_StationAssetVideo> {
  late VideoPlayerController _controller;
  final String videopath;

  _StationAssetVideoState({required this.videopath});

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(videopath);

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(false);
    _controller.initialize().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays:
            SystemUiOverlay.values); // Benachrichtigungsleiste wieder zeigen
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        VideoPlayerFullscreenWidget(controller: _controller),
      ],
    );
  }
}

class VideoPlayerFullscreenWidget extends StatelessWidget {
  final VideoPlayerController controller;

  VideoPlayerFullscreenWidget({Key? key, required this.controller})
      : super(key: key);

  bool isPortrait = true;

  @override
  Widget build(BuildContext context) => controller.value.isInitialized
      ? Container(alignment: Alignment.topCenter, child: buildVideo())
      : const Center(child: CircularProgressIndicator.adaptive());

  Widget buildVideo() => OrientationBuilder(
        builder: (context, orientation) {
          return Stack(
            fit: isPortrait ? StackFit.loose : StackFit.expand,
            children: <Widget>[
              buildVideoPlayer(),
              Positioned.fill(
                child: AdvancedOverlayWidget(
                  controller: controller,
                  onClickedFullScreen: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => videoplayer_fullscreen(
                                controller: controller)));
                  },
                ),
              ),
            ],
          );
        },
      );

  Widget buildVideoPlayer() => buildFullScreen(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
      );

  Widget buildFullScreen({
    required Widget child,
  }) {
    final size = controller.value.size;
    final width = size.width;
    final height = size.height;

    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(width: width, height: height, child: child),
    );
  }
}

class AdvancedOverlayWidget extends StatelessWidget {
  final VideoPlayerController controller;
  final VoidCallback onClickedFullScreen;

  static const allSpeeds = <double>[0.25, 0.5, 1, 1.25, 1.5, 2];

  const AdvancedOverlayWidget(
      {Key? key, required this.controller, required this.onClickedFullScreen})
      : super(key: key);

  String getPosition() {
    final duration = Duration(
        milliseconds: controller.value.position.inMilliseconds.round());

    return [duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () =>
            controller.value.isPlaying ? controller.pause() : controller.play(),
        child: Stack(
          children: <Widget>[
            buildPlay(),
            buildSpeed(),
            Align(
              alignment: Alignment.topLeft,
              child: Text(getPosition()),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Row(
                  children: [
                    Expanded(child: buildIndicator()),
                    const SizedBox(width: 12),
                    GestureDetector(
                      child: const Icon(
                        Icons.fullscreen,
                        color: Colors.white,
                        size: 28,
                      ),
                      onTap: onClickedFullScreen,
                    ),
                    const SizedBox(width: 8),
                  ],
                )),
          ],
        ),
      );

  Widget buildIndicator() => Container(
        margin: const EdgeInsets.all(8).copyWith(right: 0),
        height: 12,
        child: VideoProgressIndicator(
          controller,
          allowScrubbing: true,
        ),
      );

  Widget buildSpeed() => Align(
        alignment: Alignment.topRight,
        child: PopupMenuButton<double>(
          initialValue: controller.value.playbackSpeed,
          tooltip: 'Playback speed',
          onSelected: controller.setPlaybackSpeed,
          itemBuilder: (context) => allSpeeds
              .map<PopupMenuEntry<double>>((speed) => PopupMenuItem(
                    value: speed,
                    child: Text('${speed}x'),
                  ))
              .toList(),
          child: Container(
            color: Colors.white38,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            child: const Text("Tempo"),
          ),
        ),
      );

  Widget buildPlay() => controller.value.isPlaying
      ? Container()
      : Container(
          color: Colors.black26,
          child: const Center(
            child: Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 70,
            ),
          ),
        );
}
//Video Stuff Ende
