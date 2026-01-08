import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  late Razorpay _razorpay;

  Function(PaymentSuccessResponse)? onSuccess;
  Function(PaymentFailureResponse)? onError;

  RazorpayService() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleError);
  }

  void openCheckout({
    required String key,
    required int amount,
    required String name,
    required String orderId,
    required String phone,
    required String email,
  }) {
    final options = {
      'key': key,
      'amount': amount,
      'name': name,
      'order_id': orderId,
      'prefill': {
        'contact': phone,
        'email': email,
      },
    };

    _razorpay.open(options);
  }

  void _handleSuccess(PaymentSuccessResponse response) {
    onSuccess?.call(response);
  }

  void _handleError(PaymentFailureResponse response) {
    onError?.call(response);
  }

  void dispose() {
    _razorpay.clear();
  }
}
