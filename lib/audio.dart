import 'package:flutter/material.dart';
import 'dart:math';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'dart:convert';

class Audio {
  AssetsAudioPlayer aap;
  List<String> _assetPaths = [];

  Future<void> getAssetPaths(BuildContext context) async {
    print('Inside getAssetPaths()');
    if (DefaultAssetBundle == null) return null;
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    //print('bbb $manifestContent');
    final Map<String, dynamic> manifestMap = await json.decode(manifestContent);
    //print('ccc $manifestMap');
    final paths = manifestMap.keys
        .where((String key) => key.contains('assets/'))
        .where((String key) => key.contains('.mp3'))
        .toList();

    for (int i = 0; i < paths.length; i++) {
      paths[i] = paths[i].substring(7);
    }
    //print('ddd $paths');
    //setState(() {
    _assetPaths = paths;
    //});
  }

  String _getRandomBeep() {
    print('Inside _getRandomBeep()');
    Random rnd = Random();
    int min = 0;
    int max = _assetPaths.length - 1;
    return _assetPaths[min + rnd.nextInt(max - min)];
  }

  void start() async {
    print('Inside start()');
    aap = AssetsAudioPlayer();
    aap.open(AssetsAudio(
      asset: _getRandomBeep(),
      folder: "assets/",
    ));
  }

  void stopAudio() {
    print('Inside stopAudio()');
    if (aap != null) {
      aap.stop();
      aap.dispose();
      aap = null;
    }
  }

  void reset() {
    print('Inside reset()');
    stopAudio();
  }
}
