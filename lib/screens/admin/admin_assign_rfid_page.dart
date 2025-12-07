import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../utils/validators.dart';

class AdminAssignRfidPage extends ConsumerStatefulWidget {
  const AdminAssignRfidPage({super.key});

  @override
  ConsumerState<AdminAssignRfidPage> createState() =>
      _AdminAssignRfidPageState();
}

class _AdminAssignRfidPageState
    extends ConsumerState<AdminAssignRfidPage> {
  final _formKey = GlobalKey<FormState>();
  final _passengerIdController = TextEditingController();
  final _rfidController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _passengerIdController.dispose();
    _rfidController.dispose();
    super.dispose();
  }

  Future<void> _assign() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      final api = ref.read(apiServiceProvider);
      await api.assignRfid(
        passengerId: _passengerIdController.text.trim(),
        rfidNumber: _rfidController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('RFID assigned')),
      );
    } on ApiException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assign RFID Tags')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _passengerIdController,
                decoration: const InputDecoration(labelText: 'Passenger ID'),
                validator: Validators.notEmpty,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _rfidController,
                decoration: const InputDecoration(labelText: 'RFID Number'),
                validator: Validators.notEmpty,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSubmitting ? null : _assign,
                  child: _isSubmitting
                      ? const CircularProgressIndicator.adaptive()
                      : const Text('Assign'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

