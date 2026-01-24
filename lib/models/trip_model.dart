class TripModel {
  final int? tripId;
  final int? driverId;
  final String? date;
  final String? time;
  final String? source;
  final String? destination;
  final double? price;
  final int? seatsAvailable;
  final int? vehicleId;
  final String? vehicleName;
  final String? vehicleImage;
  final String? driverName;
  final String? driverImage;
  final String? rating;
  final List<RouteStop> routeStops;
  final Preferences preferences;

  TripModel({
    this.tripId,
    this.driverId,
    this.date,
    this.time,
    this.source,
    this.destination,
    this.price,
    this.seatsAvailable,
    this.vehicleId,
    this.vehicleName,
    this.vehicleImage,
    this.driverName,
    this.driverImage,
    this.rating,
    required this.routeStops,
    required this.preferences,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    final driverInfo = json['driver_info'] as Map<String, dynamic>? ?? {};
    final vehicleInfo = json['vehicle_info'] as Map<String, dynamic>? ?? {};
    final tripInfo = json['trip_info'] as Map<String, dynamic>? ?? {};
    final pricing = json['pricing'] as Map<String, dynamic>? ?? {};
    final sourceObj = tripInfo['source'] as Map<String, dynamic>? ?? {};
    final destinationObj = tripInfo['destination'] as Map<String, dynamic>? ?? {};

    return TripModel(
      tripId: json['trip_id'] as int? ?? 0,
      driverId: json['driver_id'] as int? ?? 0,
      date: tripInfo['date'] as String? ?? '',
      time: tripInfo['time'] as String? ?? '',
      source: sourceObj['address'] as String? ?? '',
      destination: destinationObj['address'] as String? ?? '',
      price: (pricing['price_per_seat'] as num?)?.toDouble() ?? 0.0,
      seatsAvailable: pricing['seats_available'] as int? ?? 0,
      vehicleId: vehicleInfo['id'] as int? ?? 0,
      vehicleName: vehicleInfo['name'] as String? ?? '',
      vehicleImage: vehicleInfo['image'] as String? ?? '',
      driverName: driverInfo['name'] as String? ?? '',
      driverImage: driverInfo['image'] as String? ?? '',
      rating: driverInfo['rating']?.toString() ?? '0',
      routeStops: (tripInfo['route_stops'] as List<dynamic>?)
          ?.map((e) => RouteStop.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      preferences: Preferences.fromJson(tripInfo['preferences'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class RouteStop {
  final String? title;
  final String? address;
  final String? lat;
  final String? lng;

  RouteStop({
    this.title,
    this.address,
    this.lat,
    this.lng,
  });

  factory RouteStop.fromJson(Map<String, dynamic> json) {
    return RouteStop(
      title: json['title'] as String? ?? '',
      address: json['address'] as String? ?? '',
      lat: json['lat'] as String? ?? '',
      lng: json['lng'] as String? ?? '',
    );
  }
}

class Preferences {
  final bool? max2BackSeat;
  final bool? neverCancel;
  final bool? petsAllowed;
  final bool? smokingAllowed;
  final bool? musicAllowed;

  Preferences({
    this.max2BackSeat,
    this.neverCancel,
    this.petsAllowed,
    this.smokingAllowed,
    this.musicAllowed,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      max2BackSeat: json['max_2_back_seat'] as bool? ?? false,
      neverCancel: json['never_cancel'] as bool? ?? false,
      petsAllowed: json['pets_allowed'] as bool? ?? false,
      smokingAllowed: json['smoking_allowed'] as bool? ?? false,
      musicAllowed: json['music_allowed'] as bool? ?? false,
    );
  }
}
