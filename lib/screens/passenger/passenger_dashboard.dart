import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/passenger_providers.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/info_card.dart';

class PassengerDashboard extends ConsumerWidget {
  const PassengerDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(passengerProfileProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passenger Dashboard'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(
              context,
              '/passenger/profile',
            ),
            icon: const Icon(Icons.person_outline_rounded),
            tooltip: 'Profile',
          ),
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
      body: profileAsync.when(
        data: (passenger) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(passengerProfileProvider);
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Welcome Section
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Namaste,',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            passenger.name,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage your balance, track buses, and view RFID activity',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Balance Card (Highlighted)
                Card(
                  elevation: 0,
                  color: colorScheme.primaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/passenger/balance',
                    ),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.account_balance_wallet_rounded,
                                  color: colorScheme.onPrimaryContainer,
                                  size: 28,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Current Balance',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'NPR ${passenger.balance.toStringAsFixed(2)}',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Quick Actions
                Text(
                  'Quick Actions',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                InfoCard(
                  title: 'Live Map',
                  subtitle: 'Track RFID-enabled buses in real-time',
                  icon: Icons.map_outlined,
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/passenger/map',
                  ),
                ),
                const SizedBox(height: 12),
                InfoCard(
                  title: 'Transactions',
                  subtitle: 'Fare deductions & Khalti top ups',
                  icon: Icons.receipt_long_outlined,
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/passenger/transactions',
                  ),
                ),
                const SizedBox(height: 12),
                InfoCard(
                  title: 'Khalti Reload',
                  subtitle: 'Instantly recharge your RFID balance',
                  icon: Icons.payment_rounded,
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/passenger/khalti',
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
                    ref.invalidate(passengerProfileProvider);
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

