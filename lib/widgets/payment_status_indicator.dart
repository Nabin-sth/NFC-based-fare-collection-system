import 'package:flutter/material.dart';

import '../providers/driver_provider.dart';

class PaymentStatusIndicator extends StatelessWidget {
  const PaymentStatusIndicator({
    super.key,
    required this.status,
  });

  final PaymentStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color bg;
    Color fg;
    String label;
    IconData icon;

    switch (status) {
      case PaymentStatus.paid:
        bg = Colors.green.withOpacity(0.1);
        fg = Colors.green;
        label = 'PAID';
        icon = Icons.check_circle_rounded;
        break;
      case PaymentStatus.notPaid:
        bg = Colors.orange.withOpacity(0.1);
        fg = Colors.orange;
        label = 'NOT PAID';
        icon = Icons.error_outline_rounded;
        break;
      case PaymentStatus.insufficientBalance:
        bg = colorScheme.errorContainer;
        fg = colorScheme.onErrorContainer;
        label = 'INSUFFICIENT BALANCE';
        icon = Icons.warning_amber_rounded;
        break;
      case PaymentStatus.unknown:
        bg = colorScheme.surfaceVariant;
        fg = colorScheme.onSurfaceVariant;
        label = 'STATUS UNKNOWN';
        icon = Icons.help_outline_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: fg, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}


