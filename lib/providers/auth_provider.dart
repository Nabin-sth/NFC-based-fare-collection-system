import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../services/api_service.dart';

enum UserRole { passenger, owner, admin }

class AuthState {
  const AuthState({
    this.isLoading = false,
    this.token,
    this.role,
    this.fullName,
    this.errorMessage,
  });

  final bool isLoading;
  final String? token;
  final UserRole? role;
  final String? fullName;
  final String? errorMessage;

  AuthState copyWith({
    bool? isLoading,
    String? token,
    UserRole? role,
    String? fullName,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      token: token ?? this.token,
      role: role ?? this.role,
      fullName: fullName ?? this.fullName,
      errorMessage: errorMessage,
    );
  }

  bool get isAuthenticated => token != null && role != null;
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._apiService, this._storage) : super(const AuthState());

  final ApiService _apiService;
  final SecureStore _storage;

  Future<void> hydrate() async {
    final storedToken = await _storage.read('token');
    final storedRole = await _storage.read('role');
    final storedName = await _storage.read('fullName');

    if (storedToken != null && storedRole != null) {
      _apiService.authToken = storedToken;
      state = state.copyWith(
        token: storedToken,
        role: UserRole.values
            .firstWhere((role) => role.name == storedRole, orElse: () => UserRole.passenger),
        fullName: storedName,
      );
    }
  }

  Future<void> login({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _apiService.login(email: email, password: password, role:role);
      final token = response["data"]['token'] as String?;
      print(role);
      print(role.name);
// print(token);
      if (token == null ) {
        throw ApiException('Invalid server response');
      }
      // final fullName = profile['fullName'] as String? ?? 'User';

      state = state.copyWith(
        isLoading: false,
        token: token,
        role: role,
        // fullName: fullName,
      );
      _apiService.authToken = token;

      await _storage.write('token', token);
      await _storage.write('role', role.name);
      // await _storage.write('fullName', fullName);
    } on ApiException catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.message);
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required UserRole role,
    // ignore: non_constant_identifier_names
    required String NIDNumber,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _apiService.register(
        fullName: fullName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        role: role,
        NIDNumber: NIDNumber,
      );
      
      state = state.copyWith(isLoading: false);
    } on ApiException catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.message);
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (e) {
      // Even if API logout fails, we should log out locally
      // This ensures the user can always log out even if server is unreachable
    } finally {
      // Always clear local state and storage
      _apiService.authToken = null;
      state = const AuthState();
      await _storage.deleteAll();
    }
  }
}

abstract class SecureStore {
  Future<String?> read(String key);
  Future<void> write(String key, String? value);
  Future<void> deleteAll();
}

class SecureStoreImpl implements SecureStore {
  SecureStoreImpl() : _storage = const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<void> deleteAll() => _storage.deleteAll();

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String? value) =>
      _storage.write(key: key, value: value);
}

final secureStoreProvider = Provider<SecureStore>(
  (ref) => SecureStoreImpl(),
);

final apiServiceProvider = Provider<ApiService>(
  (ref) => ApiService(),
);

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(
    ref.watch(apiServiceProvider),
    ref.watch(secureStoreProvider),
  )..hydrate();
});

