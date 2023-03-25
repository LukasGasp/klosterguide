import 'package:flutter/material.dart';
import 'dart:io';
import 'constants.dart';

// Downloader

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart'; // Um den zugewiesenen Speicherpfad zu erhalten
import 'package:archive/archive.dart';

import 'main.dart'; // unzip

class Filesdownload extends StatefulWidget {
  const Filesdownload({Key? key}) : super(key: key);

  @override
  State createState() {
    return _DownloadFileState();
  }
}

class _DownloadFileState extends State {
  String downloadingStr = "Vorbereiten";
  bool downloading = false;
  bool directoryExists = false;
  bool loading = false;

  // Checkt, ob der Download Ordner existiert
  void downloadedvideos() async {
    loading = true;
    Directory directory = await getApplicationDocumentsDirectory();
    setState(() {
      directoryExists =
          Directory(directory.path + "/Klosterguide-Videos-main").existsSync();
    });
    loading = false;
  }

  Future<void> _downloadAndUnzip() async {
    downloading = true;
    downloadingStr = "Herunterladen...";
    print("Starting download");
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
        final data = file.content as List<int>;
        File('${dir.path}/$filename')
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      }
      print("New File: $filename");
    }
    downloadingStr = "Sie sind auf dem neuesten Stand!";
    downloading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    downloadedvideos();
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
                          padding:
                              const EdgeInsets.only(left: 32.0, right: 32.0),
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
                          padding:
                              const EdgeInsets.only(left: 32.0, right: 32.0),
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
                  : directoryExists

                      // Videos existieren
                      ? Column(
                          children: [
                            Text(
                              "Gratulation! Sie sind auf dem neuesten Stand!\n\n\nGehen Sie zum Home-Menü, um eine Tour zu starten.\n\n\nSie können die Videos über folgenden Button neu",
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                fontSize: 17,
                                color: contentTextColor,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width >= 500)
                                  ? 180
                                  : MediaQuery.of(context).size.width *
                                      250 *
                                      0.0022,
                              child: FloatingActionButton(
                                onPressed: _downloadAndUnzip,
                                backgroundColor: Colors.orange,
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
                                    const Icon(Icons.download_rounded,
                                        size: 40, color: Colors.white),
                                    // Padding between icon and text
                                    // Text for download
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        DemoLocalizations.of(context)!
                                            .getText("download"),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      :
                      // Videos existieren nicht
                      Column(
                          children: [
                            // Infotext with smaller font size and normal style
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 32.0, right: 32.0),
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
                              width: (MediaQuery.of(context).size.width >= 500)
                                  ? 180
                                  : MediaQuery.of(context).size.width *
                                      250 *
                                      0.0022,
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
                                    const Icon(Icons.download_rounded,
                                        size: 40, color: Colors.white),
                                    // Padding between icon and text
                                    // Text for download
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        DemoLocalizations.of(context)!
                                            .getText("download"),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
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
