// core/network/dio_client.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import '../services/storage_service.dart';
import '../constants/storage_constants.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;
  DioClient._internal();

  late Dio _dio;

  Dio get dio => _dio;

  void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(
          milliseconds: ApiConstants.connectionTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: ApiConstants.receiveTimeout,
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(_getAuthInterceptor());
    _dio.interceptors.add(_getLoggingInterceptor());
    _dio.interceptors.add(_getErrorInterceptor());
  }

  // Auth interceptor to add token to requests
  Interceptor _getAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await StorageService.getSecureString(
          StorageConstants.accessToken,
        );
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Token expired, try to refresh
          final refreshed = await _refreshToken();
          if (refreshed) {
            // Retry the request
            final token = await StorageService.getSecureString(
              StorageConstants.accessToken,
            );
            error.requestOptions.headers['Authorization'] = 'Bearer $token';
            final response = await _dio.fetch(error.requestOptions);
            handler.resolve(response);
          } else {
            // Refresh failed, logout user
            await _logout();
            handler.next(error);
          }
        } else {
          handler.next(error);
        }
      },
    );
  }

  // Logging interceptor for debugging
  Interceptor _getLoggingInterceptor() {
    return LogInterceptor(
      request: kDebugMode,
      requestHeader: kDebugMode,
      requestBody: kDebugMode,
      responseHeader: kDebugMode,
      responseBody: kDebugMode,
      error: kDebugMode,
    );
  }

  // Error interceptor to handle common errors
  Interceptor _getErrorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        if (kDebugMode) {
          print('API Error: ${error.message}');
          print('Status Code: ${error.response?.statusCode}');
          print('Response: ${error.response?.data}');
        }
        handler.next(error);
      },
    );
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await StorageService.getSecureString(
        StorageConstants.refreshToken,
      );
      if (refreshToken == null) return false;

      final response = await _dio.post(
        ApiConstants.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newToken = response.data['data']['accessToken'];
        final newRefreshToken = response.data['data']['refreshToken'];

        await StorageService.setSecureString(
          StorageConstants.accessToken,
          newToken,
        );
        await StorageService.setSecureString(
          StorageConstants.refreshToken,
          newRefreshToken,
        );

        return true;
      }
    } catch (e) {
      if (kDebugMode) print('Token refresh failed: $e');
    }
    return false;
  }

  Future<void> _logout() async {
    await StorageService.removeSecureString(StorageConstants.accessToken);
    await StorageService.removeSecureString(StorageConstants.refreshToken);
    await StorageService.remove(StorageConstants.userId);
    await StorageService.remove(StorageConstants.userRole);
    await StorageService.remove(StorageConstants.userProfile);
  }
}
