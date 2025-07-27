import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kenyanvalley/core/constants/api_constants.dart';
import 'package:kenyanvalley/features/payments/data/models/payment_model.dart';
import 'package:kenyanvalley/core/network/api_client.dart';

class PaymentService {
  final ApiClient _apiClient;

  PaymentService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<PaymentModel> initiateMpesaPayment({
    required String eventId,
    required String userId,
    required String phoneNumber,
    required double amount,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiConstants.mpesaInitiate}$eventId',
        body: {
          'userId': userId,
          'phoneNumber': phoneNumber,
          'amount': amount,
        },
      );

      if (response.statusCode == 200) {
        return PaymentModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to initiate M-Pesa payment');
      }
    } catch (e) {
      throw Exception('Error initiating payment: $e');
    }
  }

  Future<PaymentModel> checkPaymentStatus(String paymentId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.mpesaStatusQuery}/$paymentId',
      );

      if (response.statusCode == 200) {
        return PaymentModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to check payment status');
      }
    } catch (e) {
      throw Exception('Error checking payment status: $e');
    }
  }
}
