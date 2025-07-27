import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kenyanvalley/features/payments/presentation/providers/payment_provider.dart';
import 'package:kenyanvalley/core/theme/app_colors.dart';
import 'package:kenyanvalley/core/theme/app_text_styles.dart';

class PaymentModal extends StatefulWidget {
  final String eventId;
  final double amount;
  final String userId;

  const PaymentModal({
    Key? key,
    required this.eventId,
    required this.amount,
    required this.userId,
  }) : super(key: key);

  @override
  _PaymentModalState createState() => _PaymentModalState();
}

class _PaymentModalState extends State<PaymentModal> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _initiatePayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final paymentProvider = context.read<PaymentProvider>();
      await paymentProvider.initiatePayment(
        eventId: widget.eventId,
        userId: widget.userId,
        phoneNumber: _phoneController.text.trim(),
        amount: widget.amount,
      );
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment initiated. Please check your phone to complete the transaction.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Complete Payment'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Amount: KES ${widget.amount.toStringAsFixed(2)}',
                style: AppTextStyles.titleMedium,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'M-Pesa Phone Number',
                  hintText: 'e.g. 254712345678',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  // Basic validation for Kenyan phone numbers
                  final phoneRegex = RegExp(r'^(?:254|\+254|0)?(7\d{8})$');
                  if (!phoneRegex.hasMatch(value)) {
                    return 'Please enter a valid Kenyan phone number';
                  }
                  return null;
                },
              ),
              if (_error != null) ...{
                const SizedBox(height: 16),
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              },
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _initiatePayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('PAY NOW'),
        ),
      ],
    );
  }
}
