import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/passenger.dart';
import '../services/driver_service.dart';

enum PaymentStatus {
  paid,
  notPaid,
  insufficientBalance,
  unknown,
}

class DriverState {
  const DriverState({
    this.isLoading = false,
    this.identifier = '',
    this.passenger,
    this.paymentStatus = PaymentStatus.unknown,
    this.errorMessage,
  });

  final bool isLoading;
  final String identifier;
  final Passenger? passenger;
  final PaymentStatus paymentStatus;
  final String? errorMessage;

  DriverState copyWith({
    bool? isLoading,
    String? identifier,
    Passenger? passenger,
    PaymentStatus? paymentStatus,
    String? errorMessage,
  }) {
    return DriverState(
      isLoading: isLoading ?? this.isLoading,
      identifier: identifier ?? this.identifier,
      passenger: passenger ?? this.passenger,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      errorMessage: errorMessage,
    );
  }
}

class DriverController extends StateNotifier<DriverState> {
  DriverController(this._driverService) : super(const DriverState());

  final DriverService _driverService;

  void setIdentifier(String value) {
    state = state.copyWith(identifier: value, errorMessage: null);
  }

  Future<void> validatePayment() async {
    if (state.identifier.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Please enter RFID or phone/ID.');
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final passenger = await _driverService.checkBalance(
        identifier: state.identifier.trim(),
      );
      final statusText = await _driverService.validatePayment(
        identifier: state.identifier.trim(),
      );

      final normalized = statusText.toUpperCase();
      PaymentStatus mapped;
      if (normalized == 'PAID') {
        mapped = PaymentStatus.paid;
      } else if (normalized == 'NOT PAID') {
        mapped = PaymentStatus.notPaid;
      } else if (normalized == 'INSUFFICIENT BALANCE') {
        mapped = PaymentStatus.insufficientBalance;
      } else {
        mapped = PaymentStatus.unknown;
      }

      state = state.copyWith(
        isLoading: false,
        passenger: passenger,
        paymentStatus: mapped,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    }
  }
}

final driverControllerProvider =
    StateNotifierProvider<DriverController, DriverState>((ref) {
  return DriverController(ref.watch(driverServiceProvider));
});


