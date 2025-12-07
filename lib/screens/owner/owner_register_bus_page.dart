import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../utils/validators.dart';

class OwnerRegisterBusPage extends ConsumerStatefulWidget {
  const OwnerRegisterBusPage({super.key});

  @override
  ConsumerState<OwnerRegisterBusPage> createState() =>
      _OwnerRegisterBusPageState();
}

class _OwnerRegisterBusPageState
    extends ConsumerState<OwnerRegisterBusPage> {
  final _formKey = GlobalKey<FormState>();
  final _busNumberController = TextEditingController();
  final rfidDeviceId = TextEditingController();
  // final _seatController = TextEditingController(text: '40');
  bool _isSubmitting = false;

  @override
  void dispose() {
    _busNumberController.dispose();
    rfidDeviceId.dispose();
    // _seatController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      final api = ref.read(apiServiceProvider);
      await api.registerBus(
        busNumber: _busNumberController.text.trim(),
        rfidDeviceId: rfidDeviceId.text.trim()
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bus registration submitted')),
      );
      Navigator.pop(context);
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      appBar: AppBar(title: const Text('Register New Bus')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.directions_bus_rounded,
                      color: colorScheme.onPrimaryContainer,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Register New Bus',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Add a new bus to your fleet',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Form Fields
              Text(
                'Bus Information',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _busNumberController,
                decoration: const InputDecoration(
                  labelText: 'Number Plate',
                  prefixIcon: Icon(Icons.confirmation_number_rounded),
                  hintText: 'e.g., Ba 1 Pa 1234',
                ),
                textInputAction: TextInputAction.next,
                validator: Validators.notEmpty,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: rfidDeviceId,
                decoration: const InputDecoration(
                  labelText: 'Rfid Device Id',
                  prefixIcon: Icon(Icons.category_rounded),
                  // hintText: 'e.g., Micro, Mini, Standard',
                ),
                textInputAction: TextInputAction.next,
                validator: Validators.notEmpty,
              ),
              const SizedBox(height: 20),
              // TextFormField(
              //   controller: _seatController,
              //   decoration: const InputDecoration(
              //     labelText: 'Seat Capacity',
              //     prefixIcon: Icon(Icons.event_seat_rounded),
              //     hintText: 'e.g., 40',
              //   ),
              //   keyboardType: TextInputType.number,
              //   textInputAction: TextInputAction.done,
              //   onFieldSubmitted: (_) => _submit(),
              //   validator: (value) {
              //     final base = Validators.notEmpty(value);
              //     if (base != null) return base;
              //     final seats = int.tryParse(value!);
              //     if (seats == null || seats <= 0) {
              //       return 'Enter a positive number';
              //     }
              //     return null;
              //   },
              // ),
              const SizedBox(height: 32),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: _isSubmitting ? null : _submit,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator.adaptive(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.check_circle_outline_rounded),
                  label: Text(
                    _isSubmitting ? 'Submitting...' : 'Register Bus',
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

