import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BatteryLevel {
  static const MethodChannel _channel =
      const MethodChannel('test.battery_level');

  static const MethodChannel _videochannel =
  const MethodChannel('com.yourstory.videoplayer');

  String _batteryLevel = 'Unknown battery level.';

  static Future<String> get getBatteryLevel async {
    String batteryLevel;

    try {
      final result = await _channel.invokeMethod('getBatteryLevel');
      print('test: $result');
      batteryLevel = 'test $result';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }
    return batteryLevel;
  }

  static Future<void> showVideo() async{
    await _channel.invokeMethod('showVideo');
    return null;
  }

  static Future<void> playYTVideo() async{
    await _videochannel.invokeMethod('playYT');
    return null;
  }

  static Future<void> loadYTVideo() async{
    await _videochannel.invokeMethod('loadYT');
    return null;
  }

  static Future<void> stopYTVideo() async{
    await _videochannel.invokeMethod('stopYT');
    return null;
  }

  static Future<void> loadJWVideo() async{
    await _videochannel.invokeMethod('loadJW');
    return null;
  }

  static Future<void> playJWVideo() async{
    await _videochannel.invokeMethod('playJW');
    return null;
  }

  static Future<void> stopJWVideo() async{
    await _videochannel.invokeMethod('stopJW');
    return null;
  }
}
