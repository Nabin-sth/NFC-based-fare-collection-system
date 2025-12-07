import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../providers/bus_providers.dart';
import '../../utils/map_helpers.dart';

class OwnerLiveBusTrackingPage extends ConsumerWidget {
  const OwnerLiveBusTrackingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busesAsync = ref.watch(busesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Fleet Map')),
      body: busesAsync.when(
        data: (buses) {
          // if (buses.isEmpty || buses.first.currentLocation == null) {
          //   return const Center(child: Text('No live buses to display'));
          // }
          return GoogleMap(
            initialCameraPosition:
                MapHelpers.initialCameraPosition(buses.first.currentLocation),
            markers: buses
                // .where((bus) => bus.currentLocation != null)
                .map(
                  (bus) => Marker(
                    markerId: MarkerId(bus.id),
                    position: LatLng(41.881832, -87.623177),
                      // bus.currentLocation!.latitude,
                      // bus.currentLocation!.longitude,
                    // ),
                    infoWindow: InfoWindow(
                      title: bus.busNumber,
                      snippet:
                          'Rfid Device ID: ${bus.rfidDeviceId}',
                    ),
                  ),
                )
                .toSet(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, stackTrace) => Center(child: Text('$error')),
      ),
    );
  }
}

