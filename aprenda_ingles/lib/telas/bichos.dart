import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';

class Bichos extends StatefulWidget {
  @override
  _BichosState createState() => _BichosState();
}

class _BichosState extends State<Bichos> {
  var _audioCache = AudioCache(prefix: "audios/");

  _executar(String nomeAudio) {
    _audioCache.play(nomeAudio + ".mp3");
  }

  @override
  void initState() {
    super.initState();
    _audioCache.loadAll([
      "cao.mp3",
      "gato.mp3",
      "leao.mp3",
      "macaco.mp3",
      "ovelha.mp3",
      "vaca.mp3",
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: MediaQuery.of(context).size.aspectRatio * 2,
      children: <Widget>[
        GestureDetector(
          child: Image.asset("assets/images/cao.png"),
          onTap: () {
            _executar("cao");
          },
        ),
        GestureDetector(
          child: Image.asset("assets/images/gato.png"),
          onTap: () {
            _executar("gato");
          },
        ),
        GestureDetector(
          child: Image.asset("assets/images/leao.png"),
          onTap: () {
            _executar("leao");
          },
        ),
        GestureDetector(
          child: Image.asset("assets/images/macaco.png"),
          onTap: () {
            _executar("macaco");
          },
        ),
        GestureDetector(
          child: Image.asset("assets/images/ovelha.png"),
          onTap: () {
            _executar("ovelha");
          },
        ),
        GestureDetector(
          child: Image.asset("assets/images/vaca.png"),
          onTap: () {
            _executar("vaca");
          },
        ),
      ],
    );
  }
}
