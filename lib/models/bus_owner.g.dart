// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus_owner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusOwner _$BusOwnerFromJson(Map<String, dynamic> json) => BusOwner(
  id: json['id'] as String,
  fullName: json['fullName'] as String,
  email: json['email'] as String,
  phoneNumber: json['phoneNumber'] as String,
  isVerified: json['isVerified'] as bool,
  ownedBusIds: (json['ownedBusIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$BusOwnerToJson(BusOwner instance) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.fullName,
  'email': instance.email,
  'phoneNumber': instance.phoneNumber,
  'isVerified': instance.isVerified,
  'ownedBusIds': instance.ownedBusIds,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
