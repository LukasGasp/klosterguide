import 'dart:io'; // Um Dateien einzulesen (Videos...)
import 'package:path_provider/path_provider.dart'; // Gibt Pfad an in dem die Videos sind

import 'package:flutter/material.dart';
import 'main.dart';
import 'constants.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/services.dart'; // Um Rotation festzulegen. Flutter Native...

import 'videoplayer_fullscreen.dart';

class Endcard extends StatelessWidget {
  const Endcard({Key? key}) : super(key: key);

  Future<File> getFile(filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = directory.path + "/Klosterguide-Videos-main" + filename;
    print("Dateipfad: " + filePath);
    return File(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.home),
        backgroundColor: primarymapbuttoncolor,
      ),
      backgroundColor: secondarybackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Icon Image der Station

                  Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(72.5),
                        child: Image.asset("assets/icons/app2.png",
                            width: 250,
                            height: 250,
                            alignment: Alignment.center)),
                  ),
                  // Stationsname, "Knechtsteden"

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Text(
                            "Abschied",
                            style: TextStyle(
                              fontFamily: 'Avenir',
                              fontSize: 50,
                              color: primaryTextColor,
                              fontWeight: FontWeight.w900,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Divider(color: endcardTextColor),
                      ],
                    ),
                  ),

                  // Video: Klassen unten

                  // Wartet auf Pfad, in dem die Videos sind und zeigt dann das Video
                  FutureBuilder<File?>(
                    future: getFile("/guidevideos/Endcard.mp4"),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      final file = snapshot.data;
                      if (file != null) {
                        return _StationAssetVideo(videopath: file);
                      } else {
                        return const Text('File not found');
                      }
                    },
                  ),

                  // Detaillierte Beschreibung

                  ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    title: Text(
                      'Textfassung',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 25,
                        color: endcardTextfassungColor,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    children: <Widget>[
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                        child: Text(
                          DemoLocalizations.of(context)!.getText(
                              "endcard"), //Es wird sogar ein womöglicher englischer Text geladen
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
                  const SizedBox(height: 5),

                  // Knöpfe

                  // Knöpfe

                  Divider(color: endcardTextColor),
                  const SizedBox(height: 55),

                  Align(
                      alignment: Alignment.center,
                      child: SizedBox(
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
                                DemoLocalizations.of(context)!
                                    .getText("endcard1stbutton"),
                                textAlign: TextAlign.center,
                              )),
                          onPressed: () {
                            launch(DemoLocalizations.of(context)!
                                .getText("kontaktlink"));
                          },
                        ),
                      )),
                  const SizedBox(height: 55),

                  Center(
                    child: Text(
                      DemoLocalizations.of(context)!.getText("endcard2ndtitle"),
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 42,
                        color: primaryTextColor,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Divider(color: endcardTextColor),
                  const SizedBox(height: 25),

                  Row(
                    //Spenden
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(children: [
                        SizedBox(
                          height: 50,
                          width: (MediaQuery.of(context).size.width >= 500)
                              ? 180
                              : MediaQuery.of(context).size.width * 180 * 0.002,
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
                                  DemoLocalizations.of(context)!
                                      .getText("endcard2ndbutton"),
                                  textAlign: TextAlign.center,
                                )),
                            onPressed: () {
                              launch(DemoLocalizations.of(context)!
                                  .getText("spendenlinkmh"));
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          child:
                              Image.asset('assets/icons/logo-missionshaus.png'),
                          height: 100,
                          width: 100,
                        ),
                      ]),
                      Column(children: [
                        SizedBox(
                          height: 50,
                          width: (MediaQuery.of(context).size.width >= 500)
                              ? 180
                              : MediaQuery.of(context).size.width * 180 * 0.002,
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
                                  DemoLocalizations.of(context)!
                                      .getText("endcard3rdbutton"),
                                  textAlign: TextAlign.center,
                                )),
                            onPressed: () {
                              launch(DemoLocalizations.of(context)!
                                  .getText("spendenlinkngk"));
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          child:
                              Image.asset('assets/icons/logo-ngk-campus.png'),
                          height: 100,
                          width: 100,
                        ),
                      ]),
                    ],
                  ),
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
  final File videopath;

  const _StationAssetVideo({Key? key, required this.videopath})
      : super(key: key);

  @override
  _StationAssetVideoState createState() =>
      // Falsche interpretation der IDE
      // ignore: no_logic_in_create_state
      _StationAssetVideoState(videopath: videopath);
}

class _StationAssetVideoState extends State<_StationAssetVideo> {
  late VideoPlayerController _controller;
  final File videopath;

  _StationAssetVideoState({required this.videopath});

  var dir;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(videopath);
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
