import 'package:dio/dio.dart' as dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../../features/auth/data/models/login_request.dart';
import '../../features/auth/data/models/register_request.dart';
import '../../features/auth/data/models/auth_response.dart';
import '../models/api_response.dart';
import '../constants/api_constants.dart';
import '../constants/storage_constants.dart';
import '../../core/models/user_model.dart' as core_models;
import 'storage_service.dart';
import 'storage_service_factory.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final dio.Dio _dio = dio.Dio(
    dio.BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: Duration(milliseconds: 60000), // Increased timeout
      receiveTimeout: Duration(milliseconds: 60000), // Increased timeout
      headers: {'Content-Type': 'application/json'},
    ),
  );

  final StorageService _storage = getStorageService();

  // LinkedIn OAuth
  Future<void> initiateLinkedInLogin() async {
    try {
      // First, get the LinkedIn authorization URL from our backend
      final response = await _dio.get('${ApiConstants.linkedinAuthUrl}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final authUrl = response.data['data']['url'];
        print('LinkedIn auth URL: $authUrl');

        if (await canLaunchUrl(Uri.parse(authUrl))) {
          await launchUrl(
            Uri.parse(authUrl),
            mode: LaunchMode.externalApplication,
          );
        } else {
          throw 'Could not launch LinkedIn authorization URL';
        }
      } else {
        throw 'Failed to get LinkedIn authorization URL';
      }
    } catch (e) {
      print('Error initiating LinkedIn login: $e');
      rethrow;
    }
  }

  // Handle LinkedIn callback
  Future<ApiResponse<AuthResponse>> handleLinkedInCallback(
    Uri callbackUrl,
  ) async {
    try {
      print('Handling LinkedIn callback with URL: $callbackUrl');

      // Extract authorization code from URL parameters
      final code = callbackUrl.queryParameters['code'];
      final state = callbackUrl.queryParameters['state'];

      print('Extracted code: ${code != null ? 'present' : 'missing'}');
      print('Extracted state: ${state != null ? 'present' : 'missing'}');

      if (code == null) {
        throw 'Missing authorization code in the callback URL';
      }

      // Exchange authorization code for tokens
      final tokenResponse = await _dio.post(
        '${ApiConstants.linkedinCallbackUrl}',
        data: {'code': code, 'state': state},
      );

      print('Token exchange response: ${tokenResponse.data}');

      if (tokenResponse.statusCode == 200 &&
          tokenResponse.data['success'] == true) {
        final data = tokenResponse.data['data'];
        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];

        if (accessToken == null || refreshToken == null) {
          throw 'Missing tokens in response';
        }

        // Store tokens in secure storage
        await _storage.write(
          key: StorageConstants.accessToken,
          value: accessToken,
        );
        await _storage.write(
          key: StorageConstants.refreshToken,
          value: refreshToken,
        );
        print('Successfully stored tokens in secure storage');

        // Set the authorization header for subsequent requests
        _dio.options.headers['Authorization'] = 'Bearer $accessToken';

        // Fetch and return the user profile
        print('Fetching user profile...');
        final profileResponse = await getProfile();

        if (profileResponse.success && profileResponse.data != null) {
          print('Successfully fetched user profile');
          return profileResponse;
        } else {
          print('Failed to fetch user profile: ${profileResponse.message}');
          throw profileResponse.message ?? 'Failed to fetch user profile';
        }
      } else {
        throw 'Failed to exchange authorization code for tokens';
      }
    } catch (e, stackTrace) {
      print('Error handling LinkedIn callback: $e');
      print('Stack trace: $stackTrace');

      // Clear any stored tokens on error
      await _storage.delete(key: StorageConstants.accessToken);
      await _storage.delete(key: StorageConstants.refreshToken);

      return ApiResponse<AuthResponse>(
        success: false,
        message: 'Failed to complete LinkedIn authentication: $e',
        data: null,
      );
    }
  }

  // Login
  Future<ApiResponse<AuthResponse>> login(LoginRequest request) async {
    try {
      print('AuthService: Starting login request');
      final response = await _dio.post(
        ApiConstants.login,
        data: request.toJson(),
      );
      print('AuthService: Raw Dio response: \n${response.data}');

      // Manual parsing with better error handling
      final data = response.data;
      final bool success = data['success'] == true;
      final String message = data['message'] ?? '';
      AuthResponse? authResponse;

      if (success && data['data'] != null) {
        try {
          print('AuthService: Parsing data: ${data['data']}');

          // Extract user and tokens separately for better debugging
          final userData = data['data']['user'] as Map<String, dynamic>;
          final tokensData = data['data']['tokens'] as Map<String, dynamic>;

          print('AuthService: User data: $userData');
          print('AuthService: Tokens data: $tokensData');

          // Parse user model
          final user = core_models.UserModel.fromJson(userData);
          print('AuthService: User parsed successfully: ${user.email}');

          // Parse tokens model
          final tokens = TokensModel.fromJson(tokensData);
          print('AuthService: Tokens parsed successfully');

          // Create auth response
          authResponse = AuthResponse(user: user, tokens: tokens);
          print('AuthService: Successfully created auth response');

          // Debug: Print token info
          print('AuthService: Access Token: ${tokens.accessToken}');
          print('AuthService: Refresh Token: ${tokens.refreshToken}');
          print('AuthService: Expires In: ${tokens.expiresIn}');
        } catch (e, stackTrace) {
          print('AuthService: Error parsing AuthResponse: $e');
          print('AuthService: Stack trace: $stackTrace');
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

          if (accessToken.isNotEmpty) {
            await _storage.write(
              key: StorageConstants.accessToken,
              value: accessToken,
            );
            print('AuthService: Access token stored successfully');
          } else {
            print('AuthService: Access token is empty');
          }

          if (refreshToken.isNotEmpty) {
            await _storage.write(
              key: StorageConstants.refreshToken,
              value: refreshToken,
            );
            print('AuthService: Refresh token stored successfully');
          } else {
            print('AuthService: Refresh token is empty');
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
      print('AuthService: Dio error type: ${e.type}');

      String errorMessage;
      switch (e.type) {
        case dio.DioExceptionType.connectionTimeout:
          errorMessage =
              'Connection timeout. Please check your internet connection.';
          break;
        case dio.DioExceptionType.receiveTimeout:
          errorMessage = 'Server response timeout. Please try again.';
          break;
        case dio.DioExceptionType.connectionError:
          errorMessage =
              'Connection error. Please check your internet connection.';
          break;
        default:
          errorMessage = 'Network error: ${e.message}';
      }

      return ApiResponse<AuthResponse>(
        success: false,
        message: errorMessage,
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

  Future<ApiResponse<core_models.UserModel>> register(
    RegisterRequest request,
  ) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: request.toJson(),
      );
      final apiResponse = ApiResponse<core_models.UserModel>.fromJson(
        response.data,
        (json) => core_models.UserModel.fromJson(json as Map<String, dynamic>),
      );
      return apiResponse;
    } on dio.DioException catch (e) {
      return ApiResponse<core_models.UserModel>(
        success: false,
        message: 'Network error: ${e.message}',
        data: null,
        errors: [e.toString()],
      );
    } catch (e) {
      return ApiResponse<core_models.UserModel>(
        success: false,
        message: 'Registration failed: $e',
        data: null,
        errors: [e.toString()],
      );
    }
  }

  Future<ApiResponse<AuthResponse>> getProfile() async {
    try {
      final token = await _storage.read(key: StorageConstants.accessToken);
      print('AuthService: Getting profile with token: ${token != null}');

      if (token == null) {
        return ApiResponse<AuthResponse>(
          success: false,
          message: 'No access token found',
          data: null,
          errors: ['No access token'],
        );
      }

      // Set the authorization header
      _dio.options.headers['Authorization'] = 'Bearer $token';

      print('AuthService: Fetching user profile from ${ApiConstants.profile}');
      final response = await _dio.get(
        ApiConstants.profile,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      print('AuthService: Profile API response status: ${response.statusCode}');
      print('AuthService: Profile API response data: ${response.data}');

      if (response.statusCode == 200) {
        try {
          // Handle different response formats
          final responseData = response.data is String
              ? Map<String, dynamic>.from(jsonDecode(response.data))
              : response.data as Map<String, dynamic>;

          // Extract user data from the response
          final userData =
              responseData['data']?['user'] ?? responseData['user'];

          if (userData == null) {
            throw 'User data not found in response';
          }

          // Convert the user data to UserModel
          final user = core_models.UserModel.fromJson(
            userData is Map<String, dynamic>
                ? userData
                : userData as Map<String, dynamic>,
          );

          // Create tokens model if available
          final tokensData =
              responseData['data']?['tokens'] ?? responseData['tokens'];
          TokensModel? tokens;

          if (tokensData != null) {
            tokens = TokensModel.fromJson(
              tokensData is Map<String, dynamic>
                  ? tokensData
                  : tokensData as Map<String, dynamic>,
            );

            // Update stored tokens if new ones are provided
            if (tokens.accessToken.isNotEmpty) {
              await _storage.write(
                key: StorageConstants.accessToken,
                value: tokens.accessToken,
              );
            }
            if (tokens.refreshToken.isNotEmpty) {
              await _storage.write(
                key: StorageConstants.refreshToken,
                value: tokens.refreshToken,
              );
            }
          }

          // Create and return the auth response
          return ApiResponse<AuthResponse>(
            success: true,
            message: 'Profile retrieved successfully',
            data: AuthResponse(
              user: user,
              tokens:
                  tokens ??
                  TokensModel(
                    accessToken: token,
                    refreshToken: '',
                    expiresIn: 3600,
                  ),
            ),
          );
        } catch (e, stackTrace) {
          print('Error parsing profile response: $e');
          print('Stack trace: $stackTrace');
          throw 'Failed to parse user profile: $e';
        }
      } else {
        final errorMessage =
            response.data?['message'] ??
            response.statusMessage ??
            'Failed to fetch profile';
        throw errorMessage;
      }
    } on dio.DioException catch (e) {
      print('AuthService: Profile fetch Dio error: ${e.message}');
      print('Dio error type: ${e.type}');
      print('Dio response: ${e.response?.data}');

      // Handle 401 Unauthorized
      if (e.response?.statusCode == 401) {
        await _storage.delete(key: StorageConstants.accessToken);
        await _storage.delete(key: StorageConstants.refreshToken);
      }

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

  /// Update user profile
  Future<ApiResponse<dynamic>> updateProfile(Map<String, dynamic> data) async {
    try {
      final token = await _storage.read(key: 'accessToken');
      if (token == null) {
        return ApiResponse<dynamic>(
          success: false,
          message: 'No access token found',
          data: null,
          errors: ['No access token'],
        );
      }

      final response = await _dio.put(
        ApiConstants.updateProfile,
        data: data,
        options: dio.Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return ApiResponse<dynamic>.fromJson(
        response.data,
        (json) => json, // You can parse to your user model if needed
      );
    } on dio.DioException catch (e) {
      return ApiResponse<dynamic>(
        success: false,
        message: 'Network error: ${e.message}',
        data: null,
        errors: [e.toString()],
      );
    } catch (e) {
      return ApiResponse<dynamic>(
        success: false,
        message: 'Profile update failed: $e',
        data: null,
        errors: [e.toString()],
      );
    }
  }

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
