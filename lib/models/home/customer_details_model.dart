import 'dart:convert';

CustomerResponse customerResponseFromJson(String str) =>
    CustomerResponse.fromJson(json.decode(str));

String customerResponseToJson(CustomerResponse data) =>
    json.encode(data.toJson());

class CustomerResponse {
  final int? responseCode;
  final bool? result;
  final String? message;
  final General? general;
  final CustomerData? customerData;

  CustomerResponse({
    this.responseCode,
    this.result,
    this.message,
    this.general,
    this.customerData,
  });

  factory CustomerResponse.fromJson(Map<String, dynamic> json) {
    return CustomerResponse(
      responseCode: json['ResponseCode'],
      result: json['Result'],
      message: json['message'],
      general:
          json['general'] != null ? General.fromJson(json['general']) : null,
      customerData: json['customer_data'] != null
          ? CustomerData.fromJson(json['customer_data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ResponseCode': responseCode,
      'Result': result,
      'message': message,
      'general': general?.toJson(),
      'customer_data': customerData?.toJson(),
    };
  }
}

class CustomerData {
  final int? id;
  final String? profileImage;
  final String? name;
  final String? email;
  final String? countryCode;
  final String? phone;
  final String? password;
  final String? status;
  final String? referralCode;
  final String? wallet;
  final DateTime? date;
  final String? fcmToken;
  final String? platform;
  final String? tokenUpdatedAt;
  final String? oneSignalId;

  CustomerData({
    this.id,
    this.profileImage,
    this.name,
    this.email,
    this.countryCode,
    this.phone,
    this.password,
    this.status,
    this.referralCode,
    this.wallet,
    this.date,
    this.fcmToken,
    this.platform,
    this.tokenUpdatedAt,
    this.oneSignalId,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      id: json['id'],
      profileImage: json['profile_image'],
      name: json['name'],
      email: json['email'],
      countryCode: json['country_code'],
      phone: json['phone'],
      password: json['password'],
      status: json['status'],
      referralCode: json['referral_code'],
      wallet: json['wallet'],
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      fcmToken: json['fcm_token'],
      platform: json['platform'],
      tokenUpdatedAt: json['token_updated_at'],
      oneSignalId: json['one_signal_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_image': profileImage,
      'name': name,
      'email': email,
      'country_code': countryCode,
      'phone': phone,
      'password': password,
      'status': status,
      'referral_code': referralCode,
      'wallet': wallet,
      'date': date?.toIso8601String(),
      'fcm_token': fcmToken,
      'platform': platform,
      'token_updated_at': tokenUpdatedAt,
      'one_signal_id': oneSignalId,
    };
  }
}

class General {
  final String? oneAppId;
  final String? oneApiKey;

  General({
    this.oneAppId,
    this.oneApiKey,
  });

  factory General.fromJson(Map<String, dynamic> json) {
    return General(
      oneAppId: json['one_app_id'],
      oneApiKey: json['one_api_key'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'one_app_id': oneAppId,
      'one_api_key': oneApiKey,
    };
  }
}
