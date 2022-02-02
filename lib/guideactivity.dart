import 'package:flutter/material.dart';
import 'constants.dart';

import 'navigation.dart';
import 'detail_page.dart';

import 'touren.dart';

class Guideactivity extends StatelessWidget {
  const Guideactivity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appbarcolor,
          title: const Text("Touren"),
        ),
        body: Container(
          color: primarybackgroundcolor,
          child: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              // Test: Eventuell ist center besser
              children: <Widget>[
                // Tour
                buildunifinishedcard(context, "assets/guideactivity/glocke.png",
                    "Kurzer Einblick", "ca. 3 Minuten", "kurz"),
                const SizedBox(height: 50),

                // Discover
                buildunifinishedcard(
                    context,
                    "assets/guideactivity/klosterhof.png",
                    "Schöne Tour",
                    "ca. 42 Minuten",
                    "mittel"),
                const SizedBox(height: 50),

                // Längenschnitt
                buildunifinishedcard(
                    context,
                    "assets/guideactivity/spiritaner.jpg",
                    "Alles",
                    "ca. 300h",
                    "lang")
              ],
            ),
          ),
        ));
  }

  Widget buildunifinishedcard(BuildContext context, String imagepath,
      String title, String description, String option) {
    return GestureDetector(
        onTap: () {
          menueclick(option, context);
        },
        child: Container(
          padding: const EdgeInsets.all(24),
          width: MediaQuery.of(context).size.width - 12,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
                image: AssetImage(imagepath),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.25),
                  BlendMode.darken,
                )),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              )
            ],
          ),
        ));
  }

  void menueclick(String onclick, BuildContext context) {
    switch (onclick) {
      case "kurz":
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailPage(
                        tourlist: tour_kurz,
                        index: 0,
                      )));
        }
        break;
      case "mittel":
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Navigation(
                        tourlist: tour_mittel,
                        index: 0,
                      )));
        }
        break;
      case "lang":
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Navigation(
                        tourlist: tour_lang,
                        index: 0,
                      )));
        }
        break;
    }
  }
}
