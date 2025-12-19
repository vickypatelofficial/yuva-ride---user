import 'dart:convert';

AvailableDriverModel availableDriverModelFromJson(String str) =>
    AvailableDriverModel.fromJson(json.decode(str));

class AvailableDriverModel {
  final int? responseCode;
  final bool? result;
  final String? message;
  final String? serviceCategory;
  final String? vehicleId;
  final List<int> driverIds;
  final List<CalDriver> drivers;

  AvailableDriverModel({
    this.responseCode,
    this.result,
    this.message,
    this.serviceCategory,
    this.vehicleId,
    required this.driverIds,
    required this.drivers,
  });

  factory AvailableDriverModel.fromJson(Map<String, dynamic> json) {
    return AvailableDriverModel(
      responseCode: json['ResponseCode'],
      result: json['Result'],
      message: json['message'],
      serviceCategory: json['service_category'],
      vehicleId: json['vehicle_id'],
      driverIds: (json['driver_id'] as List?)
              ?.map((e) => int.tryParse(e.toString()) ?? 0)
              .toList() ??
          [],
      drivers: (json['caldriver'] as List?)
              ?.map((e) => CalDriver.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class CalDriver {
  final int? id;
  final String? image;
  final String? name;
  final String? description;
  final String? latitude;
  final String? longitude;

  CalDriver({
    this.id,
    this.image,
    this.name,
    this.description,
    this.latitude,
    this.longitude,
  });

  factory CalDriver.fromJson(Map<String, dynamic> json) {
    return CalDriver(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      description: json['description'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
