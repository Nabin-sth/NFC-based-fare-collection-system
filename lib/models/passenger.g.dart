// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Passenger _$PassengerFromJson(Map<String, dynamic> json) => Passenger(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String?,
  NIDNumber: json['NIDNumber'] as String?, // ignore: non_constant_identifier_names 
  rfid: json['rfid'] as String?, // ignore: non_constant_identifier_names    
  balance: (json['balance'] as num).toDouble(),
  onboard: json['onboard'] as bool,
  verified: json['verified'] as bool,
  currentLocation: json['currentLocation'] == null
      ? null
      : LocationModel.fromJson(json['currentLocation'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$PassengerToJson(Passenger instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'NIDNumber': instance.NIDNumber, // ignore: non_constant_identifier_names
  'rfid': instance.rfid, // ignore: non_constant_identifier_names
  'balance': instance.balance,
  'onboard': instance.onboard,
  'verified': instance.verified,
  'currentLocation': instance.currentLocation?.toJson(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
