import 'package:yuva_ride/models/home_model.dart';
import 'package:yuva_ride/services/api_services.dart';
import 'package:yuva_ride/services/status.dart';
import 'package:yuva_ride/utils/app_urls.dart';

class HomeRepository {
  final ApiService _apiService = ApiService();

  Future<ApiResponse<HomeModel>> getHome(
      {required String userId,
      required String lat,
      required String long}) async {
    final ApiResponse response = await _apiService
        .post(AppUrl.home, {"uid": userId, "lat": lat, "lon": long});
    if (isStatusSuccess(response.status)) {
      return ApiResponse.success(HomeModel.fromJson(response.data));
    } else {
      return ApiResponse.error(response.message);
    }
  }

  Future<ApiResponse> calculateRide({
    required String uid,
    required String mid,
    required String mrole,
    required String pickupLatLon,
    required String dropLatLon,
    required List dropLatLonList,
  }) async {
    final body = {
      "uid": uid,
      "mid": mid,
      "mrole": mrole,
      "pickup_lat_lon": pickupLatLon,
      "drop_lat_lon": dropLatLon,
      "drop_lat_lon_list": dropLatLonList,
    };

    final response = await _apiService.post(AppUrl.calculate, body);

    if (isStatusSuccess(response.status)) {
      return ApiResponse.success(response.data);
    } else {
      return ApiResponse.error(response.message);
    }
  }
}
