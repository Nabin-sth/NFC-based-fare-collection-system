import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/bus.dart';
import '../../models/location_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/bus_providers.dart';
import '../../utils/map_helpers.dart';

class PassengerMapTrackingPage extends ConsumerStatefulWidget {
  const PassengerMapTrackingPage({super.key});
  
  @override
  ConsumerState<PassengerMapTrackingPage> createState() =>
      _PassengerMapTrackingPageState();
}

class _PassengerMapTrackingPageState
    extends ConsumerState<PassengerMapTrackingPage> {
  Timer? _timer;
  Bus? _selectedBus;
  LocationModel? _latestLocation;
  GoogleMapController? _controller;

  @override
  void dispose() {
    _timer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  void _startPolling() {
    _timer?.cancel();
    if (_selectedBus == null) return;
    final api = ref.read(apiServiceProvider);
    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      try {
        final location = await api.pollBusLocation(_selectedBus!.id);
        if (!mounted) return;
        setState(() {
          _latestLocation = location;
        });
        _controller?.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(location.latitude, location.longitude),
          ),
        );
      } catch (error) {
        debugPrint('Polling error: $error');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final busesAsync = ref.watch(busesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Live Bus Tracking')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: busesAsync.when(
              data: (buses) => DropdownButton<Bus>(
                value: _selectedBus,
                hint: const Text('Select a bus'),
                isExpanded: true,
                items: buses
                    .map(
                      (bus) => DropdownMenuItem(
                        value: bus,
                        child: Text(bus.busNumber),
                      ),
                    )
                    .toList(),
                onChanged: (bus) {
                  setState(() {
                    _selectedBus = bus;
                    _latestLocation = bus?.currentLocation;
                  });
                  _startPolling();
                },
              ),
              loading: () => const LinearProgressIndicator(),
              error: (error, stackTrace) => Text('$error'),
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition:
                  MapHelpers.initialCameraPosition(_latestLocation),
              markers: _latestLocation == null
                  ? {}
                  : MapHelpers.markersFromLocations([_latestLocation!]),
              onMapCreated: (controller) => _controller = controller,
            ),
          ),
        ],
      ),
    );
  }
}

