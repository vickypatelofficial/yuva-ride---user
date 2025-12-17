class PlaceSuggestion {
  final String placeId;
  final String description;

  PlaceSuggestion({
    required this.placeId,
    required this.description,
  });

  factory PlaceSuggestion.fromJson(Map<String, dynamic> json) {
    return PlaceSuggestion(
      placeId: json['place_id'],
      description: json['description'],
    );
  }
}
