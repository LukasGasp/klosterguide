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
    final dir = await getApplicationSupportDirectory();
    downloadingStr = "Entpacken und Speichern...";
    setState(() {});
    final file = File('${dir.path}/myfile.zip');
    await file.writeAsBytes(bytes);
    final archive = ZipDecoder().decodeBytes(bytes);
    for (final file in archive) {
      final filename = file.name;
      print("File: $filename");
      if (file.isFile && filename.isNotEmpty) {
        _files.add(filename);
        print("New _files: $_files");

        final data = file.content as List<int>;
        File('${dir.path}/$filename')
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      }
    }
    print("Extracting done...");
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
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            const SizedBox(
              height: 80,
            ),
            downloading
                ? Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "Dies kann einige Minuten dauern",
                        style: TextStyle(color: Colors.black),
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
                : TextButton(
                    onPressed: _downloadAndUnzip,
                    child: const Text('Download'),
                  ),
          ],
        ),
      ),
    );
  }
}
