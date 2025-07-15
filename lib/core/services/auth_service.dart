import 'package:dio/dio.dart' as dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../features/auth/data/models/login_request.dart';
import '../../features/auth/data/models/register_request.dart';
import '../../features/auth/data/models/auth_response.dart';
import '../models/api_response.dart';
import '../constants/api_constants.dart';
import '../../core/models/user_model.dart';

class AuthService {
  final dio.Dio _dio = dio.Dio(
    dio.BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: Duration(milliseconds: ApiConstants.connectionTimeout),
      receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeout),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Login
  Future<ApiResponse<AuthResponse>> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: request.toJson(),
      );
      final apiResponse = ApiResponse<AuthResponse>.fromJson(
        response.data,
        (json) => AuthResponse.fromJson(json as Map<String, dynamic>),
      );
      // Save token if login is successful
      if (apiResponse.success && apiResponse.data != null) {
        await _storage.write(
          key: 'accessToken',
          value: apiResponse.data!.tokens.accessToken,
        );
        await _storage.write(
          key: 'refreshToken',
          value: apiResponse.data!.tokens.refreshToken,
        );
      }
      return apiResponse;
    } catch (e) {
      return ApiResponse<AuthResponse>(
        success: false,
        message: 'Login failed',
        data: null,
        errors: [e.toString()],
      );
    }
  }

  // Register
  Future<ApiResponse<UserModel>> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: request.toJson(),
      );
      final apiResponse = ApiResponse<UserModel>.fromJson(
        response.data,
        (json) => UserModel.fromJson(json as Map<String, dynamic>),
      );
      return apiResponse;
    } catch (e) {
      return ApiResponse<UserModel>(
        success: false,
        message: 'Registration failed',
        data: null,
        errors: [e.toString()],
      );
    }
  }

  // Get Profile
  Future<ApiResponse<AuthResponse>> getProfile() async {
    try {
      final token = await _storage.read(key: 'accessToken');
      final response = await _dio.get(
        ApiConstants.profile,
        options: dio.Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return ApiResponse<AuthResponse>.fromJson(
        response.data,
        (json) => AuthResponse.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiResponse<AuthResponse>(
        success: false,
        message: 'Profile fetch failed',
        data: null,
        errors: [e.toString()],
      );
    }
  }

  // Logout (just deletes the token)
  Future<void> logout() async {
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
  }
}
