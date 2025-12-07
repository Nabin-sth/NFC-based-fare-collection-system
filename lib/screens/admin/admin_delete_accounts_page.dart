import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../utils/validators.dart';

class AdminDeleteAccountsPage extends ConsumerStatefulWidget {
  const AdminDeleteAccountsPage({super.key});

  @override
  ConsumerState<AdminDeleteAccountsPage> createState() =>
      _AdminDeleteAccountsPageState();
}

class _AdminDeleteAccountsPageState
    extends ConsumerState<AdminDeleteAccountsPage> {
  final _formKey = GlobalKey<FormState>();
  final _accountIdController = TextEditingController();
  String _selectedRole = 'passenger';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _accountIdController.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      final api = ref.read(apiServiceProvider);
      await api.deleteAccount(
        accountId: _accountIdController.text.trim(),
        role: _selectedRole,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account deleted')),
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
      appBar: AppBar(title: const Text('Delete Accounts')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                initialValue: _selectedRole,
                decoration: const InputDecoration(labelText: 'Role'),
                items: const [
                  DropdownMenuItem(
                    value: 'passenger',
                    child: Text('Passenger'),
                  ),
                  DropdownMenuItem(
                    value: 'owner',
                    child: Text('Owner'),
                  ),
                ],
                onChanged: (value) => setState(() {
                  _selectedRole = value ?? 'passenger';
                }),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _accountIdController,
                decoration: const InputDecoration(labelText: 'Account ID'),
                validator: Validators.notEmpty,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSubmitting ? null : _delete,
                  child: _isSubmitting
                      ? const CircularProgressIndicator.adaptive()
                      : const Text('Delete'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

