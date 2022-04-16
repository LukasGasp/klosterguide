import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'constants.dart';
import 'package:archive/archive.dart';

class Filesdownload extends StatefulWidget {
  const Filesdownload({Key? key}) : super(key: key);

  @override
  State createState() {
    return _DownloadFileState();
  }
}

class _DownloadFileState extends State {
  var imageUrl =
      "https://github.com/LukasGasp/Klosterguide-Videos/archive/refs/heads/main.zip";
  String downloadingStr = "Download...";
  String savePath = "";

  @override
  void initState() {
    super.initState();
    downloadFile();
  }

  Future downloadFile() async {
    try {
      Dio dio = Dio();

      String fileName = imageUrl.substring(imageUrl.lastIndexOf("/") + 1);
      String download = "";
      savePath = await getFilePath(fileName);
      print("Savepath:" + savePath);
      print("Filename:" + fileName);
      await dio.download(imageUrl, savePath, onReceiveProgress: (rec, total) {
        setState(() {
          if (total != -1) {
            download = ((rec / total) * 100).toInt().toString() + " %";
          } else {
            download = "Download...";
          }
          downloadingStr = download;
        });
      });
      setState(() {
        downloadingStr = "Done";
        Navigator.pop(context);
        print("Done");
      });

      decompress(fileName);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> getFilePath(uniqueFileName) async {
    String path = '';

    Directory dir = await getApplicationDocumentsDirectory();

    path = '${dir.path}/$uniqueFileName';

    return path;
  }

  Future decompress(String savepath) async {
    print("Decompress");
    var file = File(savePath);

    var bytes = file.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);

    print("Savepath:" + savePath);

    String download = "Dekomprimiere...\nDies kann einige Minuten dauern...";

    for (var file in archive) {
      var filename = '$savePath/${file.name}';
      if (file.isFile) {
        var outFile = File(filename);
        outFile = await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content);
      }
      print(filename);
    }
  }

  Future<bool> _hasToDownloadAssets(String name, String dir) async {
    var file = File('$dir/$name.zip');
    return !(await file.exists());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text("Stationsupdate"),
        backgroundColor: appbarcolor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            const CircularProgressIndicator(),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Tourvideos werden heruntergeladen",
              style: TextStyle(color: Colors.white),
            ),
            const Text(
              "Dies kann einige Minuten dauern",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              downloadingStr,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
