import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/bus_providers.dart';

class OwnerBusListPage extends ConsumerWidget {
  const OwnerBusListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busesAsync = ref.watch(busesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Registered Buses')),
      body: busesAsync.when(
        data: (buses) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final bus = buses[index];
            return ListTile(
              leading: CircleAvatar(child: Text(bus.busNumber.substring(0, 2))),
              title: Text(bus.busNumber),
              subtitle: Text('Rfid Device ID: ${bus.rfidDeviceId}'),
              trailing: Icon(
                bus.isOnline ? Icons.wifi : Icons.wifi_off,
                color: bus.isOnline ? Colors.green : Colors.red,
              ),
            );
          },
          separatorBuilder: (context, _) => const Divider(),
          itemCount: buses.length,
        ),
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, stackTrace) => Center(child: Text('$error')),
      ),
    );
  }
}

