import 'package:kenyanvalley/features/payments/data/datasources/payment_service.dart';
import 'package:kenyanvalley/features/payments/domain/repositories/payment_repository.dart';
import 'package:kenyanvalley/features/payments/domain/usecases/initiate_payment.dart';
import 'package:kenyanvalley/features/payments/domain/usecases/check_payment_status.dart';
import 'package:kenyanvalley/features/payments/presentation/providers/payment_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> getPaymentProviders() {
  final paymentService = PaymentService();

  return [
    ChangeNotifierProvider(
      create: (context) => PaymentProvider(paymentService: paymentService),
    ),
  ];
}
