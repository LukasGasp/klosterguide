import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'navigation.dart';
import 'data.dart';
import 'constants.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

class Endcard extends StatelessWidget {
  Endcard({Key? key}) : super(key: key);

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

                  const SizedBox(height: 50),
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
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Ende",
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 50,
                            color: primaryTextColor,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'Vielen Dank!',
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 31,
                            color: primaryTextColor,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Divider(color: endcardTextColor),
                      ],
                    ),
                  ),

                  // Video: Klassen unten

                  _StationAssetVideo(
                    videopath: "assets/guidevideos/yee.mp4",
                  ),
                  // Detaillierte Beschreibung

                  ExpansionTile(
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
                          DemoLocalizations.of(context)!.getText("endcard"), //Es wird sogar ein womöglicher englischer Text geladen
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
                  const SizedBox(height: 35),

                  // Knöpfe
              Row(
                  children:<Widget>[
                    Text(
                      "  " + DemoLocalizations.of(context)!.getText("links") + " ",
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 31,
                        color: primaryTextColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Icon
                      (
                      Icons.insert_link,
                      color: primaryTextColor,
                    ),
                  ]
                ),

                  Divider(color: endcardTextColor),
                  const SizedBox(height: 25),

                  Align(
                    alignment: Alignment.center,
                    child: SizedBox( //Feedback und Kontakt
                      height: 60,
                      width: 100,
                      child: FloatingActionButton(
                        backgroundColor: primarybuttoncolor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),)),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(DemoLocalizations.of(context)!.getText("endcard1stbutton"),textAlign: TextAlign.center,)
                        ),
                        onPressed: () {
                          launch("https://www.youtube.com/watch?v=dQw4w9WgXcQ");
                        },
                      ),
                    )
                  ),
                  const SizedBox(height: 35),
                Row(
                  children:<Widget>[
                    Text(
                      "  " + DemoLocalizations.of(context)!.getText("endcard2ndtitle") + " ",
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 31,
                        color: primaryTextColor,
                        fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    Icon(Icons.sentiment_satisfied_rounded,color: primaryTextColor,),
                    ]
                  ),
                  Divider(color: endcardTextColor),
                  const SizedBox(height: 25),

                  Row( //Spenden
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                        width: 130,
                        child: FloatingActionButton(
                          backgroundColor: primarybuttoncolor,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),)),
                          child: Container(
                              alignment: Alignment.center,
                              child: Text(DemoLocalizations.of(context)!.getText("endcard2ndbutton"),textAlign: TextAlign.center,)
                          ),
                          onPressed: () {
                            launch("https://www.youtube.com/watch?v=dQw4w9WgXcQ");
                          },
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 170,
                        child: FloatingActionButton(
                          backgroundColor: primarybuttoncolor,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),)),
                          child: Container(
                              alignment: Alignment.center,
                              child: Text(DemoLocalizations.of(context)!.getText("endcard3rdbutton"),textAlign: TextAlign.center,)
                          ),
                          onPressed: () {
                            launch("https://www.youtube.com/watch?v=dQw4w9WgXcQ");
                          },
                        ),
                      ),

                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(

                        child: Image.asset('assets/icons/logo-missionshaus.png'),
                        height: 100,
                        width: 200,
                      ),
                      Container(

                        child: Image.asset('assets/icons/logo-ngk-campus.png'),
                        height: 100,
                        width: 100,
                      ),
                    ],
                  ),
                  const SizedBox(height: 75),
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
      _StationAssetVideoState(videopath: videopath);
}

class _StationAssetVideoState extends State<_StationAssetVideo> {
  late VideoPlayerController _controller;
  final String videopath;

  _StationAssetVideoState({required this.videopath});

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(videopath);

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
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(0),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(_controller),
                  _ControlsOverlay(controller: _controller),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Video Overlay
class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);

  static const _examplePlaybackRates = [
    0.25,
    0.5,
    0.75,
    1.0,
    1.25,
    1.5,
    1.75,
    2.0
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Wiedergabetempo',
            onSelected: (speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (context) {
              return [
                for (final speed in _examplePlaybackRates)
                  PopupMenuItem(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}
