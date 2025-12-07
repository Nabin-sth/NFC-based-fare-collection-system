import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/bus.dart';
import 'auth_provider.dart';

final busesProvider = FutureProvider.autoDispose<List<Bus>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  print("api.fetchBuses():${await api.fetchBuses()}");
  return await api.fetchBuses();
});

