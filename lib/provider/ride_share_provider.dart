import 'package:flutter/material.dart';
import 'package:yuva_ride/models/home/driver_signup_detail_model.dart';
import 'package:yuva_ride/repository/ride_sharing_repository.dart';
import 'package:yuva_ride/provider/book_ride_provider.dart';
import 'package:yuva_ride/services/status.dart';

class RideSharingProvider extends ChangeNotifier {
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

  final RideSharingRepository _repository = RideSharingRepository();
  ApiResponse _searchResponse = ApiResponse.nothing();
  String? _searchDate;

  // New fields to store search params for re-search
  String? _uid;
  String? _pickupLatLon;
  String? _dropLatLon;
  String? _sourceCity;
  String? _destCity;
  String? _seatsNeeded;
  String? _vehicleId;

  ApiResponse get searchResponse => _searchResponse;
  String? get searchDate => _searchDate;

  Future<void> searchTrips({
    required String uid,
    required String pickupLatLon,
    required String dropLatLon,
    required String sourceCity,
    required String destCity,
    required String date,
    required String seatsNeeded,
    required String vehicleId,
    bool searchWidthDate = true
  }) async {
    _searchResponse = ApiResponse.loading();
    _searchDate = date;
    // Store params for re-search
    _uid = uid;
    _pickupLatLon = pickupLatLon;
    _dropLatLon = dropLatLon;
    _sourceCity = sourceCity;
    _destCity = destCity;
    _seatsNeeded = seatsNeeded;
    _vehicleId = vehicleId;
    _searchDate = date;
    notifyListeners();

    final params = {
      "uid": uid,
      "pickup_lat_lon": pickupLatLon,
      "drop_lat_lon": dropLatLon,
      "source_city": sourceCity,
      "dest_city": destCity,
      "date": date,
      "seats_needed": seatsNeeded,
      "vehicle_id": vehicleId,
    };

    // final params = {
    //   "uid":  uid,
    //   // "pickup_lat_lon": pickupLatLon,
    //   // "drop_lat_lon": dropLatLon,
    //   "pickup_lat_lon": "17.4474,78.3762",
    //   "drop_lat_lon": "17.1412,79.6234",
    //   "source_city": sourceCity,
    //   "dest_city": destCity,
    //   "date": _searchDate,
    //   "seats_needed": seatsNeeded,
    //   "vehicle_id": '', // vehicleId,
    // };

    _searchResponse = await _repository.searchTrips(params);
    notifyListeners();
  }

  Future<void> reSearchWithNewDate(String newDate) async {
    if (_uid == null ||
        _pickupLatLon == null ||
        _dropLatLon == null ||
        _sourceCity == null ||
        _destCity == null ||
        _seatsNeeded == null ||
        _vehicleId == null) {
      return; // Cannot re-search without params
    }
    await searchTrips(
      uid: _uid!,
      pickupLatLon: _pickupLatLon!,
      dropLatLon: _dropLatLon!,
      sourceCity: _sourceCity!,
      destCity: _destCity!,
      date: newDate,
      seatsNeeded: _seatsNeeded!,
      vehicleId: _vehicleId!,
    );
  }

  ApiResponse _bookResponse = ApiResponse.nothing();

  ApiResponse get bookResponse => _bookResponse;

  Future<void> bookSeat({
    required String uid,
    required String tripId,
    required String seats,
    required String pickupAdd,
    required String dropAdd,
    required String pickupLat,
    required String pickupLng,
    required String dropLat,
    required String dropLng,
    required String price,
    required String paymentId,
    required bool isForOthers,
    String? otherRiderName,
    String? otherRiderPhone,
  }) async {
    _bookResponse = ApiResponse.loading();
    notifyListeners();
    _bookResponse = await _repository.bookSeat(
      uid: uid,
      tripId: tripId,
      seats: seats,
      pickupAdd: pickupAdd,
      dropAdd: dropAdd,
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      dropLat: dropLat,
      dropLng: dropLng,
      price: price,
      paymentId: paymentId,
      isForOthers: isForOthers,
      otherRiderName: otherRiderName,
      otherRiderPhone: otherRiderPhone,
    );
    notifyListeners();
  }

    // ================= VEHICLE =================
  ApiResponse<DriverSignupDetailModel> signupDetailState = ApiResponse.nothing();
  Future<void> fetchSignupDetail() async {
    signupDetailState = ApiResponse.loading();
    notifyListeners(); 
    signupDetailState = await _repository.getSignupDetail();
    notifyListeners();
  }
}
