import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:download_assets/download_assets.dart';

import 'constants.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  Splash createState() => Splash();
}

class Splash extends State<SplashScreen>  {

  bool downloaded = false;
  bool _visible = true;
  @override
  void initState() {
    super.initState();
    _init();
  }
  Future _init() async {
    await downloadAssetsController.init(assetDir: "videos");
    downloaded = await downloadAssetsController.assetsFileExists("videos/Klosterguide-Videos/navvideos/Nav_1.mp4");
    (downloaded)
        ?setState(() {
        _visible = false;
      })
        :setState(() {
      _visible = true;
    });
  }
  DownloadAssetsController downloadAssetsController = DownloadAssetsController();
  @override
  Widget build(BuildContext context) {



    var assetsImage = new AssetImage(
        "assets/icons/app2.png"); //<- Creates an object that fetches an image.
    var image = new Image(
        image: assetsImage,
        height: MediaQuery.of(context).size.width/2); //<- Creates a widget that displays an image.

    return Scaffold(
      backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              height: 600,
              child: Center(
                child: image,
              ),
            ),
            (_visible)?Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(bottom: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0, right: 32.0,bottom: 32),
                    child: Text(
                      "Zur Verwendung der App müssen zunächst die Videos heruntergeladen werden", //Es wird sogar ein womöglicher englischer Text geladen
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 20,
                        color: contentTextColor,
                        fontWeight: FontWeight.w500,
                        wordSpacing: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: 100,
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
                          child: Text("Download",
                            textAlign: TextAlign.center,
                          )),
                      onPressed: () {
                        _downloadAssets();
                        _downloaded();
                        Timer(
                            Duration(seconds: 2),
                                () =>
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (BuildContext context) => MyHomePage(title: 'Klosterführer Knechtsteden'))));
                      },
                    ),
                  ),]
              ),
            )
                :Container()
          ],
        ), //<- place where the image appears
      );
  }

  Future _refresh() async {
    await downloadAssetsController.clearAssets();
    await _downloadAssets();
  }

  Future _downloaded() async {
    bool temp = await downloadAssetsController.assetsFileExists("videos/Klosterguide-Videos/navvideos/Nav_1.mp4");
    (temp)?
        print("yes")
        :print("no");
  }


  Future _downloadAssets() async {
    bool assetsDownloaded = await downloadAssetsController.assetsDirAlreadyExists();

    if (assetsDownloaded) {
      return;
    }

    try {
      await downloadAssetsController.startDownload(
        assetsUrl: "https://github.com/LukasGasp/Klosterguide-Videos",

      );
    } on DownloadAssetsException catch (e) {
      print(e.toString());
    }
  }
}