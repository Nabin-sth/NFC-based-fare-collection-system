import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';

class KhaltiPaymentPage extends ConsumerStatefulWidget {
  const KhaltiPaymentPage({super.key});

  @override
  ConsumerState<KhaltiPaymentPage> createState() => _KhaltiPaymentPageState();
}

class _KhaltiPaymentPageState extends ConsumerState<KhaltiPaymentPage> {
  final _amountController = TextEditingController(text: '500');
  final _referenceController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  Future<void> _startPayment() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid amount')),
      );
      return;
    }
    setState(() => _isProcessing = true);
    try {
      final api = ref.read(apiServiceProvider);
      await api.initiateTopUp(
        amount: amount,
        khaltiToken: _referenceController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Top-up recorded')),
      );
      Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Khalti Top-up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'As outlined in figure 5.9 of the report, Khalti is the local payment gateway used to fund RFID cards.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount (NPR)',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _referenceController,
              decoration: const InputDecoration(
                labelText: 'Khalti Reference ID',
                helperText:
                    'Enter the token/reference returned by Khalti after payment.',
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isProcessing ? null : _startPayment,
                child: _isProcessing
                    ? const CircularProgressIndicator.adaptive()
                    : const Text('Pay with Khalti'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

