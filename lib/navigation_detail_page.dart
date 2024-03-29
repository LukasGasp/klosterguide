import 'package:flutter/material.dart';
import 'package:klosterguide/navigation_endcard.dart';
import 'package:klosterguide/videoplayer_fullscreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';
import 'navigation.dart';
import 'data.dart';
import 'constants.dart';
import 'package:video_player/video_player.dart';

import 'package:flutter/services.dart'; // Um Rotation festzulegen. Flutter Native...

class DetailPage extends StatelessWidget {
  final List tourlist;
  final int index;
  final bool mapvideo;

  const DetailPage(
      {Key? key,
      required this.tourlist,
      required this.index,
      required this.mapvideo})
      : super(key: key);

  Widget _getWeiterButton(BuildContext context, StationInfo stationInfo) {
    return Visibility(
        child: FloatingActionButton(
      onPressed: () {
        // Dann ist es der Location Marker
        if (tourlist.length <= 2) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, a, b) => Navigation(
                tourlist: tourlist,
                index: index,
                mapvideo: mapvideo,
              ),
              transitionsBuilder: (context, anim, b, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: animationlength),
            ),
          );
        }
        if (tourlist[index + 1] != 0) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, a, b) => Navigation(
                tourlist: tourlist,
                index: index + 1,
                mapvideo: mapvideo,
              ),
              transitionsBuilder: (context, anim, b, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: animationlength),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, a, b) => const Endcard(),
              transitionsBuilder: (context, anim, b, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: animationlength),
            ),
          );
        }
      },
      child: tourlist.length >= 2
          ? const Icon(Icons.navigate_next)
          : const Icon(Icons.location_on),
      backgroundColor: primarymapbuttoncolor,
    ));
  }

  Widget _getZurueckButton(BuildContext context, StationInfo stationInfo) {
    return FloatingActionButton(
      onPressed: () {
        if (tourlist.length <= 2) {
          // Falls die Liste kürzer ist, handelt es sich um keine Tour. Daher, gibt es keine Vorherige Station
          Navigator.pop(context);
          return;
        }
        if (tourlist[index + 1] != 0) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, a, b) => Navigation(
                tourlist: tourlist,
                index: index,
                mapvideo: mapvideo,
              ),
              transitionsBuilder: (context, anim, b, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: animationlength),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, a, b) => const Endcard(),
              transitionsBuilder: (context, anim, b, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: animationlength),
            ),
          );
        }
      },
      child: const Icon(Icons.navigate_before),
      backgroundColor: primarymapbuttoncolor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final StationInfo stationInfo = stationen[tourlist[index]];

    return Scaffold(
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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.home),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerDocked, //Position wird von der Mitte des Bildschirms berechnet
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0), //Padding Größe
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, //Abstand zwischen Buttons
          children: <Widget>[
            _getZurueckButton(context, stationInfo),
            _getWeiterButton(context, stationInfo),
          ],
        ),
      ),

      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            // Graue Stationsnummer im Hinergrund

            Positioned(
              top: -20,
              left: 4,
              child: Text(
                stationInfo.position.toString(),
                style: (stationInfo.position >
                        9) // Falls Nummer größer als 9 ist die Zahl zweistellig
                    ? TextStyle(
                        letterSpacing:
                            -25, // Daher, sollen die Zahlen dann näher an einander
                        fontFamily: 'Avenir',
                        fontSize: 248,
                        color: primaryTextColor.withOpacity(0.08),
                        fontWeight: FontWeight.w900,
                      )
                    : TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 500,
                        color: primaryTextColor.withOpacity(0.08),
                        fontWeight: FontWeight.w900,
                      ),
                textAlign: TextAlign.left,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Icon Image der Station

                  const SizedBox(height: 50),
                  Align(
                      alignment: const Alignment(0.75, 0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(72.5),
                          child: Image.asset(stationInfo.iconImage,
                              width: 150, height: 150))),

                  // Stationsname
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          stationInfo.name,
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 36,
                            color: primaryTextColor,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.black38),
                      ],
                    ),
                  ),

                  // Video: Klassen unten

                  _StationAssetVideo(
                    videopath: stationInfo.video,
                  ),
                  // Detaillierte Beschreibung

                  ExpansionTile(
                    tilePadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    title: const Text(
                      'Textfassung',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 25,
                        color: Color(0xff47455f),
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    children: <Widget>[
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                        child: Text(
                          stationInfo.fulltext,
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 20,
                            color: contentTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),

                  // Zusatzinfos
                  (stationInfo.zusatzvideo != "")
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(color: Colors.black38),
                            const SizedBox(height: 32),
                            Padding(
                              // Überschrift Zusatzinfos:

                              padding: const EdgeInsets.only(left: 15.0),
                              // ignore: unnecessary_null_comparison
                              child: Text(
                                stationInfo.zusatztitel,
                                style: const TextStyle(
                                  fontFamily: 'Avenir',
                                  fontSize: 25,
                                  color: Color(0xff47455f),
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            const SizedBox(height: 15),

                            // ========================================= Zusatzinfos

                            // Video mit Zusatzinfos:

                            _StationAssetVideo(
                              videopath: stationInfo.zusatzvideo,
                            ),

                            // Ausklappbarer Text mit Zusatzinfos:
                            ExpansionTile(
                              tilePadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              title: const Text(
                                'Textfassung',
                                style: TextStyle(
                                  fontFamily: 'Avenir',
                                  fontSize: 25,
                                  color: Color(0xff47455f),
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              children: <Widget>[
                                const SizedBox(height: 32),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 32.0, right: 32.0),
                                  child: Text(
                                    stationInfo.zusatztext,
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                                      fontSize: 20,
                                      color: contentTextColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                                const SizedBox(height: 70),
                              ],
                            ),
                            const SizedBox(height: 70),
                          ],
                        )
                      : const SizedBox(height: 70),
                  (index==13)
                    ? Column(children: [
                        Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                          //Feedback und Kontakt
                          height: 60,
                          width: 200,
                          child: FloatingActionButton(
                            backgroundColor: primarybuttoncolor,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                )),
                            child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Speisekarte Klosterhof',
                                  textAlign: TextAlign.center,
                                )),
                            onPressed: () {
                              launch(DemoLocalizations.of(context)!
                                  .getText("speisekartelink"));
                            },
                          ),
                    ),
                        ],
                      ),
                        SizedBox(height: 40,)
                        ])
                      : Container()

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Video stuff
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

// Video stuff
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
        height: 16,
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
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
