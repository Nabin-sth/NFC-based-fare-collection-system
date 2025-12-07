import 'package:json_annotation/json_annotation.dart';

import 'location_model.dart';

part 'bus.g.dart';

@JsonSerializable(explicitToJson: true)
class Bus {
  const Bus({
    required this.id,
    required this.busNumber,
    // required this.busType,
    // required this.seatCapacity,
    required this.currentLocation,
    required this.ownerId,
    required this.active,
    required this.rfidDeviceId,
    // required this.lastPingedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);

    normalized['id'] ??= json['_id'];
    if (normalized['id'] == null) {
      throw const FormatException('Bus payload missing "id"');
    }

    normalized['busNumber'] ??= json['bus_number'];
    if (normalized['busNumber'] == null) {
      throw const FormatException('Bus payload missing "busNumber"');
    }

    normalized['ownerId'] ??= json['owner_id'];
    if (normalized['ownerId'] == null) {
      final ownerPayload = json['owner'];
      if (ownerPayload is Map<String, dynamic>) {
        normalized['ownerId'] =
            ownerPayload['id'] ?? ownerPayload['_id'] ?? ownerPayload['ownerId'];
      }
    }
    if (normalized['ownerId'] == null) {
      throw const FormatException('Bus payload missing "ownerId"');
    }

    normalized['rfidDeviceId'] ??= json['rfid'];
    if (normalized['rfidDeviceId'] == null) {
      throw const FormatException('Bus payload missing "rfidDeviceId"');
    }

    normalized['active'] ??= json['isActive'] ?? false;
    normalized['createdAt'] ??= json['created_at'];
    normalized['updatedAt'] ??= json['updated_at'];

    return _$BusFromJson(normalized);
  }

  final String id;
  final String busNumber;
  // final String busType;
  // final int seatCapacity;
  final LocationModel? currentLocation;
  final String ownerId;
  final bool active;
  final String rfidDeviceId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => _$BusToJson(this);

  bool get isOnline =>
      DateTime.now().difference(updatedAt).inMinutes < 5;
}

