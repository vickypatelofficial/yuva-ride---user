import 'dart:convert';

RideListResponse rideListResponseFromJson(dynamic json) =>
    RideListResponse.fromJson(json);

class RideListResponse {
  final int responseCode;
  final bool result;
  final String message;
  final List<RideItem> data;

  RideListResponse({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.data,
  });

  factory RideListResponse.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      return RideListResponse(
        responseCode: 0,
        result: false,
        message: "Invalid response",
        data: [],
      );
    }

    return RideListResponse(
      responseCode: _toInt(json['ResponseCode']),
      result: json['Result'] == true,
      message: json['message']?.toString() ?? '',
      data: json['Reuqest_list'] is List
          ? (json['Reuqest_list'] as List)
              .map((e) => RideItem.fromJson(e))
              .toList()
          : [],
    );
  }
}

class RideItem {
  final String id;
  final String? serviceCategory;
  final String? vehicleName;
  final String pickupAddress;
  final String dropAddress;
  final double price;
  final String? paymentType;
  final String status;
  final DateTime? createdAt;

  RideItem({
    required this.id,
    this.serviceCategory,
    this.vehicleName,
    required this.pickupAddress,
    required this.dropAddress,
    required this.price,
    this.paymentType,
    required this.status,
    this.createdAt,
  });

  factory RideItem.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      return RideItem.empty();
    }

    return RideItem(
      id: json['id']?.toString() ?? '',
      serviceCategory: json['service_category']?.toString() ?? '',
      vehicleName: json['vehicle_name']?.toString() ?? '',
      pickupAddress: json['pic_address']?.toString() ?? '',
      dropAddress: json['drop_address']?.toString() ?? '',
      price: _toDouble(json['price']),
      paymentType: json['p_name']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: _toDate(json['created_at']),
    );
  }

  factory RideItem.empty() {
    return RideItem(
      id: '',
      serviceCategory: '',
      vehicleName: '',
      pickupAddress: '',
      dropAddress: '',
      price: 0,
      paymentType: '',
      status: '',
      createdAt: null,
    );
  }
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

DateTime? _toDate(dynamic value) {
  if (value == null) return null;
  try {
    return DateTime.parse(value.toString());
  } catch (_) {
    return null;
  }
}
