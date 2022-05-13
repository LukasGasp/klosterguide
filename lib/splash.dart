import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:download_assets/download_assets.dart';

import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  Splash createState() => Splash();
}

class Splash extends State<SplashScreen>  {

  @override
  void initState() {
    super.initState();

  }
  Future _init() async {
    await downloadAssetsController.init(assetDir: "assets/");
    downloaded = await downloadAssetsController.assetsDirAlreadyExists();
  }

  DownloadAssetsController downloadAssetsController = DownloadAssetsController();
  bool downloaded = false;
  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 2),
            () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => MyHomePage(title: 'Klosterführer Knechtsteden'))));


    var assetsImage = new AssetImage(
        "assets/icons/app2.png"); //<- Creates an object that fetches an image.
    var image = new Image(
        image: assetsImage,
        height: MediaQuery.of(context).size.width/2); //<- Creates a widget that displays an image.

    return Scaffold(
        /* appBar: AppBar(
          title: Text("MyApp"),
          backgroundColor:
              Colors.blue, //<- background color to combine with the picture :-)
        ),*/
        body: Container(
          decoration: new BoxDecoration(color: Colors.white),
          child: new Center(
            child: image,
          ),
        ), //<- place where the image appears
      );
  }
}