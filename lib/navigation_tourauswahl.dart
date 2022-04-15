import 'package:flutter/material.dart';
import 'constants.dart';

import 'navigation.dart';
import 'navigation_detail_page.dart';

import 'touren.dart';

import 'navigation_start.dart';

class Guideactivity extends StatelessWidget {
  const Guideactivity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appbarcolor,
          title: const Text("Führungen"),
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
                // Längenschnitt
                buildunifinishedcard(
                    context,
                    "assets/guideactivity/spiritaner.jpg",
                    "Zeige mir alles!",
                    "ca. 2 Stunden",
                    "lang",
                    true), //HINWEIS: SELECTABLE WIRD AUCH ALS VARIABLE FÜR MAPVIDEOS BENUTZT
                    const SizedBox(height: 50),

                // Tour
              
                // Discover
                buildunifinishedcard(
                    context,
                    "assets/guideactivity/klosterhof.jpg",
                    "Gib mir einen Überblick!",
                    "ca. 45 Minuten",
                    "mittel",
                    false),
                
              ],
            ),
          ),
        ));
  }

  Widget buildunifinishedcard(BuildContext context, String imagepath,
      String title, String description, String option, bool selectable) {
    return GestureDetector(
      onTap: () {
        menueclick(option, context);
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        width: MediaQuery.of(context).size.width - 12,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            alignment: Alignment.topLeft,
            image: AssetImage(imagepath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.25),
              BlendMode.darken,
            ))
              
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
      ),
    );
  }

  void snackbar(context, String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: color,
    ));
  }

  void menueclick(String onclick, BuildContext context) {
    switch (onclick) {
      case "kurz":
        {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => const DetailPage(
          //               tourlist: tour_kurz,
          //               index: 0,
          //             )));
          snackbar(context, "Coming soon", Colors.black);
        }
        break;
      case "mittel":
        {
           Navigator.push(
               context,
               MaterialPageRoute(
                   builder: (context) => const NavStart(
                     tourlist: tour_mittel,
                     mapvideo: true,
                     laenge: "mittel",

                       )));
          
        }
        break;
      case "lang":
        {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const NavStart(
                    tourlist: tour_lang,
                    mapvideo: true,
                    laenge: "lang",
                      )));
        }
        break;
    }
  }
}
