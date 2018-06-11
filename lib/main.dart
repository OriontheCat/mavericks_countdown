import 'package:flutter/material.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Countdown',
      theme: new ThemeData(
          primarySwatch: Colors.green,
          primaryColor: Colors.white,
          primaryTextTheme:
              new TextTheme(title: new TextStyle(color: Colors.white))),
      home: new MyHomePage(title: 'Mavericks Proving Grounds Countdown'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool autoLaunch = true;
  Future<Null> _launched;

  Future<Null> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _setAutoLaunch(bool val) {
    autoLaunch = val;
    setState(() {});
  }

  String _countdownDivider = ":";

  String formattedInt(int val, int digits) {
    String zero = "0";
    String valToString = val.toString();
    while (digits > valToString.length) {
      valToString = zero + valToString;
    }
    return valToString;
  }

  @override
  Widget build(BuildContext context) {
    Timer timer = new Timer(new Duration(seconds: 1), () {
      setState(() {});
    });
    DateTime releaseDate = DateTime.utc(2018, 6, 11, 22, 10);
    DateTime now = new DateTime.now().toUtc();
    Duration _timeLeft = releaseDate.difference(now);
    if (_timeLeft.inMilliseconds <= 5000 && autoLaunch) {
      _launchInBrowser("https://mavericks.gg/");
    }
    int _hoursCounter = _timeLeft.inHours;
    int _minutesCounter = ((_timeLeft.inSeconds % 360) / 60).round();
    int _secondsCounter = _timeLeft.inSeconds % 60;
    return new Scaffold(
        body: new Container(
      decoration: new BoxDecoration(
          image: new DecorationImage(
        image: new AssetImage("assets/slice_1.jpg"),
        fit: BoxFit.fitHeight,
        alignment: Alignment(0.3, -1.0),
      )),
      child: new Center(
          child: Stack(
        children: <Widget>[
          new Center(
            child: new ListTile(
                title: new FittedBox(
                    child: Text(
                        formattedInt(_hoursCounter, 2) +
                            _countdownDivider +
                            formattedInt(_minutesCounter, 2) +
                            _countdownDivider +
                            formattedInt(_secondsCounter, 2),
                        style: TextStyle(color: Colors.white)))),
          ),
          new Padding(
              child: Image(
                image: new AssetImage('assets/mpg_logo_text_only.png'),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15.0)),
          new Container(
              child: new Row(
                children: <Widget>[
                  new Text(
                    "Auto launch mavericks.gg",
                    style: TextStyle(color: Colors.white),
                  ),
                  new Switch(
                    value: autoLaunch,
                    onChanged: _setAutoLaunch,
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              alignment: Alignment.bottomCenter)
        ],
        alignment: Alignment(0.0, -0.6),
      )),
    ));
  }
}
