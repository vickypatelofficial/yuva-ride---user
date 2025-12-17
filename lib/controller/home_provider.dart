import 'package:flutter/material.dart';
import 'package:yuva_ride/models/home_model.dart';
import 'package:yuva_ride/repository/home_repository.dart';
import 'package:yuva_ride/services/local_storage.dart';
import 'package:yuva_ride/services/status.dart';

class HomeProvider extends ChangeNotifier {
  final HomeRepository _repo = HomeRepository();

  ApiResponse<HomeModel> homeState = ApiResponse.nothing();

  Future<void> fetchHOme({required String lat, required String long}) async {
    homeState = ApiResponse.loading();
    notifyListeners();

    homeState = await _repo.getHome(
        userId: await LocalStorage.getUserId() ?? '', lat: lat, long: long);
    notifyListeners();
  }

  ApiResponse calculateState = ApiResponse.nothing();

  Future<void> calculate({
    required String uid,
    required String mid,
    required String mrole,
    required String pickupLatLon,
    required String dropLatLon,
    required List dropLatLonList,
  }) async {
    calculateState = ApiResponse.loading();
    notifyListeners();

    calculateState = await _repo.calculateRide(
      uid: uid,
      mid: mid,
      mrole: mrole,
      pickupLatLon: pickupLatLon,
      dropLatLon: dropLatLon,
      dropLatLonList: dropLatLonList,
    );

    notifyListeners();
  }
}
