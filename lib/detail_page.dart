import 'package:flutter/material.dart';
import 'navigation.dart';
import 'data.dart';
import 'constants.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart';

class DetailPage extends StatelessWidget {
  final StationInfo stationInfo;

  DetailPage({Key? key, required this.stationInfo}) : super(key: key);

  late VideoPlayerController _controller =
      VideoPlayerController.asset(stationInfo.video);
  late Future<void> _initializeVideoPlayerfuture = _controller.initialize();

  @override
  void dispose() {
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Icon Image der Station

                  SizedBox(height: 50),
                  Align(
                      alignment: Alignment(0.75, 0),
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
                        SizedBox(height: 100),
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
                        Divider(color: Colors.black38),
                        SizedBox(height: 32),
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
                        SizedBox(height: 32),
                        Divider(color: Colors.black38),
                      ],
                    ),
                  ),

                  // Info Knöpfe

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        child: Text('Home'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      ElevatedButton(
                        child: Text('Play'),
                        onPressed: () {
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                          } else {
                            _controller.play();
                          }
                        },
                      ),
                      ElevatedButton(
                        child: Text('Weiter'),
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

                  SizedBox(height: 32),
                  Divider(color: Colors.black38),
                  SizedBox(height: 32),

                  // Video

                  FutureBuilder(
                      future: _initializeVideoPlayerfuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),

                  SizedBox(height: 32),
                  Divider(color: Colors.black38),

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
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
