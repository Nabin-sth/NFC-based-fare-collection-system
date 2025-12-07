import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sahaj_yatra/providers/auth_provider.dart';

import '../models/bus.dart';
import '../models/location_model.dart';
import '../models/passenger.dart';
import '../models/transaction.dart';

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiService {
  ApiService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: dotenv.env['API_BASE_URL'] ??
                    'http://192.168.1.4:5000',
                connectTimeout: const Duration(seconds: 30),
                receiveTimeout: const Duration(seconds: 30),
                sendTimeout: const Duration(seconds: 30),
              ),
            );

  final Dio _dio;

  set authToken(String? token) {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required UserRole role
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
          'role':role.name
        },
      );
      print("role:$role");
      print("rolename:${role.name}");
      // print(response);
      // print('\n');
      final data = response.data ?? {};
      // print(data);
      authToken = data['token'] as String?;
      return data;
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required UserRole role,
    // ignore: non_constant_identifier_names
    required String NIDNumber,
  }) async {
    try {
      final data = <String, dynamic>{
        'name': fullName,
        'email': email,
        'password': password,
        'phone': phoneNumber,
        'role': role.name,
      };
      
      if ( NIDNumber.isNotEmpty) {
        data['NIDNumber'] = NIDNumber;
      }

      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/register',
        data: data,
      );
      
      final responseData = response.data ?? {};
      return responseData;
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } on DioException catch (error) {
      throw _toApiException(error);
    } finally {
      authToken = null;
    }
  }

  Future<Passenger> fetchPassengerProfile() async {
    try {
      final response = await _dio.get<dynamic>('/passenger/profile');
      final data = response.data;
      print("data:${data}");

      if (data is! Map<String, dynamic>) {
        throw ApiException(
          'Unexpected "/passenger/profile" response structure',
        );
      }

      // Some backends wrap the actual payload in a "data" field.
      final payload =
          data['data'] is Map<String, dynamic> ? data['data'] as Map<String, dynamic> : data;
          print("payload:${payload}");

      try {
        return Passenger.fromJson(payload);
      } catch (e) {
        // Handle JSON parsing errors with more context
        throw ApiException(
          'Failed to parse passenger profile: ${e.toString()}. '
          'Response data: $payload',
        );
      }
    } on DioException catch (error) {
      throw _toApiException(error);
    } on ApiException {
      rethrow;
    } catch (error) {
      throw ApiException('Unexpected error fetching passenger profile: $error');
    }
  }

  Future<List<Transaction>> fetchPassengerTransactions() async {
    try {
      final response = await _dio.get<List<dynamic>>('passenger/transactions');
      return response.data!
          .map((json) => Transaction.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  Future<void> requestPassengerVerification() async {
    try {
      await _dio.post<void>(
        '/passenger/request-verification',
      );
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  // Future<List<Bus>> fetchBuses({String? ownerId}) async {
  //   try {
  //     final response = await _dio.get<List<dynamic>>(
  //       '/owner/buses',
  //       // queryParameters: ownerId != null ? {'ownerId': ownerId} : null,
  //     );
  //     print("response.data:${response.data}");
  //     // print("response.data.map:${response.data!.map((json) => Bus.fromJson(json as Map<String, dynamic>)).toList()}");
  //     return response.data!
  //         .map((json) => Bus.fromJson(json as Map<String, dynamic>))
  //         .toList();
  //   } on DioException catch (error) {
  //     throw _toApiException(error);
  //   }
  // }
  Future<List<Bus>> fetchBuses({String? ownerId}) async {
    try {
      final response = await _dio.get<dynamic>(
        '/owner/buses',
        queryParameters: ownerId != null ? {'ownerId': ownerId} : null,
      );

      final payload = response.data;
      final List<dynamic> busesRaw;

      if (payload == null) {
        busesRaw = const [];
      } else if (payload is List<dynamic>) {
        busesRaw = payload;
      } else if (payload is Map<String, dynamic>) {
        final data = payload['data'] ?? payload['buses'];
        if (data == null) {
          busesRaw = const [];
        } else if (data is List<dynamic>) {
          busesRaw = data;
        } else {
          throw ApiException(
            'Unexpected "/owner/buses" response structure (data is not a list)',
          );
        }
      } else {
        throw ApiException(
          'Unexpected "/owner/buses" response structure',
        );
      }

      return busesRaw
          .whereType<Map<String, dynamic>>()
          .map(Bus.fromJson)
          .toList();
    } on DioException catch (error) {
      throw _toApiException(error);
    } on FormatException catch (error) {
      throw ApiException(error.message);
    }
  }


  Future<void> registerBus({
    required String busNumber,
    required String rfidDeviceId,
  }) async {
    try {
      await _dio.post<void>(
        '/owner/bus',
        data: {
          'busNumber': busNumber,
          'rfidDeviceId': rfidDeviceId
        },
      );
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  Future<void> deleteBus(String busId) async {
    try {
      await _dio.delete<void>('admin/$busId');
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  Future<LocationModel> pollBusLocation(String busId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/bus/$busId/location',
      );
      return LocationModel.fromJson(response.data!);
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  Future<List<Passenger>> fetchPendingPassengerVerifications() async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/admin/verify-passenger',
        queryParameters: const {'status': 'pending'},
      );

      return response.data!
          .map((json) => Passenger.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  Future<Transaction> initiateTopUp({
    required double amount,
    required String khaltiToken,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/payments/khalti',
        data: {
          'amount': amount,
          'khaltiToken': khaltiToken,
        },
      );
      return Transaction.fromJson(response.data!);
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  Future<void> assignRfid({
    required String passengerId,
    required String rfidNumber,
  }) async {
    try {
      await _dio.post<void>(
        '/admin/assign-rfid',
        data: {
          'passengerId':passengerId,
          'rfid': rfidNumber,
          'isVerified': true,
        },
      );
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  // DRIVER: Validate payment for a passenger via RFID / phone / ID
  Future<String> validatePassengerPayment({
    required String identifier,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/passenger/validate-payment',
        data: {'identifier': identifier},
      );
      final data = response.data ?? <String, dynamic>{};
      // Expecting something like { status: 'PAID' | 'NOT PAID' | 'INSUFFICIENT BALANCE', ... }
      return (data['status'] as String?) ?? 'NOT PAID';
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  // DRIVER: Check balance of passenger
  Future<Passenger> checkPassengerBalance({
    required String identifier,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        '/passenger/check-balance',
        queryParameters: {'identifier': identifier},
      );
      final data = response.data;

      if (data is! Map<String, dynamic>) {
        throw ApiException(
          'Unexpected "/passenger/check-balance" response structure',
        );
      }

      final payload =
          data['data'] is Map<String, dynamic> ? data['data'] as Map<String, dynamic> : data;

      return Passenger.fromJson(payload);
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  // DRIVER: Fetch fare history summary
  Future<List<Passenger>> fetchPassengerFareHistoryRaw({
    required String identifier,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        '/passenger/fare-history',
        queryParameters: {'identifier': identifier},
      );

      final payload = response.data;
      final List<dynamic> raw;

      if (payload == null) {
        raw = const [];
      } else if (payload is List<dynamic>) {
        raw = payload;
      } else if (payload is Map<String, dynamic>) {
        final data = payload['data'] ?? payload['history'];
        if (data == null) {
          raw = const [];
        } else if (data is List<dynamic>) {
          raw = data;
        } else {
          throw ApiException(
            'Unexpected "/passenger/fare-history" response structure (data is not a list)',
          );
        }
      } else {
        throw ApiException(
          'Unexpected "/passenger/fare-history" response structure',
        );
      }

      return raw
          .whereType<Map<String, dynamic>>()
          .map(Passenger.fromJson)
          .toList();
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  Future<void> verifyBusOwner(String ownerId) async {
    try {
      await _dio.patch<void>(
        '/admin/verify-owner',
        data: {'isVerified': true,'ownerId':ownerId},
      );
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  Future<void> deleteAccount({
    required String accountId,
    required String role,
  }) async {
    // final path = role == 'owner' ? '/owners' : '/passengers';
    try {
      await _dio.delete<void>('/user',
      data: {'role':role,
      'userId':accountId});
    } on DioException catch (error) {
      throw _toApiException(error);
    }
  }

  ApiException _toApiException(DioException error) {
    String message;
    
    // Handle timeout errors specifically
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      message = 'Connection timeout. Please check your internet connection and try again.';
    } else if (error.type == DioExceptionType.connectionError) {
      print("error:$error");
      message = 'Unable to connect to the server. Please check your internet connection.';
    } else if (error.response?.data is Map<String, dynamic>) {
      message = error.response?.data[ 'message'] as String? ??
          'error occurred';
    } else {
            print("error:${error}");
      message = error.message ?? 'An unexpected error occurred';
    }
    
    return ApiException(
      message,
      statusCode: error.response?.statusCode,
    );
  }
}

