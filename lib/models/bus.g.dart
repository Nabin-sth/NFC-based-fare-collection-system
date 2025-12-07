// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bus _$BusFromJson(Map<String, dynamic> json) => Bus(
  id: json['id'] as String,
  busNumber: json['busNumber'] as String,
  currentLocation: json['currentLocation'] == null
      ? null
      : LocationModel.fromJson(json['currentLocation'] as Map<String, dynamic>),
  ownerId: json['ownerId'] as String,
  active: json['active'] as bool,
  rfidDeviceId: json['rfidDeviceId'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$BusToJson(Bus instance) => <String, dynamic>{
  'id': instance.id,
  'busNumber': instance.busNumber,
  'currentLocation': instance.currentLocation?.toJson(),
  'ownerId': instance.ownerId,
  'active': instance.active,
  'rfidDeviceId': instance.rfidDeviceId,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
