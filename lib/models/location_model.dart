import 'package:json_annotation/json_annotation.dart';

part 'location_model.g.dart';

@JsonSerializable()
class LocationModel {
  const LocationModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.recordedAt,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);

    normalized['id'] ??= json['_id'];
    if (normalized['id'] == null) {
      throw const FormatException('Location payload missing "id"');
    }

    normalized['latitude'] ??= json['lat'];
    normalized['longitude'] ??= json['lng'] ?? json['lon'];
    if (normalized['latitude'] == null || normalized['longitude'] == null) {
      throw const FormatException('Location payload missing coordinates');
    }

    normalized['recordedAt'] ??= json['recorded_at'] ?? json['timestamp'];
    if (normalized['recordedAt'] == null) {
      throw const FormatException('Location payload missing "recordedAt"');
    }

    return _$LocationModelFromJson(normalized);
  }

  final String id;
  final double latitude;
  final double longitude;
  final DateTime recordedAt;

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);
}

