import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BookRideProvider extends ChangeNotifier {
  LocationModel? _pickupLocation;
  LocationModel? _dropLocation;

  LocationModel? get pickupLocation => _pickupLocation;
  LocationModel? get dropLocation => _dropLocation;

  void setPickupLocation(LocationModel location) {
    _pickupLocation = location;
    notifyListeners();
  }

  void setDropLocation(LocationModel location) {
    _dropLocation = location;
    notifyListeners();
  }
}

class LocationModel {
  LocationModel(this.latLng, this.address);
  final LatLng latLng;
  final String address;
}
