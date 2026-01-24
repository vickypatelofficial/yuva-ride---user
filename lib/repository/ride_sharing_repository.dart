import 'package:yuva_ride/models/home/driver_signup_detail_model.dart';
import 'package:yuva_ride/services/api_services.dart';
import 'package:yuva_ride/services/status.dart';
import 'package:yuva_ride/utils/app_urls.dart';

class RideSharingRepository {
  final ApiService _apiService = ApiService();

  Future<ApiResponse> searchTrips(Map<String, dynamic> params) async {
    return await _apiService.post(AppUrl.searchTrips, params);
  }

  Future<ApiResponse> bookSeat({
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
    final url = isForOthers ? AppUrl.bookSeatForOthers : AppUrl.bookSeat;
    final params = {
      "uid": uid,
      "trip_id": tripId,
      "seats": seats,
      "pickup_add": pickupAdd,
      "drop_add": dropAdd,
      "pickup_lat": pickupLat,
      "pickup_lng": pickupLng,
      "drop_lat": dropLat,
      "drop_lng": dropLng,
      "price": price,
      "payment_id": paymentId,
      "ride_type": isForOthers ? "other" : "self",
      if (isForOthers) ...{
        "other_rider_name": otherRiderName,
        "other_rider_phone": otherRiderPhone,
      },
    };
    return await _apiService.post(url, params);
  }


    Future<ApiResponse<DriverSignupDetailModel>> getSignupDetail() async {
    final response = await _apiService.get(
      AppUrl.signupDtailPrerequities,
      isSuccessToast: false,
    );

    if (isStatusSuccess(response.status)) {
      return ApiResponse.success(
        DriverSignupDetailModel.fromJson(response.data),
      );
    } else {
      return ApiResponse.error(response.message);
    }
  }
}
