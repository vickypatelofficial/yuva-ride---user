// To parse this JSON data, do
//
//     final cancelRideReasonModel = cancelRideReasonModelFromJson(jsonString);

import 'dart:convert';

CancelRideReasonModel cancelRideReasonModelFromJson(String str) => CancelRideReasonModel.fromJson(json.decode(str));

String cancelRideReasonModelToJson(CancelRideReasonModel data) => json.encode(data.toJson());

class CancelRideReasonModel {
    int? responseCode;
    bool? result;
    String? message;
    List<RideCancelList>? rideCancelList;

    CancelRideReasonModel({
        this.responseCode,
        this.result,
        this.message,
        this.rideCancelList,
    });

    factory CancelRideReasonModel.fromJson(Map<String, dynamic> json) => CancelRideReasonModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        rideCancelList: json["ride_cancel_list"] == null ? [] : List<RideCancelList>.from(json["ride_cancel_list"]!.map((x) => RideCancelList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "ride_cancel_list": rideCancelList == null ? [] : List<dynamic>.from(rideCancelList!.map((x) => x.toJson())),
    };
}

class RideCancelList {
    int? id;
    String? title;

    RideCancelList({
        this.id,
        this.title,
    });

    factory RideCancelList.fromJson(Map<String, dynamic> json) => RideCancelList(
        id: json["id"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
    };
}
