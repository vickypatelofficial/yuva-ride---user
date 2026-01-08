import 'dart:convert';

/// ================= SAFE PARSERS =================

double parseToDouble(dynamic value, {double defaultValue = 0.0}) {
  if (value == null) return defaultValue;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    final cleaned =
        value.trim().replaceAll(RegExp(r'[^0-9.-]'), '');
    return double.tryParse(cleaned) ?? defaultValue;
  }
  return defaultValue;
}

int parseToInt(dynamic value, {int defaultValue = 0}) {
  if (value == null) return defaultValue;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) {
    return int.tryParse(value.trim()) ?? defaultValue;
  }
  return defaultValue;
}

bool parseToBool(dynamic value, {bool defaultValue = false}) {
  if (value == null) return defaultValue;
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) {
    return value.toLowerCase() == 'true' || value == '1';
  }
  return defaultValue;
}

String parseToString(dynamic value, {String defaultValue = ''}) {
  if (value == null) return defaultValue;
  return value.toString();
}

DateTime? parseToDate(dynamic value) {
  if (value == null) return null;
  try {
    return DateTime.parse(value.toString());
  } catch (_) {
    return null;
  }
}

/// ================= MAIN MODEL =================

RideDetailModel rideDetailModelFromJson(String str) =>
    RideDetailModel.fromJson(json.decode(str));

class RideDetailModel {
  int responseCode;
  bool result;
  String message;
  String sourceTable;
  String requestTableId;
  String cartTableId;
  String orderTableId;
  String serviceCategory;
  String vehicleServiceCategory;
  List<DemList> demList;
  RequestData? requestData;
  DriverToCustomer? driverToCustomer;

  RideDetailModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.sourceTable,
    required this.requestTableId,
    required this.cartTableId,
    required this.orderTableId,
    required this.serviceCategory,
    required this.vehicleServiceCategory,
    required this.demList,
    this.requestData,
    this.driverToCustomer,
  });

  factory RideDetailModel.fromJson(Map<String, dynamic> json) {
    return RideDetailModel(
      responseCode: parseToInt(json["ResponseCode"]),
      result: parseToBool(json["Result"]),
      message: parseToString(json["message"]),
      sourceTable: parseToString(json["source_table"]),
      requestTableId: parseToString(json["request_table_id"]),
      cartTableId: parseToString(json["cart_table_id"]),
      orderTableId: parseToString(json["order_table_id"]),
      serviceCategory: parseToString(json["service_category"]),
      vehicleServiceCategory:
          parseToString(json["vehicle_service_category"]),
      demList: (json["dem_list"] as List?)
              ?.map((e) => DemList.fromJson(e))
              .toList() ??
          [],
      requestData: json["request_data"] == null
          ? null
          : RequestData.fromJson(json["request_data"]),
      driverToCustomer: json["driver_to_customer"] == null
          ? null
          : DriverToCustomer.fromJson(json["driver_to_customer"]),
    );
  }
}

/// ================= SUB MODELS =================

class DemList {
  int id;
  String title;

  DemList({required this.id, required this.title});

  factory DemList.fromJson(Map<String, dynamic> json) => DemList(
        id: parseToInt(json["id"]),
        title: parseToString(json["title"]),
      );
}

class DriverToCustomer {
  String distance;
  String duration;
  ErLocation? driverLocation;
  ErLocation? customerLocation;

  DriverToCustomer({
    required this.distance,
    required this.duration,
    this.driverLocation,
    this.customerLocation,
  });

  factory DriverToCustomer.fromJson(Map<String, dynamic> json) =>
      DriverToCustomer(
        distance: parseToString(json["distance"]),
        duration: parseToString(json["duration"]),
        driverLocation: json["driver_location"] == null
            ? null
            : ErLocation.fromJson(json["driver_location"]),
        customerLocation: json["customer_location"] == null
            ? null
            : ErLocation.fromJson(json["customer_location"]),
      );
}

class ErLocation {
  double latitude;
  double longitude;

  ErLocation({
    required this.latitude,
    required this.longitude,
  });

  factory ErLocation.fromJson(Map<String, dynamic> json) => ErLocation(
        latitude: parseToDouble(json["latitude"]),
        longitude: parseToDouble(json["longitude"]),
      );
}

class RequestData {
  int id;
  String serviceCategory;
  String cId;
  String customerName;
  String countryCode;
  String phone;
  String vehicleid;
  String picLatLong;
  String dropLatLong;
  String picAddress;
  String dropAddress;
  double price;
  double finalPrice;
  double extraAmount;
  double platformFee;
  double weatherPrice;
  double addiTimePrice;
  double couponAmount;
  double baseFarePerUnit;
  String totKm;
  int totHour;
  int totMinute;
  String status;
  String paymentId;
  int tip;
  String otp;
  DateTime? startTime;
  String biddingStatus;
  RideTypeInfo? rideTypeInfo;
  TaxiInfo? taxiInfo;

  RequestData({
    required this.id,
    required this.serviceCategory,
    required this.cId,
    required this.customerName,
    required this.countryCode,
    required this.phone,
    required this.vehicleid,
    required this.picLatLong,
    required this.dropLatLong,
    required this.picAddress,
    required this.dropAddress,
    required this.price,
    required this.finalPrice,
    required this.extraAmount,
    required this.platformFee,
    required this.weatherPrice,
    required this.addiTimePrice,
    required this.couponAmount,
    required this.baseFarePerUnit,
    required this.totKm,
    required this.totHour,
    required this.totMinute,
    required this.status,
    required this.paymentId,
    required this.tip,
    required this.otp,
    this.startTime,
    required this.biddingStatus,
    this.rideTypeInfo,
    this.taxiInfo,
  });

  factory RequestData.fromJson(Map<String, dynamic> json) => RequestData(
        id: parseToInt(json["id"]),
        serviceCategory: parseToString(json["service_category"]),
        cId: parseToString(json["c_id"]),
        customerName: parseToString(json["customer_name"]),
        countryCode: parseToString(json["country_code"]),
        phone: parseToString(json["phone"]),
        vehicleid: parseToString(json["vehicleid"]),
        picLatLong: parseToString(json["pic_lat_long"]),
        dropLatLong: parseToString(json["drop_lat_long"]),
        picAddress: parseToString(json["pic_address"]),
        dropAddress: parseToString(json["drop_address"]),
        price: parseToDouble(json["price"]),
        finalPrice: parseToDouble(json["final_price"]),
        extraAmount: parseToDouble(json["extra_amount"]),
        platformFee: parseToDouble(json["platform_fee"]),
        weatherPrice: parseToDouble(json["weather_price"]),
        addiTimePrice: parseToDouble(json["addi_time_price"]),
        couponAmount: parseToDouble(json["coupon_amount"]),
        baseFarePerUnit:
            parseToDouble(json["base_fare_per_unit"]),
        totKm: parseToString(json["tot_km"]),
        totHour: parseToInt(json["tot_hour"]),
        totMinute: parseToInt(json["tot_minute"]),
        status: parseToString(json["status"]),
        paymentId: parseToString(json["payment_id"]),
        tip: parseToInt(json["tip"]),
        otp: parseToString(json["otp"]),
        startTime: parseToDate(json["start_time"]),
        biddingStatus: parseToString(json["bidding_status"]),
        rideTypeInfo: json["ride_type_info"] == null
            ? null
            : RideTypeInfo.fromJson(json["ride_type_info"]),
        taxiInfo: json["taxi_info"] == null
            ? null
            : TaxiInfo.fromJson(json["taxi_info"]),
      );
}

class RideTypeInfo {
  String rideType;
  String riderName;
  String riderPhone;

  RideTypeInfo({
    required this.rideType,
    required this.riderName,
    required this.riderPhone,
  });

  factory RideTypeInfo.fromJson(Map<String, dynamic> json) =>
      RideTypeInfo(
        rideType: parseToString(json["ride_type"]),
        riderName: parseToString(json["rider_name"]),
        riderPhone: parseToString(json["rider_phone"]),
      );
}

class TaxiInfo {
  int numberOfPassengers;
  int vehicleCapacity;

  TaxiInfo({
    required this.numberOfPassengers,
    required this.vehicleCapacity,
  });

  factory TaxiInfo.fromJson(Map<String, dynamic> json) =>
      TaxiInfo(
        numberOfPassengers:
            parseToInt(json["number_of_passengers"]),
        vehicleCapacity:
            parseToInt(json["vehicle_capacity"]),
      );
}
