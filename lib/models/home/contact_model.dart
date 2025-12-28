class SavedContactModel {
  final String id;
  final String cId;
  final String name;
  final String phone;
  final String countryCode;

  SavedContactModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.countryCode,
    required this.cId,
  });

  factory SavedContactModel.fromJson(Map<String, dynamic> json) {
    return SavedContactModel(
      id: json['id']?.toString() ?? '',
      cId: json['c_id']?.toString() ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      countryCode: json['country_code'] ?? '',
    );
  }
}
