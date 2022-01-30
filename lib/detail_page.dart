import 'package:flutter/material.dart';
import 'package:klosterguide/endcard.dart';
import 'navigation.dart';
import 'data.dart';
import 'constants.dart';
import 'package:video_player/video_player.dart';

class DetailPage extends StatelessWidget {
  final StationInfo stationInfo;

  DetailPage({Key? key, required this.stationInfo}) : super(key: key);

  late final VideoPlayerController _controller =
      VideoPlayerController.asset(stationInfo.video);

  void dispose() {
    _controller.dispose();
    dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, //Position wird von der Mitte des Bildschirms berechnet
      floatingActionButton:
      Padding(
        padding: const EdgeInsets.all(16.0), //Padding Größe
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, //Abstand zwischen Buttons
            children: <Widget>[

            FloatingActionButton(
              onPressed: () {

                if (stationInfo.next != 0 && stationInfo.next != 1) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, a, b) => Navigation(
                        stationInfo: stationen[stationInfo.next],
                      ),
                    ),
                  );
                } else if (stationInfo.next == 1){     //HIER KÖNNTE MAN AUCH INS MENÜ ZURÜCKKOMMEN
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, a, b) => Navigation(
                        stationInfo: stationen[2],   //Wieso ist Station 1 hier Nummer 2?
                      ),
                    ),
                  );
                }
                else {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(pageBuilder: (context, a, b) => Endcard()),
                  );
                }
              },
              child: const Icon(Icons.navigate_before),
              backgroundColor: primarymapbuttoncolor,
            ),
            FloatingActionButton(
              onPressed: () {
                if (stationInfo.next != 0) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, a, b) => Navigation(
                        stationInfo: stationen[stationInfo.next],
                      ),
                    ),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(pageBuilder: (context, a, b) => Endcard()),
                  );
                }
              },
              child: const Icon(Icons.navigate_next),
              backgroundColor: primarymapbuttoncolor,
            ),

          ],
        ),
      ),



      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            // Graue Stationsnummer im Hinergrund

            Positioned(
              top: 60,
              left: 32,
              child: Text(
                stationInfo.position.toString(),
                style: (stationInfo.position >
                        9) // Falls Nummer größer als 9 ist die Zahl zweistellig
                    ? TextStyle(
                        letterSpacing:
                            -25, // Daher, sollen die Zahlen dann näher an einander
                        fontFamily: 'Avenir',
                        fontSize: 247,
                        color: primaryTextColor.withOpacity(0.08),
                        fontWeight: FontWeight.w900,
                      )
                    : TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 247,
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

                  // Stationsname, "Knechtsteden"

                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 100),
                        Text(
                          stationInfo.name,
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 43,
                            color: primaryTextColor,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.left,
                        ),
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
                            const Padding(
                              // Überschrift Zusatzinfos:

                              padding: EdgeInsets.only(left: 15.0),
                              child: Text(
                                'Zusatzinfos',
                                style: TextStyle(
                                  fontFamily: 'Avenir',
                                  fontSize: 25,
                                  color: Color(0xff47455f),
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),

                            // ========================================= Zusatzinfos

                            // Video mit Zusatzinfos:

                            _StationAssetVideo(
                              videopath: stationInfo.zusatzvideo,
                            ),

                            // Ausklappbarer Text mit Zusatzinfos:
                            ExpansionTile(
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
                          ],
                        )
                      : const SizedBox(height: 70),
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
