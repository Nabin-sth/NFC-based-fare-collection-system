import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sahaj_yatra/providers/auth_provider.dart';
import 'package:sahaj_yatra/services/api_service.dart';

class FakeApiService extends ApiService {
  FakeApiService()
      : super(
          dio: Dio(
            BaseOptions(baseUrl: 'http://192.168.1.4:5000'),
          ),
        );

  bool shouldThrow = false;

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required UserRole role
  }) async {
    if (shouldThrow) {
      throw ApiException('Invalid');
    }
    return {
      'token': 'fake-token',
      'profile': {
        'fullName': 'Test User',
      },
    };
  }

  @override
  Future<void> logout() async {}
}

class InMemorySecureStore implements SecureStore {
  final Map<String, String?> _data = {};

  @override
  Future<void> deleteAll() async => _data.clear();

  @override
  Future<String?> read(String key) async => _data[key];

  @override
  Future<void> write(String key, String? value) async => _data[key] = value;
}

void main() {
  test('login success updates auth state', () async {
    final controller =
        AuthController(FakeApiService(), InMemorySecureStore());
    await controller.login(
      email: 'user@example.com',
      password: 'password',
      role: UserRole.passenger,
    );
    expect(controller.state.isAuthenticated, true);
    expect(controller.state.fullName, 'Test User');
  });
}

