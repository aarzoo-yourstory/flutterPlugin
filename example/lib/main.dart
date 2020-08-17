import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:battery_level/battery_level.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  static Map<String, String> jwParam = {'platform': 'jwplayer', 'videoid': "https://cdn.jwplayer.com/manifests/VNmtzuvq.m3u8"};
  static Map<String, String> ytParam = {'platform': 'youtube', 'videoid': "BHzod3UIvcE"};
  static Map<String, String> param = jwParam;
  UiKitView _videoPlayerView = UiKitView(viewType: 'CustomVideoPlayer',
//      creationParams: {'platform': 'youtube', 'videoid': "BHzod3UIvcE"},
    creationParams: param,
      onPlatformViewCreated: null,
      creationParamsCodec: StandardMessageCodec(),
  );
  
  @override
  void initState() {
    super.initState();
    _showVideo();
  }

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final result = await BatteryLevel.getBatteryLevel;
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _platformVersion = batteryLevel;
    });
  }

  void _showVideo() async{
//    await BatteryLevel.showVideo();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: Icon(CupertinoIcons.back),
          middle: Text('Aarzoo plugin'),
        ),
        child: Center(
          child: SafeArea(
            maintainBottomViewPadding: true,
            child: Column(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                RaisedButton(
                  child: Text('Get Battery Level'),
                  onPressed: _getBatteryLevel,
                ),
                Text(_platformVersion),
                Text('VideoView'),
                SizedBox(
                  height: 300,
                  width: 500,
                  child: _videoPlayerView,
                ),
                Row(
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Play yt'),
                      onPressed: (){
                        BatteryLevel.playYTVideo();
                      },
                    ),
                    RaisedButton(
                      child: Text('Stop yt'),
                      onPressed: (){
                        BatteryLevel.stopYTVideo();
                      },
                    ),
                  ],
                ),

                Row(
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Play jw'),
                      onPressed: (){
                        BatteryLevel.playJWVideo();
                      },
                    ),
                    RaisedButton(
                      child: Text('Stop jw'),
                      onPressed: (){
                        BatteryLevel.stopJWVideo();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )

    );
  }
}
