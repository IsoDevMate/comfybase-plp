// core/network/dio_client.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import '../services/storage_service_factory.dart';
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
        try {
          final token = await getStorageService().read(
            key: StorageConstants.accessToken,
          );
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            if (kDebugMode) {
              print('Added Authorization header with token: ${token.substring(0, 20)}...');
            }
          } else {
            if (kDebugMode) {
              print('No access token found in storage');
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error getting access token: $e');
          }
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Token expired, try to refresh
          final refreshed = await _refreshToken();
          if (refreshed) {
            final token = await getStorageService().read(
              key: StorageConstants.accessToken,
            );
            error.requestOptions.headers['Authorization'] = 'Bearer $token';
            final response = await _dio.fetch(error.requestOptions);
            handler.resolve(response);
          } else {
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
      final refreshToken = await getStorageService().read(
        key: StorageConstants.refreshToken,
      );
      if (refreshToken == null) return false;

      final response = await _dio.post(
        ApiConstants.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newToken = response.data['data']['accessToken'];
        final newRefreshToken = response.data['data']['refreshToken'];

        await getStorageService().write(
          key: StorageConstants.accessToken,
          value: newToken,
        );
        await getStorageService().write(
          key: StorageConstants.refreshToken,
          value: newRefreshToken,
        );

        return true;
      }
    } catch (e) {
      if (kDebugMode) print('Token refresh failed: $e');
    }
    return false;
  }

  Future<void> _logout() async {
    await getStorageService().delete(key: StorageConstants.accessToken);
    await getStorageService().delete(key: StorageConstants.refreshToken);
    await getStorageService().delete(key: StorageConstants.userId);
    await getStorageService().delete(key: StorageConstants.userRole);
    await getStorageService().delete(key: StorageConstants.userProfile);
  }
}
