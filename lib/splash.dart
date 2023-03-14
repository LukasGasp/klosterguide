import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  Splash createState() => Splash();
}

class Splash extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  Random r = Random();

  @override
  Widget build(BuildContext context) {
    Timer(
        const Duration(seconds: 2),
        () => {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      const MyHomePage(title: 'Klosterführer Knechtsteden')))
            });

    var assetsImage = const AssetImage(
        "assets/icons/app2.png"); //<- Creates an object that fetches an image.
    var image = Image(
        image: assetsImage,
        height: MediaQuery.of(context).size.width /
            2); //<- Creates a widget that displays an image.

    return Scaffold(
      /* appBar: AppBar(
          title: Text("MyApp"),
          backgroundColor:
              Colors.blue, //<- background color to combine with the picture :-)
        ),*/
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Center(
          child: image,
        ),
      ), //<- place where the image appears
    );
  }
}
