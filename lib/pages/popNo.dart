import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:score_scanner/modules/themechanger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class popNo extends StatefulWidget {
  popNo({Key? key}) : super(key: key);

  @override
  _popNoState createState() => _popNoState();
}

class _popNoState extends State<popNo> {
  int _counter = 0;
  SharedPreferences? preferences;
  String path = "assets/img/pop1.png";
  late final AudioCache _audioCache;

  @override
  void initState() {
    super.initState();
    _audioCache = AudioCache(
      prefix: 'mp3/',
      fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP),
    );
     initializePreference().whenComplete((){
       setState(() {});
     });
  }

  Future<void> initializePreference() async{
    this.preferences = await SharedPreferences.getInstance();
    setState(() {
      _counter = (preferences!.getInt('counter') ?? 0);

    });
  }

  Future<void> _storeIncrement(int yourValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', yourValue);
  }

  Future<AudioPlayer> playPop() async {
      AudioCache cache = new AudioCache();
      return await cache.play("mp3/pop.mp3");
  }

  Future<AudioPlayer> playNo() async {
      AudioCache cache = new AudioCache();
      return await cache.play("mp3/no.mp3");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('popNo Mini-Game'),
      ),
      body: GestureDetector(
        onTap: () async {
          setState(() {
            if(_counter % 2 == 0) {
              path = "assets/img/pop3.png";
              playPop();
            } else {
              path = "assets/img/pop1.png";
              playNo();
            }
            _counter++;
            _storeIncrement(_counter);
          });
        },
        child: Column(
          children: [
            Container(
              child: Image(
              image: AssetImage(path),
              fit: BoxFit.fitHeight,
              ),
            ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "\nPop No\n ${_counter}",
                  style: TextStyle(fontWeight: FontWeight.bold)
                ),
                  TextSpan(
                    text: "\nMade with\n",       
                  ),
                  WidgetSpan(
                    child: Icon(Icons.favorite, size: 20,)
                  ),
                  TextSpan(
                    text: "\n\"Jai- G R A Y R A Y\"\n",
                    style: TextStyle(fontWeight: FontWeight.bold)       
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            )
          ],
        )
        // Image.asset(path)
      )
    );

  }
}