// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ble_doubt_detection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BleDoubtDetection _$BleDoubtDetectionFromJson(Map<String, dynamic> json) => BleDoubtDetection(
      (json['lat'] as num).toDouble(),
      (json['long'] as num).toDouble(),
      json['mac'] as String,
      (json['rssi'] as num).toInt(),
      DateTime.parse(json['t'] as String),
    );

Map<String, dynamic> _$BleDoubtDetectionToJson(BleDoubtDetection instance) => <String, dynamic>{
      "\"lat\"": instance.lat,
      "\"long\"": instance.long,
      "\"mac\"": instance.mac,
      "\"rssi\"": instance.rssi,
      "\"t\"": instance.t.toIso8601String(),
    };
