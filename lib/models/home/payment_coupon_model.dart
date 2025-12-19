import 'dart:convert';

PaymentCouponModel paymentCouponModelFromJson(String str) =>
    PaymentCouponModel.fromJson(json.decode(str));

class PaymentCouponModel {
  final int? responseCode;
  final bool? result;
  final String? message;
  final String? defaultPayment;
  final List<CouponModel> couponList;
  final List<PaymentModel> paymentList;
  final List<dynamic> bankData;

  PaymentCouponModel({
    this.responseCode,
    this.result,
    this.message,
    this.defaultPayment,
    required this.couponList,
    required this.paymentList,
    required this.bankData,
  });

  factory PaymentCouponModel.fromJson(Map<String, dynamic> json) {
    return PaymentCouponModel(
      responseCode: json['ResponseCode'],
      result: json['Result'],
      message: json['message'],
      defaultPayment: json['default_payment']?.toString(),
      couponList: (json['coupon_list'] as List?)
              ?.map((e) => CouponModel.fromJson(e))
              .toList() ??
          [],
      paymentList: (json['payment_list'] as List?)
              ?.map((e) => PaymentModel.fromJson(e))
              .toList() ??
          [],
      bankData: json['bank_data'] ?? [],
    );
  }
}
class CouponModel {
  final int? id;
  final String? title;
  final String? subTitle;
  final String? code;
  final String? startDate;
  final String? endDate;
  final String? minAmount;
  final String? discountAmount;

  CouponModel({
    this.id,
    this.title,
    this.subTitle,
    this.code,
    this.startDate,
    this.endDate,
    this.minAmount,
    this.discountAmount,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'],
      title: json['title'],
      subTitle: json['sub_title'],
      code: json['code'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      minAmount: json['min_amount'],
      discountAmount: json['discount_amount'],
    );
  }
}
class PaymentModel {
  final int? id;
  final String? image;
  final String? name;
  final String? subTitle;
  final String? attribute;
  final String? status;
  final String? walletStatus;

  PaymentModel({
    this.id,
    this.image,
    this.name,
    this.subTitle,
    this.attribute,
    this.status,
    this.walletStatus,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      subTitle: json['sub_title'],
      attribute: json['attribute'],
      status: json['status'],
      walletStatus: json['wallet_status'],
    );
  }
}
