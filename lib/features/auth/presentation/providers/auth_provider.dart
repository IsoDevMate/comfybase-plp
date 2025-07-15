import 'package:flutter/material.dart';
import '../../../../core/services/auth_service.dart';
import '../../data/models/login_request.dart';
import '../../data/models/register_request.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/models/api_response.dart';
import '../../data/models/auth_response.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  bool isLoading = false;
  String? error;
  UserModel? user;
  bool isLoggedIn = false;

  AuthProvider(this._authService);

  Future<void> login(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    final response = await _authService.login(
      LoginRequest(email: email, password: password),
    );
    if (response.success && response.data != null) {
      user = response.data!.user;
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
}
