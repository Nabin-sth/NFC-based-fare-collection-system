import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/location_model.dart';

class MapHelpers {
  static CameraPosition initialCameraPosition(
    LocationModel? location,
  ) {
    if (location == null) {
      return const CameraPosition(
        target: LatLng(28.2096, 83.9856), // Pokhara reference from report
        zoom: 12,
      );
    }
    return CameraPosition(
      target: LatLng(location.latitude, location.longitude),
      zoom: 15,
    );
  }

  static Set<Marker> markersFromLocations(List<LocationModel> locations) {
    return locations
        .map(
          (location) => Marker(
            markerId: MarkerId(location.id),
            position: LatLng(location.latitude, location.longitude),
            infoWindow: InfoWindow(
              title: 'Last ping',
              // snippet: location.recordedAt.toLocal().toString(),
            ),
          ),
        )
        .toSet();
  }
}

