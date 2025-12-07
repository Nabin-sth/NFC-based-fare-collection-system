import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/info_card.dart';

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Control Center'),
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
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.admin_panel_settings_rounded,
                      color: colorScheme.onPrimaryContainer,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Admin Panel',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Manage verification, RFID assignment, and account management',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer.withOpacity(0.9),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // Admin Actions
          Text(
            'Admin Actions',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          InfoCard(
            title: 'Pending Verifications',
            subtitle: 'Review passenger verification requests',
            icon: Icons.pending_actions_rounded,
            onTap: () =>
                Navigator.pushNamed(context, '/admin/pending-passengers'),
          ),
          const SizedBox(height: 12),
          InfoCard(
            title: 'Verify Users',
            subtitle: 'Approve passengers and owners',
            icon: Icons.verified_user_rounded,
            onTap: () => Navigator.pushNamed(context, '/admin/verify'),
          ),
          const SizedBox(height: 12),
          InfoCard(
            title: 'Assign RFID',
            subtitle: 'Issue RFID tags from admin panel',
            icon: Icons.credit_card_rounded,
            onTap: () => Navigator.pushNamed(context, '/admin/rfid'),
          ),
          const SizedBox(height: 12),
          InfoCard(
            title: 'Manage Buses',
            subtitle: 'Add/remove buses across fleet',
            icon: Icons.directions_bus_rounded,
            onTap: () => Navigator.pushNamed(context, '/admin/buses'),
          ),
          const SizedBox(height: 12),
          InfoCard(
            title: 'Delete Accounts',
            subtitle: 'Handle escalations and data removal',
            icon: Icons.delete_forever_rounded,
            onTap: () => Navigator.pushNamed(context, '/admin/delete'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

