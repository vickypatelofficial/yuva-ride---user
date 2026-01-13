class ActiveRideModel {
  final int? responseCode;
  final bool? result;
  final String? message;
  final ActiveRideData? data;
  final String? rideStatus;

  ActiveRideModel({
    this.responseCode,
    this.result,
    this.message,
    this.data,
    this.rideStatus,
  });

  factory ActiveRideModel.fromJson(Map<String, dynamic> json) {
    return ActiveRideModel(
      responseCode: json['ResponseCode'],
      result: json['Result'],
      message: json['message'],
      data: json['data'] != null ? ActiveRideData.fromJson(json['data']) : null,
      rideStatus: json['ride_status'],
    );
  }
}
class ActiveRideData {
  final String? requestId;
  final String? customerId;
  final String? driverId;
  final String? vehicleId;
  final String? status;
  final String? rideStatus;
  final String? serviceCategory;

  final double price;
  final double finalPrice;

  final String? pickupLatLong;
  final String? dropLatLong;
  final String? pickupAddress;
  final String? dropAddress;

  final String? otp;

  final String? customerName;
  final String? customerPhone;
  final String? customerImage;

  ActiveRideData({
    this.requestId,
    this.customerId,
    this.driverId,
    this.vehicleId,
    this.status,
    this.rideStatus,
    this.serviceCategory,
    required this.price,
    required this.finalPrice,
    this.pickupLatLong,
    this.dropLatLong,
    this.pickupAddress,
    this.dropAddress,
    this.otp,
    this.customerName,
    this.customerPhone,
    this.customerImage,
  });

  factory ActiveRideData.fromJson(Map<String, dynamic> json) {
    return ActiveRideData(
      requestId: json['req_id']?.toString()??json['id']?.toString(),
      customerId: json['c_id']?.toString(),
      driverId: json['d_id']?.toString(),
      vehicleId: json['vehicleid']?.toString(),
      status: json['status']?.toString(),
      rideStatus: json['ride_status']?.toString(),
      serviceCategory: json['service_category'],
      price: _toDouble(json['price']),
      finalPrice: _toDouble(json['final_price']),
      pickupLatLong: json['pic_lat_long'],
      dropLatLong: json['drop_lat_long'],
      pickupAddress: json['pic_address'],
      dropAddress: json['drop_address'],
      otp: json['otp'],
      customerName: json['customer_name'],
      customerPhone: json['customer_phone'],
      customerImage: json['customer_image'],
    );
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }
}
