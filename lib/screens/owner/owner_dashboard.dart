import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/bus_providers.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/info_card.dart';

class OwnerDashboard extends ConsumerWidget {
  const OwnerDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busesAsync = ref.watch(busesProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    print("busesAsync:${busesAsync.valueOrNull}");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Dashboard'),
        actions: [
          IconButton(
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).logout();
              if (context.mounted) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/splash', (route) => false);
              }
            },
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: busesAsync.when(
        data: (buses) {
          final totalBuses = buses.length;
          final onlineBuses = buses.where((bus) => bus.isOnline).length;
          final offlineBuses = buses.where((bus) => bus.isOnline == false).length;
          print("buses:${buses}");
          print("onlineBuses:${onlineBuses}");
          print("offlineBuses:${offlineBuses}");
          print("totalBuses:${totalBuses}");
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(busesProvider);
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Operational Snapshot',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Metrics Grid
                Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        label: 'Total Buses',
                        value: totalBuses.toString(),
                        icon: Icons.directions_bus_rounded,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricCard(
                        label: 'Online',
                        value: onlineBuses.toString(),
                        icon: Icons.check_circle_rounded,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricCard(
                        label: 'Offline',
                        value: offlineBuses.toString(),
                        icon: Icons.cancel_rounded,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Quick Actions
                Text(
                  'Quick Actions',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                InfoCard(
                  title: 'Revenue Insights',
                  subtitle: 'Charts for daily/weekly/monthly analysis',
                  icon: Icons.show_chart_rounded,
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/owner/revenue',
                  ),
                ),
                const SizedBox(height: 12),
                InfoCard(
                  title: 'Fleet Management',
                  subtitle: 'Manage RFID-equipped buses',
                  icon: Icons.directions_bus_rounded,
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/owner/buses',
                  ),
                ),
                const SizedBox(height: 12),
                InfoCard(
                  title: 'Live Tracking',
                  subtitle: 'View GPS pings in real-time',
                  icon: Icons.map_rounded,
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/owner/locations',
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 64,
                  color: colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Something went wrong',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () {
                    ref.invalidate(busesProvider);
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/owner/register-bus'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Register Bus'),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

