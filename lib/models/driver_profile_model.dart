// To parse this JSON data, do
//
//     final driverProfileModel = driverProfileModelFromJson(jsonString);

import 'dart:convert';

DriverProfileModel driverProfileModelFromJson(String str) => DriverProfileModel.fromJson(json.decode(str));

String driverProfileModelToJson(DriverProfileModel data) => json.encode(data.toJson());

class DriverProfileModel {
    int? responseCode;
    bool? result;
    String? message;
    DDetail? dDetail;

    DriverProfileModel({
        this.responseCode,
        this.result,
        this.message,
        this.dDetail,
    });

    factory DriverProfileModel.fromJson(Map<String, dynamic> json) => DriverProfileModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        dDetail: json["d_detail"] == null ? null : DDetail.fromJson(json["d_detail"]),
    );

    Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "d_detail": dDetail?.toJson(),
    };
}

class DDetail {
    String? profileImage;
    String? vehicleImage;
    String? firstName;
    String? lastName;
    String? primaryCcode;
    String? primaryPhoneNo;
    String? language;
    String? vehicleNumber;
    String? carColor;
    String? passengerCapacity;
    dynamic joinDate;
    String? prefrenceName;
    String? carName;
    int? totReview;
    int? totCompleteOrder;
    int? rating;

    DDetail({
        this.profileImage,
        this.vehicleImage,
        this.firstName,
        this.lastName,
        this.primaryCcode,
        this.primaryPhoneNo,
        this.language,
        this.vehicleNumber,
        this.carColor,
        this.passengerCapacity,
        this.joinDate,
        this.prefrenceName,
        this.carName,
        this.totReview,
        this.totCompleteOrder,
        this.rating,
    });

    factory DDetail.fromJson(Map<String, dynamic> json) => DDetail(
        profileImage: json["profile_image"],
        vehicleImage: json["vehicle_image"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        primaryCcode: json["primary_ccode"],
        primaryPhoneNo: json["primary_phoneNo"],
        language: json["language"],
        vehicleNumber: json["vehicle_number"],
        carColor: json["car_color"],
        passengerCapacity: json["passenger_capacity"],
        joinDate: json["join_date"],
        prefrenceName: json["prefrence_name"],
        carName: json["car_name"],
        totReview: json["tot_review"],
        totCompleteOrder: json["tot_complete_order"],
        rating: json["rating"],
    );

    Map<String, dynamic> toJson() => {
        "profile_image": profileImage,
        "vehicle_image": vehicleImage,
        "first_name": firstName,
        "last_name": lastName,
        "primary_ccode": primaryCcode,
        "primary_phoneNo": primaryPhoneNo,
        "language": language,
        "vehicle_number": vehicleNumber,
        "car_color": carColor,
        "passenger_capacity": passengerCapacity,
        "join_date": joinDate,
        "prefrence_name": prefrenceName,
        "car_name": carName,
        "tot_review": totReview,
        "tot_complete_order": totCompleteOrder,
        "rating": rating,
    };
}
