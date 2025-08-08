import 'package:flutter/material.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/storage_service_factory.dart';
import '../../data/models/login_request.dart';
import '../../data/models/register_request.dart';
import '../../../../core/models/user_model.dart' as core_models;
import '../../../../core/models/api_response.dart';
import '../../data/models/auth_response.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  bool isLoading = false;
  String? error;
  core_models.UserModel? user;
  bool isLoggedIn = false;

  AuthProvider(this._authService);

  // LinkedIn Login
  Future<void> loginWithLinkedIn() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _authService.initiateLinkedInLogin();
      // The actual login completion will be handled by the deep link handler
    } catch (e) {
      error = 'Failed to initiate LinkedIn login: $e';
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Handle LinkedIn callback
  Future<void> handleLinkedInCallback(Uri callbackUrl) async {
    try {
      final response = await _authService.handleLinkedInCallback(callbackUrl);
      
      if (response.success && response.data != null) {
        user = response.data!.user as core_models.UserModel;
        isLoggedIn = true;
      } else {
        error = response.message;
        isLoggedIn = false;
      }
    } catch (e) {
      error = 'Failed to complete LinkedIn login: $e';
      isLoggedIn = false;
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    final response = await _authService.login(
      LoginRequest(email: email, password: password),
    );
    if (response.success && response.data != null) {
      user = response.data!.user as core_models.UserModel;
      isLoggedIn = true;
    } else {
      error = response.message;
      isLoggedIn = false;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> register(RegisterRequest request) async {
    isLoading = true;
    error = null;
    notifyListeners();

    final response = await _authService.register(request);
    if (response.success && response.data != null) {
      user = response.data;
      // Optionally, you can auto-login or prompt user to login
    } else {
      error = response.message;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    user = null;
    isLoggedIn = false;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final storage = getStorageService();
    final token = await storage.read(key: 'accessToken');
    if (token != null && token.length > 20) {
      // Optionally, fetch user profile from API
      final response = await _authService.getProfile();
      if (response.success && response.data != null) {
        user = response.data!.user as core_models.UserModel;
        isLoggedIn = true;
      } else {
        user = null;
        isLoggedIn = false;
      }
    } else {
      user = null;
      isLoggedIn = false;
    }
    notifyListeners();
  }

  Future<void> debugStorage() async {
    final storage = getStorageService();
    final accessToken = await storage.read(key: 'accessToken');
    final refreshToken = await storage.read(key: 'refreshToken');
    print('=== STORAGE DEBUG ===');
    print('Access Token: $accessToken');
    print('Refresh Token: $refreshToken');
    print('Is Logged In: $isLoggedIn');
    print('User: \\${user?.email}');
    print('==================');
  }

  /// Fetch the latest user profile from the backend and update local state
  Future<void> fetchProfile() async {
    isLoading = true;
    error = null;
    notifyListeners();

    final response = await _authService.getProfile();
    if (response.success && response.data != null) {
      user = response.data!.user as core_models.UserModel;
      isLoggedIn = true;
    } else {
      error = response.message;
      isLoggedIn = false;
    }
    isLoading = false;
    notifyListeners();
  }

  /// Update the user profile on the backend and refresh local state
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // You may need to use your ApiClient here if AuthService doesn't have update
      // For now, let's assume _authService has an updateProfile method
      final response = await _authService.updateProfile(data);
      if (response.success) {
        await fetchProfile();
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        error = response.message;
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
