import 'package:flutter/material.dart';
import 'dart:io';
import 'constants.dart';
import 'main.dart';

// Downloader

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart'; // Um den zugewiesenen Speicherpfad zu erhalten
import 'package:archive/archive.dart'; // unzip

class Filesdownload extends StatefulWidget {
  const Filesdownload({Key? key}) : super(key: key);

  @override
  State createState() {
    return _DownloadFileState();
  }
}

class _DownloadFileState extends State {
  final List<String> _files = [];
  String downloadingStr = "Vorbereiten";
  bool downloading = false;

  Future<void> _downloadAndUnzip() async {
    downloading = true;
    downloadingStr = "Herunterladen...";
    setState(() {});
    const url =
        "https://github.com/LukasGasp/Klosterguide-Videos/archive/refs/heads/main.zip";
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final dir = await getApplicationDocumentsDirectory();
    downloadingStr = "Entpacken und Speichern...";
    setState(() {});
    final file = File('${dir.path}/myfile.zip');
    await file.writeAsBytes(bytes);
    final archive = ZipDecoder().decodeBytes(bytes);
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile && filename.isNotEmpty) {
        _files.add(filename);

        final data = file.content as List<int>;
        File('${dir.path}/$filename')
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      }
      print("New _files: $_files");
    }
    downloadingStr = "Sie sind auf dem neuesten Stand!";
    downloading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.home),
        backgroundColor: primarymapbuttoncolor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Tourvideos herunterladen",
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: 42,
                  color: primaryTextColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Divider(color: endcardTextColor),
              const SizedBox(
                height: 20,
              ),
              downloading
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                          child: Text(
                            "Der Download läuft...",
                            style: TextStyle(
                              fontFamily: 'Avenir',
                              fontSize: 17,
                              color: contentTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        CircularProgressIndicator(color: appbarcolor),
                        const SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                          child: Text(
                            "Dies kann einige Minuten dauern.\nBitte schließen Sie die App nicht!",
                            style: TextStyle(
                              fontFamily: 'Avenir',
                              fontSize: 17,
                              color: contentTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Text(
                          downloadingStr,
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 17,
                            color: primaryTextColor,
                            fontWeight: FontWeight.w700,

                          ),
                        )
                      ],
                    )
                  : Column(
                      children: [
                        // Infotext with smaller font size and normal style
                        Padding(
                          padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                          child: Text(
                            "Für eine reibungslose Erfahrung müssen die in der App verwendeten Videos auf Ihr Gerät heruntergeladen werden. Dies nimmt ca. SPEICHER Speicher in Anspruch.\n\nJe nach Vertrag und Verbindung können Kosten durch Internetnutzung anfallen.\nWir empfehlen daher eine WLAN-Verbindung. Diese können Sie beispielsweise im Klosterhof oder daheim finden.",
                            style: TextStyle(
                              fontFamily: 'Avenir',
                              fontSize: 17,
                              color: contentTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width>=500)?180:MediaQuery.of(context).size.width*180*0.002,
                          child: FloatingActionButton(
                            onPressed: _downloadAndUnzip,
                            backgroundColor: primarybuttoncolor,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Icon for downloading
                                Icon(Icons.download_rounded,
                                    size: 40, color: Colors.white),
                                // Padding between icon and text
                                // Text for download
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  DemoLocalizations.of(context)!
                                      .getText("download"),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
