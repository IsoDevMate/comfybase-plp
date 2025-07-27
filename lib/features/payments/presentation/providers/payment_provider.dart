import 'package:flutter/material.dart';
import 'package:kenyanvalley/features/payments/data/datasources/payment_service.dart';
import 'package:kenyanvalley/features/payments/data/models/payment_model.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentService _paymentService;
  
  PaymentModel? _currentPayment;
  PaymentModel? get currentPayment => _currentPayment;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _error;
  String? get error => _error;
  
  PaymentProvider({PaymentService? paymentService}) 
      : _paymentService = paymentService ?? PaymentService();
  
  Future<PaymentModel> initiatePayment({
    required String eventId,
    required String userId,
    required String phoneNumber,
    required double amount,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final payment = await _paymentService.initiateMpesaPayment(
        eventId: eventId,
        userId: userId,
        phoneNumber: phoneNumber,
        amount: amount,
      );
      
      _currentPayment = payment;
      _isLoading = false;
      notifyListeners();
      return payment;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
  
  Future<void> checkPaymentStatus(String paymentId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final payment = await _paymentService.checkPaymentStatus(paymentId);
      _currentPayment = payment;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
