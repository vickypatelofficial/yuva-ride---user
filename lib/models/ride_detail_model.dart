// To parse this JSON data, do
//
//     final rideDetailModel = rideDetailModelFromJson(jsonString);

import 'dart:convert';

RideDetailModel rideDetailModelFromJson(String str) => RideDetailModel.fromJson(json.decode(str));

String rideDetailModelToJson(RideDetailModel data) => json.encode(data.toJson());

class RideDetailModel {
    int? responseCode;
    bool? result;
    String? message;
    String? sourceTable;
    String? requestTableId;
    String? cartTableId;
    String? orderTableId;
    String? serviceCategory;
    String? vehicleServiceCategory;
    List<DemList>? demList;
    RequestData? requestData;
    DriverToCustomer? driverToCustomer;

    RideDetailModel({
        this.responseCode,
        this.result,
        this.message,
        this.sourceTable,
        this.requestTableId,
        this.cartTableId,
        this.orderTableId,
        this.serviceCategory,
        this.vehicleServiceCategory,
        this.demList,
        this.requestData,
        this.driverToCustomer,
    });

    factory RideDetailModel.fromJson(Map<String, dynamic> json) => RideDetailModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        sourceTable: json["source_table"],
        requestTableId: json["request_table_id"],
        cartTableId: json["cart_table_id"],
        orderTableId: json["order_table_id"],
        serviceCategory: json["service_category"],
        vehicleServiceCategory: json["vehicle_service_category"],
        demList: json["dem_list"] == null ? [] : List<DemList>.from(json["dem_list"]!.map((x) => DemList.fromJson(x))),
        requestData: json["request_data"] == null ? null : RequestData.fromJson(json["request_data"]),
        driverToCustomer: json["driver_to_customer"] == null ? null : DriverToCustomer.fromJson(json["driver_to_customer"]),
    );

    Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "source_table": sourceTable,
        "request_table_id": requestTableId,
        "cart_table_id": cartTableId,
        "order_table_id": orderTableId,
        "service_category": serviceCategory,
        "vehicle_service_category": vehicleServiceCategory,
        "dem_list": demList == null ? [] : List<dynamic>.from(demList!.map((x) => x.toJson())),
        "request_data": requestData?.toJson(),
        "driver_to_customer": driverToCustomer?.toJson(),
    };
}

class DemList {
    int? id;
    String? title;

    DemList({
        this.id,
        this.title,
    });

    factory DemList.fromJson(Map<String, dynamic> json) => DemList(
        id: json["id"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
    };
}

class DriverToCustomer {
    String? distance;
    String? duration;
    ErLocation? driverLocation;
    ErLocation? customerLocation;

    DriverToCustomer({
        this.distance,
        this.duration,
        this.driverLocation,
        this.customerLocation,
    });

    factory DriverToCustomer.fromJson(Map<String, dynamic> json) => DriverToCustomer(
        distance: json["distance"],
        duration: json["duration"],
        driverLocation: json["driver_location"] == null ? null : ErLocation.fromJson(json["driver_location"]),
        customerLocation: json["customer_location"] == null ? null : ErLocation.fromJson(json["customer_location"]),
    );

    Map<String, dynamic> toJson() => {
        "distance": distance,
        "duration": duration,
        "driver_location": driverLocation?.toJson(),
        "customer_location": customerLocation?.toJson(),
    };
}

class ErLocation {
    double? latitude;
    double? longitude;

    ErLocation({
        this.latitude,
        this.longitude,
    });

    factory ErLocation.fromJson(Map<String, dynamic> json) => ErLocation(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
    };
}

class RequestData {
    int? id;
    String? serviceCategory;
    String? cId;
    String? customerName;
    String? countryCode;
    String? phone;
    String? vehicleid;
    String? picLatLong;
    String? dropLatLong;
    String? picAddress;
    String? dropAddress;
    double? price;
    double? finalPrice;
    String? totKm;
    int? totHour;
    int? totMinute;
    String? status;
    String? paymentId;
    int? tip;
    String? otp;
    DateTime? startTime;
    String? biddingStatus;
    RideTypeInfo? rideTypeInfo;
    TaxiInfo? taxiInfo;

    RequestData({
        this.id,
        this.serviceCategory,
        this.cId,
        this.customerName,
        this.countryCode,
        this.phone,
        this.vehicleid,
        this.picLatLong,
        this.dropLatLong,
        this.picAddress,
        this.dropAddress,
        this.price,
        this.finalPrice,
        this.totKm,
        this.totHour,
        this.totMinute,
        this.status,
        this.paymentId,
        this.tip,
        this.otp,
        this.startTime,
        this.biddingStatus,
        this.rideTypeInfo,
        this.taxiInfo,
    });

    factory RequestData.fromJson(Map<String, dynamic> json) => RequestData(
        id: json["id"],
        serviceCategory: json["service_category"],
        cId: json["c_id"],
        customerName: json["customer_name"],
        countryCode: json["country_code"],
        phone: json["phone"],
        vehicleid: json["vehicleid"],
        picLatLong: json["pic_lat_long"],
        dropLatLong: json["drop_lat_long"],
        picAddress: json["pic_address"],
        dropAddress: json["drop_address"],
        price: json["price"]?.toDouble(),
        finalPrice: json["final_price"]?.toDouble(),
        totKm: json["tot_km"],
        totHour: json["tot_hour"],
        totMinute: json["tot_minute"],
        status: json["status"],
        paymentId: json["payment_id"],
        tip: json["tip"],
        otp: json["otp"],
        startTime: json["start_time"] == null ? null : DateTime.parse(json["start_time"]),
        biddingStatus: json["bidding_status"],
        rideTypeInfo: json["ride_type_info"] == null ? null : RideTypeInfo.fromJson(json["ride_type_info"]),
        taxiInfo: json["taxi_info"] == null ? null : TaxiInfo.fromJson(json["taxi_info"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "service_category": serviceCategory,
        "c_id": cId,
        "customer_name": customerName,
        "country_code": countryCode,
        "phone": phone,
        "vehicleid": vehicleid,
        "pic_lat_long": picLatLong,
        "drop_lat_long": dropLatLong,
        "pic_address": picAddress,
        "drop_address": dropAddress,
        "price": price,
        "final_price": finalPrice,
        "tot_km": totKm,
        "tot_hour": totHour,
        "tot_minute": totMinute,
        "status": status,
        "payment_id": paymentId,
        "tip": tip,
        "otp": otp,
        "start_time": startTime?.toIso8601String(),
        "bidding_status": biddingStatus,
        "ride_type_info": rideTypeInfo?.toJson(),
        "taxi_info": taxiInfo?.toJson(),
    };
}

class RideTypeInfo {
    String? rideType;
    String? riderName;
    String? riderPhone;

    RideTypeInfo({
        this.rideType,
        this.riderName,
        this.riderPhone,
    });

    factory RideTypeInfo.fromJson(Map<String, dynamic> json) => RideTypeInfo(
        rideType: json["ride_type"],
        riderName: json["rider_name"],
        riderPhone: json["rider_phone"],
    );

    Map<String, dynamic> toJson() => {
        "ride_type": rideType,
        "rider_name": riderName,
        "rider_phone": riderPhone,
    };
}

class TaxiInfo {
    int? numberOfPassengers;
    int? vehicleCapacity;

    TaxiInfo({
        this.numberOfPassengers,
        this.vehicleCapacity,
    });

    factory TaxiInfo.fromJson(Map<String, dynamic> json) => TaxiInfo(
        numberOfPassengers: json["number_of_passengers"],
        vehicleCapacity: json["vehicle_capacity"],
    );

    Map<String, dynamic> toJson() => {
        "number_of_passengers": numberOfPassengers,
        "vehicle_capacity": vehicleCapacity,
    };
}
