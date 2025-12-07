import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/passenger.dart';
import '../providers/auth_provider.dart';
import 'api_service.dart';

class DriverService {
  DriverService(this._apiService);

  final ApiService _apiService;

  Future<Passenger> checkBalance({
    required String identifier,
  }) async {
    // identifier can be RFID card number or phone/ID
    return _apiService.checkPassengerBalance(identifier: identifier);
  }

  Future<String> validatePayment({
    required String identifier,
  }) async {
    return _apiService.validatePassengerPayment(identifier: identifier);
  }
}

final driverServiceProvider = Provider<DriverService>((ref) {
  return DriverService(ref.watch(apiServiceProvider));
});


