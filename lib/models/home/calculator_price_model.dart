import 'dart:convert';

CalculatedPriceModel taxiOptionResponseFromJson(String str) =>
    CalculatedPriceModel.fromJson(json.decode(str));

class CalculatedPriceModel {
  final int responseCode;
  final bool result;
  final String message;
  final String serviceCategory;
  final List<CalDriver> calDriver;

  CalculatedPriceModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.serviceCategory,
    required this.calDriver,
  });

  factory CalculatedPriceModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return CalculatedPriceModel(
        responseCode: 0,
        result: false,
        message: "",
        serviceCategory: "",
        calDriver: [],
      );
    }

    return CalculatedPriceModel(
      responseCode: _toInt(json['ResponseCode']),
      result: json['Result'] == true,
      message: json['message']?.toString() ?? "",
      serviceCategory: json['service_category']?.toString() ?? "",
      calDriver: (json['caldriver'] as List?)
              ?.map((e) => CalDriver.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class CalDriver {
  final int id;
  final String image;
  final String mapImage;
  final String name;
  final String serviceCategory;
  final String vehicleType;
  final String description;

  final double minKmDistance;
  final double minKmPrice;
  final double afterKmPrice;
  final double extraCharge;

  final int passengerCapacity;
  final int availableDrivers;
  final int numberOfPassengers;

  final double dropPrice;
  final double dropKm;
  final int dropTime;

  final PricingBreakdown pricing;

  CalDriver({
    required this.id,
    required this.image,
    required this.mapImage,
    required this.name,
    required this.serviceCategory,
    required this.vehicleType,
    required this.description,
    required this.minKmDistance,
    required this.minKmPrice,
    required this.afterKmPrice,
    required this.extraCharge,
    required this.passengerCapacity,
    required this.availableDrivers,
    required this.numberOfPassengers,
    required this.dropPrice,
    required this.dropKm,
    required this.dropTime,
    required this.pricing,
  });

  factory CalDriver.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return CalDriver.empty();
    }

    return CalDriver(
      id: _toInt(json['id']),
      image: json['image']?.toString() ?? "",
      mapImage: json['map_img']?.toString() ?? "",
      name: json['name']?.toString() ?? "",
      serviceCategory: json['service_category']?.toString() ?? "",
      vehicleType: json['vehicle_type']?.toString() ?? "",
      description: json['description']?.toString() ?? "",
      minKmDistance: _toDouble(json['min_km_distance']),
      minKmPrice: _toDouble(json['min_km_price']),
      afterKmPrice: _toDouble(json['after_km_price']),
      extraCharge: _toDouble(json['extra_charge']),
      passengerCapacity: _toInt(json['passenger_capacity']),
      availableDrivers: _toInt(json['available_drivers']),
      numberOfPassengers: _toInt(json['number_of_passengers']),
      dropPrice: _toDouble(json['drop_price']),
      dropKm: _toDouble(json['drop_km']),
      dropTime: _toInt(json['drop_time']),
      pricing: PricingBreakdown.fromJson(json['pricing_breakdown']),
    );
  }

  factory CalDriver.empty() => CalDriver(
        id: 0,
        image: "",
        mapImage: "",
        name: "",
        serviceCategory: "",
        vehicleType: "",
        description: "",
        minKmDistance: 0,
        minKmPrice: 0,
        afterKmPrice: 0,
        extraCharge: 0,
        passengerCapacity: 0,
        availableDrivers: 0,
        numberOfPassengers: 0,
        dropPrice: 0,
        dropKm: 0,
        dropTime: 0,
        pricing: PricingBreakdown.empty(),
      );
}

class PricingBreakdown {
  final double baseFarePerUnit;
  final double finalFare;
  final String pricingModel;

  PricingBreakdown({
    required this.baseFarePerUnit,
    required this.finalFare,
    required this.pricingModel,
  });

  factory PricingBreakdown.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PricingBreakdown.empty();

    return PricingBreakdown(
      baseFarePerUnit: _toDouble(json['base_fare_per_unit']),
      finalFare: _toDouble(json['final_fare']),
      pricingModel: json['pricing_model']?.toString() ?? "",
    );
  }

  factory PricingBreakdown.empty() => PricingBreakdown(
        baseFarePerUnit: 0,
        finalFare: 0,
        pricingModel: "",
      );
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

double _toDouble(dynamic value) {
  if (value == null || value == "") return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
}
