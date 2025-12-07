import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/passenger.dart';
import '../models/transaction.dart';
import 'auth_provider.dart';

final passengerProfileProvider = FutureProvider<Passenger>((ref) {
  final api = ref.watch(apiServiceProvider);
  return api.fetchPassengerProfile();
});

final passengerTransactionsProvider =
    FutureProvider<List<Transaction>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.fetchPassengerTransactions();
});

