import 'package:flutter/material.dart';
import 'navigation.dart';
import 'data.dart';
import 'constants.dart';
import 'package:video_player/video_player.dart';

class DetailPage extends StatelessWidget {
  final StationInfo stationInfo;

  DetailPage({Key? key, required this.stationInfo}) : super(key: key);

  late VideoPlayerController _controller =
      VideoPlayerController.asset(stationInfo.video);
  late Future<void> _initializeVideoPlayerfuture = _controller.initialize();

  void dispose() {
    _controller.dispose();
    dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: 247,
                  color: primaryTextColor.withOpacity(0.08),
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
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

                  // Stationsname, "Knechtsteden", description

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
                            fontSize: 50,
                            color: primaryTextColor,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'Knechtsteden',
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 31,
                            color: primaryTextColor,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const Divider(color: Colors.black38),
                        const SizedBox(height: 32),
                        Text(
                          stationInfo.description,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 20,
                            color: contentTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Divider(color: Colors.black38),
                      ],
                    ),
                  ),

                  // Info Knöpfe

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        child: const Text('Home'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Weiter'),
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
                            Navigator.pop(context);
                          }
                        },
                      )
                    ],
                  ),

                  const SizedBox(height: 32),
                  const Divider(color: Colors.black38),
                  const SizedBox(height: 32),

                  // Video: Klassen unten

                  _StationAssetVideo(
                    videopath: stationInfo.video,
                  ),

                  const SizedBox(height: 32),
                  const Divider(color: Colors.black38),

                  // Überschrift "Details"

                  const SizedBox(height: 32),
                  const Padding(
                    padding: EdgeInsets.only(left: 32.0),
                    child: Text(
                      'Videotext',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 25,
                        color: Color(0xff47455f),
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Detaillierte Beschreibung

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

  _StationAssetVideo({Key? key, required this.videopath}) : super(key: key);

  @override
  _StationAssetVideoState createState() =>
      _StationAssetVideoState(videopath: videopath);
}

class _StationAssetVideoState extends State<_StationAssetVideo> {
  late VideoPlayerController _controller;
  final String videopath;

  _StationAssetVideoState({Key? key, required this.videopath});

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
            padding: const EdgeInsets.only(top: 20.0),
          ),
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
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
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
