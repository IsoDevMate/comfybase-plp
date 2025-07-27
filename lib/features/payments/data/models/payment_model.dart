import 'package:json_annotation/json_annotation.dart';

part 'payment_model.g.dart';

@JsonSerializable()
class PaymentModel {
  final String paymentId;
  final String merchantRequestId;
  final String checkoutRequestId;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PaymentModel({
    required this.paymentId,
    required this.merchantRequestId,
    required this.checkoutRequestId,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);
}
