// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sahaj_yatra/main.dart';
import 'package:sahaj_yatra/providers/auth_provider.dart';
import 'package:sahaj_yatra/services/api_service.dart';

void main() {
  testWidgets('renders Sahaj Yatra splash screen', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiServiceProvider.overrideWithValue(FakeApiService()),
          secureStoreProvider.overrideWithValue(InMemorySecureStore()),
        ],
        child: const SahajYatraApp(),
      ),
    );
    await tester.pump();
    expect(find.text('Sahaj Yatra'), findsOneWidget);
  });
}

class FakeApiService extends ApiService {
  FakeApiService()
      : super(
          dio: Dio( 
            BaseOptions(baseUrl: 'http://192.168.1.4:5000'),
          ),
        );

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required UserRole role
  }) async {
    return {
      'token': 'fake',
      'profile': {'fullName': 'Test'},
    };
  }

  @override
  Future<void> logout() async {}
}

class InMemorySecureStore implements SecureStore {
  final Map<String, String?> _map = {};

  @override
  Future<void> deleteAll() async => _map.clear();

  @override
  Future<String?> read(String key) async => _map[key];

  @override
  Future<void> write(String key, String? value) async => _map[key] = value;
}
