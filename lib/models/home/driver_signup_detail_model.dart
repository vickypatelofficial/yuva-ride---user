class DriverSignupDetailModel {
  final List<ZoneModel> zones;
  final List<SignupVehicleModel> vehicles;
  final List<PreferenceModel> preferences;
  final List<DocumentModel> documents;

  DriverSignupDetailModel({
    required this.zones,
    required this.vehicles,
    required this.preferences,
    required this.documents,
  });

  factory DriverSignupDetailModel.fromJson(Map<String, dynamic> json) {
    return DriverSignupDetailModel(
      zones: (json['zone_data'] as List? ?? [])
          .map((e) => ZoneModel.fromJson(e))
          .toList(),
      vehicles: (json['vehicle_list'] as List? ?? [])
          .map((e) => SignupVehicleModel.fromJson(e))
          .toList(),
      preferences: (json['preference_list'] as List? ?? [])
          .map((e) => PreferenceModel.fromJson(e))
          .toList(),
      documents: (json['document_list'] as List? ?? [])
          .map((e) => DocumentModel.fromJson(e))
          .toList(),
    );
  }
}


class ZoneModel {
  final int id;
  final String name;
  final String status;

  ZoneModel({
    required this.id,
    required this.name,
    required this.status,
  });

  factory ZoneModel.fromJson(Map<String, dynamic> json) {
    return ZoneModel(
      id: json['id'],
      name: json['name'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
class SignupVehicleModel {
  final int id;
  final String name;
  final String image;
  final String description;
  final String serviceCategory;
  final String passengerCapacity;
  final String? maxWeightKg;

  SignupVehicleModel({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.serviceCategory,
    required this.passengerCapacity,
    this.maxWeightKg,
  });

  factory SignupVehicleModel.fromJson(Map<String, dynamic> json) {
    return SignupVehicleModel(
      id: json['id'],
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      serviceCategory: json['service_category'] ?? '',
      passengerCapacity: json['passenger_capacity'] ?? '',
      maxWeightKg: json['max_weight_kg'],
    );
  }
}
class PreferenceModel {
  final int id;
  final String name;
  final String image;
  final String serviceCategory;

  PreferenceModel({
    required this.id,
    required this.name,
    required this.image,
    required this.serviceCategory,
  });

  factory PreferenceModel.fromJson(Map<String, dynamic> json) {
    return PreferenceModel(
      id: json['id'],
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      serviceCategory: json['service_category'] ?? '',
    );
  }
}
class DocumentModel {
  final int id;
  final String name;
  final String requireImageSide;
  final String inputRequire;
  final String reqFieldName;

  DocumentModel({
    required this.id,
    required this.name,
    required this.requireImageSide,
    required this.inputRequire,
    required this.reqFieldName,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'],
      name: json['name'] ?? '',
      requireImageSide: json['require_image_side'] ?? '',
      inputRequire: json['input_require'] ?? '',
      reqFieldName: json['req_field_name'] ?? '',
    );
  }
}
