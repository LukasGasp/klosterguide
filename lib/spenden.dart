import 'dart:io';

import 'package:flutter/material.dart';
import 'main.dart';
import 'constants.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/services.dart'; // Um Rotation festzulegen. Flutter Native...

import 'videoplayer_fullscreen.dart';
import 'StationAssetVideo.dart';

class Spenden extends StatelessWidget {
  const Spenden({Key? key}) : super(key: key);

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

                  const SizedBox(height: 20),
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
                  const SizedBox(height: 10),
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
  StationAssetVideoState createState() =>
      // Falsche interpretation der IDE
      // ignore: no_logic_in_create_state
      StationAssetVideoState(videopath: File(videopath));
}
