import 'package:json_annotation/json_annotation.dart';

part 'ble_doubt_device.g.dart';

@JsonSerializable()
class BleDoubtDevice {
  String address;
  String name;
  String type;
  String id1;
  String id2;
  String id3;
  int manufacturer;
  String parserId;
  bool isSafe;
  bool isSuspicious;

  BleDoubtDevice(this.address, this.name, this.type, this.id1, this.id2, this.id3, this.manufacturer, this.parserId,
      this.isSafe, this.isSuspicious);
  factory BleDoubtDevice.fromJson(Map<String, dynamic> json) => _$BleDoubtDeviceFromJson(json);
  Map<String, dynamic> toJson() => _$BleDoubtDeviceToJson(this);
}
