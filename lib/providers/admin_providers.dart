import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/passenger.dart';
import 'auth_provider.dart';

final pendingPassengerVerificationsProvider =
    FutureProvider.autoDispose<List<Passenger>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.fetchPendingPassengerVerifications();
});


