import 'package:json_annotation/json_annotation.dart';

import 'location_model.dart';

part 'passenger.g.dart';

@JsonSerializable(explicitToJson: true)
class Passenger {
  const Passenger({
    required this.id,
    required this.name,
    required this.email,  
    this.phone,
    this.NIDNumber, // ignore: non_constant_identifier_names
    this.rfid, // ignore: non_constant_identifier_names  
    required this.balance,
    required this.onboard,
    required this.verified,
    this.currentLocation,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) {
    // Handle field name variations and nulls defensively
    final id = json['id'] as String? ?? json['_id'] as String? ?? 'unknown-id';
    final name = json['name'] as String? ?? 
                 json['fullName'] as String? ?? 
                 'Unknown User';
    final email = json['email'] as String? ?? 'no-email@unknown.com';
    final phone = json['phone'] as String? ?? 
                  json['phoneNumber'] as String?;
    final nidNumber = json['NIDNumber'] as String? ?? 
                      json['citizenshipNumber'] as String?;
    final rfid = json['rfid'] as String? ?? 
                 json['rfidNumber'] as String?;
    final balance = (json['balance'] as num?)?.toDouble() ?? 0.0;
    final onboard = json['onboard'] as bool? ?? 
                    json['isOnboard'] as bool? ?? 
                    false;
    final verified = json['verified'] as bool? ?? 
                     json['isVerified'] as bool? ?? 
                     false;
    final currentLocation = json['currentLocation'] != null
        ? LocationModel.fromJson(json['currentLocation'] as Map<String, dynamic>)
        : null;
    
    DateTime createdAt;
    try {
      final createdAtStr = json['createdAt'] as String?;
      createdAt = createdAtStr != null 
          ? DateTime.parse(createdAtStr)
          : DateTime.now();
    } catch (e) {
      createdAt = DateTime.now();
    }
    
    DateTime updatedAt;
    try {
      final updatedAtStr = json['updatedAt'] as String?;
      updatedAt = updatedAtStr != null 
          ? DateTime.parse(updatedAtStr)
          : DateTime.now();
    } catch (e) {
      updatedAt = DateTime.now();
    }

    return Passenger(
      id: id,
      name: name,
      email: email,
      phone: phone?.isEmpty == true ? null : phone,
      NIDNumber: nidNumber?.isEmpty == true ? null : nidNumber,
      rfid: rfid?.isEmpty == true ? null : rfid,
      balance: balance,
      onboard: onboard,
      verified: verified,
      currentLocation: currentLocation,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? NIDNumber; // ignore: non_constant_identifier_names
  final String? rfid; // ignore: non_constant_identifier_names
  final double balance;
  final bool onboard;
  final bool verified;
  final LocationModel? currentLocation;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => _$PassengerToJson(this);

  Passenger copyWith({
    double? balance,
    bool? onboard,
    bool? verified,
    LocationModel? currentLocation,
  }) {
    return Passenger(
      id: id,
      name: name,
      email: email,
      phone: phone,
      NIDNumber: NIDNumber, // ignore: non_constant_identifier_names    
      rfid: rfid, // ignore: non_constant_identifier_names
      balance: balance ?? this.balance,
      onboard: onboard ?? this.onboard,
      verified: verified ?? this.verified,
      currentLocation: currentLocation ?? this.currentLocation,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

