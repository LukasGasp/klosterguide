import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'detail_page.dart';
import 'data.dart';
import 'navigator.dart';

class guideactivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Klosterführer",
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Klosterführung"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                  child: Text("Tour starten"),
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, a, b) => DetailPage(
                          stationInfo: stationen[0],
                        ),
                      ),
                    );
                  }),
              SizedBox(height: 50),
              RaisedButton(
                  child: Text("Karte"),
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => navigator(),
                      ),
                    );
                  }),
              SizedBox(height: 50),
              RaisedButton(
                  child: Text("Startseite"),
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
