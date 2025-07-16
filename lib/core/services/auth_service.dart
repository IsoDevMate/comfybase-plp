// import 'package:dio/dio.dart' as dio;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import '../../features/auth/data/models/login_request.dart';
// import '../../features/auth/data/models/register_request.dart';
// import '../../features/auth/data/models/auth_response.dart';
// import '../models/api_response.dart';
// import '../constants/api_constants.dart';
// import '../../core/models/user_model.dart';
// import 'storage_service.dart';
// import 'storage_service_factory.dart';

// class AuthService {
//   final dio.Dio _dio = dio.Dio(
//     dio.BaseOptions(
//       baseUrl: ApiConstants.baseUrl,
//       connectTimeout: Duration(milliseconds: ApiConstants.connectionTimeout),
//       receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeout),
//       headers: {'Content-Type': 'application/json'},
//     ),
//   );

//   final StorageService _storage = getStorageService();

//   // Login
//   Future<ApiResponse<AuthResponse>> login(LoginRequest request) async {
//     try {
//       print('AuthService: Starting login request');
//       final response = await _dio.post(
//         ApiConstants.login,
//         data: request.toJson(),
//       );
//       print('AuthService: Raw Dio response: \n${response.data}');

//       // Manual parsing
//       final data = response.data;
//       final bool success = data['success'] == true;
//       final String message = data['message'] ?? '';
//       AuthResponse? authResponse;

//       if (success && data['data'] != null) {
//         authResponse = AuthResponse.fromJson(data['data']);
//         print('AuthService: Successfully parsed auth response');
//       }

//       // Save token if login is successful
//       print('AuthService: About to write tokens');
//       print('AccessToken: ${authResponse?.tokens.accessToken}');
//       print('RefreshToken: ${authResponse?.tokens.refreshToken}');
//       if (success &&
//           authResponse != null &&
//           authResponse.tokens.accessToken != null &&
//           authResponse.tokens.refreshToken != null) {
//         await _storage.write(
//           key: 'accessToken',
//           value: authResponse.tokens.accessToken,
//         );
//         await _storage.write(
//           key: 'refreshToken',
//           value: authResponse.tokens.refreshToken,
//         );
//       } else {
//         print('AuthService: One or both tokens are null!');
//       }

//       // Verify storage worked
//       final savedAccessToken = await _storage.read(key: 'accessToken');
//       final savedRefreshToken = await _storage.read(key: 'refreshToken');
//       print(
//         'AuthService: Token verification - Access: ${savedAccessToken != null}, Refresh: ${savedRefreshToken != null}',
//       );

//       print(
//         'AuthService: Login completed - success=$success, data=${authResponse != null}',
//       );

//       return ApiResponse<AuthResponse>(
//         success: success,
//         message: message,
//         data: authResponse,
//         errors: null,
//       );
//     } on dio.DioException catch (e) {
//       print('AuthService: Dio exception: ${e.message}');
//       return ApiResponse<AuthResponse>(
//         success: false,
//         message: 'Network error: ${e.message}',
//         data: null,
//         errors: [e.toString()],
//       );
//     } catch (e) {
//       print('AuthService: General exception: $e');
//       return ApiResponse<AuthResponse>(
//         success: false,
//         message: 'Login failed: $e',
//         data: null,
//         errors: [e.toString()],
//       );
//     }
//   }

//   // Register
//   Future<ApiResponse<UserModel>> register(RegisterRequest request) async {
//     try {
//       final response = await _dio.post(
//         ApiConstants.register,
//         data: request.toJson(),
//       );
//       final apiResponse = ApiResponse<UserModel>.fromJson(
//         response.data,
//         (json) => UserModel.fromJson(json as Map<String, dynamic>),
//       );
//       return apiResponse;
//     } on dio.DioException catch (e) {
//       return ApiResponse<UserModel>(
//         success: false,
//         message: 'Network error: ${e.message}',
//         data: null,
//         errors: [e.toString()],
//       );
//     } catch (e) {
//       return ApiResponse<UserModel>(
//         success: false,
//         message: 'Registration failed: $e',
//         data: null,
//         errors: [e.toString()],
//       );
//     }
//   }

//   // Get Profile
//   Future<ApiResponse<AuthResponse>> getProfile() async {
//     try {
//       final token = await _storage.read(key: 'accessToken');
//       print('AuthService: Getting profile with token: ${token != null}');

//       if (token == null) {
//         return ApiResponse<AuthResponse>(
//           success: false,
//           message: 'No access token found',
//           data: null,
//           errors: ['No access token'],
//         );
//       }

//       final response = await _dio.get(
//         ApiConstants.profile,
//         options: dio.Options(headers: {'Authorization': 'Bearer $token'}),
//       );

//       return ApiResponse<AuthResponse>.fromJson(
//         response.data,
//         (json) => AuthResponse.fromJson(json as Map<String, dynamic>),
//       );
//     } on dio.DioException catch (e) {
//       print('AuthService: Profile fetch Dio error: ${e.message}');
//       return ApiResponse<AuthResponse>(
//         success: false,
//         message: 'Network error: ${e.message}',
//         data: null,
//         errors: [e.toString()],
//       );
//     } catch (e) {
//       print('AuthService: Profile fetch error: $e');
//       return ApiResponse<AuthResponse>(
//         success: false,
//         message: 'Profile fetch failed: $e',
//         data: null,
//         errors: [e.toString()],
//       );
//     }
//   }

//   // Logout (just deletes the token)
//   Future<void> logout() async {
//     print('AuthService: Logging out - clearing tokens');
//     try {
//       await _storage.delete(key: 'accessToken');
//       await _storage.delete(key: 'refreshToken');
//       print('AuthService: Tokens cleared successfully');
//     } catch (e) {
//       print('AuthService: Error clearing tokens: $e');
//     }
//   }
// }






import 'package:dio/dio.dart' as dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../features/auth/data/models/login_request.dart';
import '../../features/auth/data/models/register_request.dart';
import '../../features/auth/data/models/auth_response.dart';
import '../models/api_response.dart';
import '../constants/api_constants.dart';
import '../../core/models/user_model.dart';
import 'storage_service.dart';
import 'storage_service_factory.dart';

class AuthService {
  final dio.Dio _dio = dio.Dio(
    dio.BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: Duration(milliseconds: ApiConstants.connectionTimeout),
      receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeout),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  final StorageService _storage = getStorageService();

  // Login
  Future<ApiResponse<AuthResponse>> login(LoginRequest request) async {
    try {
      print('AuthService: Starting login request');
      final response = await _dio.post(
        ApiConstants.login,
        data: request.toJson(),
      );
      print('AuthService: Raw Dio response: \n${response.data}');

      // Manual parsing
      final data = response.data;
      final bool success = data['success'] == true;
      final String message = data['message'] ?? '';
      AuthResponse? authResponse;

      if (success && data['data'] != null) {
        try {
          authResponse = AuthResponse.fromJson(data['data']);
          print('AuthService: Successfully parsed auth response');

          // Debug: Print token info
          print(
            'AuthService: Access Token: ${authResponse.tokens.accessToken}',
          );
          print(
            'AuthService: Refresh Token: ${authResponse.tokens.refreshToken}',
          );
          print('AuthService: Expires In: ${authResponse.tokens.expiresIn}');
        } catch (e) {
          print('AuthService: Error parsing AuthResponse: $e');
          return ApiResponse<AuthResponse>(
            success: false,
            message: 'Error parsing login response: $e',
            data: null,
            errors: [e.toString()],
          );
        }
      }

      // Save token if login is successful
      if (success && authResponse != null) {
        try {
          print('AuthService: About to write tokens');

          // Check if tokens are not null before storing
          final accessToken = authResponse.tokens.accessToken;
          final refreshToken = authResponse.tokens.refreshToken;

          if (accessToken != null && accessToken.isNotEmpty) {
            await _storage.write(key: 'accessToken', value: accessToken);
            print('AuthService: Access token stored successfully');
          } else {
            print('AuthService: Access token is null or empty');
          }

          if (refreshToken != null && refreshToken.isNotEmpty) {
            await _storage.write(key: 'refreshToken', value: refreshToken);
            print('AuthService: Refresh token stored successfully');
          } else {
            print('AuthService: Refresh token is null or empty');
          }
        } catch (e) {
          print('AuthService: Error storing tokens: $e');
          return ApiResponse<AuthResponse>(
            success: false,
            message: 'Error storing tokens: $e',
            data: null,
            errors: [e.toString()],
          );
        }
      }

      // Verify storage worked
      final savedAccessToken = await _storage.read(key: 'accessToken');
      final savedRefreshToken = await _storage.read(key: 'refreshToken');
      print(
        'AuthService: Token verification - Access: ${savedAccessToken != null}, Refresh: ${savedRefreshToken != null}',
      );

      print(
        'AuthService: Login completed - success=$success, data=${authResponse != null}',
      );

      return ApiResponse<AuthResponse>(
        success: success,
        message: message,
        data: authResponse,
        errors: null,
      );
    } on dio.DioException catch (e) {
      print('AuthService: Dio exception: ${e.message}');
      return ApiResponse<AuthResponse>(
        success: false,
        message: 'Network error: ${e.message}',
        data: null,
        errors: [e.toString()],
      );
    } catch (e) {
      print('AuthService: General exception: $e');
      return ApiResponse<AuthResponse>(
        success: false,
        message: 'Login failed: $e',
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
    } on dio.DioException catch (e) {
      return ApiResponse<UserModel>(
        success: false,
        message: 'Network error: ${e.message}',
        data: null,
        errors: [e.toString()],
      );
    } catch (e) {
      return ApiResponse<UserModel>(
        success: false,
        message: 'Registration failed: $e',
        data: null,
        errors: [e.toString()],
      );
    }
  }

  // Get Profile
  Future<ApiResponse<AuthResponse>> getProfile() async {
    try {
      final token = await _storage.read(key: 'accessToken');
      print('AuthService: Getting profile with token: ${token != null}');

      if (token == null) {
        return ApiResponse<AuthResponse>(
          success: false,
          message: 'No access token found',
          data: null,
          errors: ['No access token'],
        );
      }

      final response = await _dio.get(
        ApiConstants.profile,
        options: dio.Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return ApiResponse<AuthResponse>.fromJson(
        response.data,
        (json) => AuthResponse.fromJson(json as Map<String, dynamic>),
      );
    } on dio.DioException catch (e) {
      print('AuthService: Profile fetch Dio error: ${e.message}');
      return ApiResponse<AuthResponse>(
        success: false,
        message: 'Network error: ${e.message}',
        data: null,
        errors: [e.toString()],
      );
    } catch (e) {
      print('AuthService: Profile fetch error: $e');
      return ApiResponse<AuthResponse>(
        success: false,
        message: 'Profile fetch failed: $e',
        data: null,
        errors: [e.toString()],
      );
    }
  }

  // Logout (just deletes the token)
  Future<void> logout() async {
    print('AuthService: Logging out - clearing tokens');
    try {
      await _storage.delete(key: 'accessToken');
      await _storage.delete(key: 'refreshToken');
      print('AuthService: Tokens cleared successfully');
    } catch (e) {
      print('AuthService: Error clearing tokens: $e');
    }
  }
}
