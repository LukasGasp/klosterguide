import 'package:flutter/material.dart';
import 'data.dart';
import 'constants.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:path/path.dart';

class DetailPage extends StatelessWidget {
  final StationInfo stationInfo;

  DetailPage({Key? key, required this.stationInfo}) : super(key: key);

  final FlutterTts flutterTts = FlutterTts(); // text zu Sprache

  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer(); // Vorlesestimme

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Load audio

    assetsAudioPlayer.open(
      Audio("assets/guideaudios/allstar.mp3"),
      autoStart: false,
    );

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
                      child: Image.asset(stationInfo.iconImage,
                          width: 150, height: 150)),

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
                        child: Text('Vorlesen'),
                        onPressed: () {
                          playaudio();
                        },
                      ),
                      ElevatedButton(
                        child: Text('Weiter'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, a, b) => DetailPage(
                                stationInfo: stationen[stationInfo.next],
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),

                  Divider(color: Colors.black38),
                  SizedBox(height: 32),

                  // Überschrift Gallerie

                  const Padding(
                    padding: EdgeInsets.only(left: 32.0),
                    child: Text(
                      'Gallerie',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 25,
                        color: Color(0xff47455f),
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),

                  SizedBox(height: 32),

                  // Stationsbilder

                  Container(
                    height: 250,
                    padding: const EdgeInsets.only(left: 32.0),
                    child: ListView.builder(
                        itemCount: stationInfo.images.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Card(
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: AspectRatio(
                                aspectRatio: 1,
                                child: Image.asset(
                                  stationInfo.images[index],
                                  fit: BoxFit.cover,
                                )),
                          );
                        }),
                  ),

                  const SizedBox(height: 32),
                  const Divider(color: Colors.black38),

                  // Überschrift "Details"

                  const SizedBox(height: 32),
                  const Padding(
                    padding: EdgeInsets.only(left: 32.0),
                    child: Text(
                      'Details',
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

  void playaudio() async {
    assetsAudioPlayer.playOrPause();
    print(assetsAudioPlayer.getCurrentAudioextra);
    print(assetsAudioPlayer.currentPosition.toString());
  }
}
