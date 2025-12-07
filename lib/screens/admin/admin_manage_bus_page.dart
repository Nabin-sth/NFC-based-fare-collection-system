import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../../providers/bus_providers.dart';

class AdminManageBusPage extends ConsumerWidget {
  const AdminManageBusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busesAsync = ref.watch(busesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Buses')),
      body: busesAsync.when(
        data: (buses) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final bus = buses[index];
            return ListTile(
              title: Text(bus.busNumber),
              subtitle: Text('Owner: ${bus.ownerId}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () async {
                  final api = ref.read(apiServiceProvider);
                  await api.deleteBus(bus.id);
                  ref.invalidate(busesProvider);
                },
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

