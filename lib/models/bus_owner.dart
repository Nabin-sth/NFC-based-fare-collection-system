import 'package:json_annotation/json_annotation.dart';

part 'bus_owner.g.dart';

@JsonSerializable()
class BusOwner {
  const BusOwner({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.isVerified,
    required this.ownedBusIds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BusOwner.fromJson(Map<String, dynamic> json) =>
      _$BusOwnerFromJson(json);

  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final bool isVerified;
  final List<String> ownedBusIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => _$BusOwnerToJson(this);
}

