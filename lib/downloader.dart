import 'package:flutter/material.dart';
import 'dart:io';
import 'constants.dart';

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
      appBar: AppBar(
        title: const Text("Update"),
        backgroundColor: appbarcolor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Tourvideos herunterladen",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 80,
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
                        height: 60,
                      ),
                      CircularProgressIndicator(color: appbarcolor),
                      const SizedBox(
                        height: 60,
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
                        height: 20,
                      ),
                      Text(
                        downloadingStr,
                        style: const TextStyle(color: Colors.black),
                      )
                    ],
                  )
                : Column(
                    children: [
                      // Infotext with smaller font size and normal style
                      Padding(
                        padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                        child: Text(
                          "Für eine Reibungslose Erfahrung müssen die Videos herunter geladen werden. Dies nimmt ca. SPEICHER in Anspruch.\n\nJe nach Vertrag und Verbindung können kosten durch Internetnutzung anfallen.\nWir empfehlen daher eine WLAN Verbindung. Diese können Sie Beispielsweise im Klosterhof oder Daheim finden.",
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
                        height: 60,
                      ),
                      Container(
                        // Margin around the button
                        margin: const EdgeInsets.all(10),
                        // Rounded rectangle shape
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          // Gradient background color
                          gradient: const LinearGradient(
                            colors: [Color(0xff518d80), Color(0xFF324851)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: TextButton(
                          onPressed: _downloadAndUnzip,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              // Icon for downloading
                              Icon(Icons.download_rounded,
                                  size: 40, color: Colors.white),
                              // Padding between icon and text
                              SizedBox(width: 10),
                              // Text for download
                              Text(
                                'Download',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
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
    );
  }
}
