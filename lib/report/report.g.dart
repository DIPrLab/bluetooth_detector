// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) => Report(
      (json['report'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, e == null ? null : Device.fromJson(e as Map<String, dynamic>)),
      ),
    )..time = DateTime.parse(json['time'] as String);

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      "\"time\"": "\"${instance.time.toIso8601String()}\"",
      "\"report\"": instance.report.map((a, b) => MapEntry("\"${a}\"", "${b?.toJson() ?? ""}")),
    };
