class LocationItem {
  final double latitude;
  final double longitude;
  final String title;
  final String subtitle;

  LocationItem({
    required this.latitude,
    required this.longitude,
    required this.title,
    required this.subtitle,
  });

  factory LocationItem.fromJson(Map<String, dynamic> json) {
    return LocationItem(
      latitude: (json['lat'] ?? 0).toDouble(),
      longitude: (json['lng'] ?? 0).toDouble(),
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
    );
  }
}
