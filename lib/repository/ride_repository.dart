import 'package:yuva_ride/models/home/available_driver_model.dart';
import 'package:yuva_ride/models/home/calculator_price_model.dart';
import 'package:yuva_ride/models/home/home_model.dart';
import 'package:yuva_ride/models/home/payment_coupon_model.dart';
import 'package:yuva_ride/services/api_services.dart';
import 'package:yuva_ride/services/status.dart';
import 'package:yuva_ride/utils/app_urls.dart';

class RideRepository {
  final ApiService _api = ApiService();

  Future<ApiResponse> createRide({
    required String uid,
    required List<int> driverIds,
    required String vehicleId,
    required String price,
    required String totalKm,
    required String totalHour,
    required String totalMinute,
    required String paymentId,
    required String mRole,
    required String pickup,
    required String drop,
    required Map<String, String> pickupAdd,
    required Map<String, String> dropAdd,
    required int tip,
    required String serviceCategory,
    String couponId = "",
    String bidAutoStatus = "0",
    String droplist = "",
    List<Map<String, String>> droplistAdd = const [],
  }) async {
    final body = {
      "uid": uid,
      "driverid": driverIds,
      "vehicle_id": vehicleId,
      "price": price,
      "tot_km": totalKm,
      "tot_hour": totalHour,
      "tot_minute": totalMinute,
      "payment_id": paymentId,
      "m_role": mRole,
      "coupon_id": couponId,
      "bidd_auto_status": bidAutoStatus,
      "pickup": pickup,
      "drop": drop,
      "droplist": droplist,
      "pickupadd": pickupAdd,
      "dropadd": dropAdd,
      "droplistadd": droplistAdd,
      "tip": tip,
      "service_category": serviceCategory,
    };

    final response = await _api.post(AppUrl.addVehicleRequest, body);

    return isStatusSuccess(response.status)
        ? ApiResponse.success(response.data)
        : ApiResponse.error(response.message);
  }

  Future<ApiResponse<CategoryModel>> getCategory(
      {required String userId,
      required String lat,
      required String long}) async {
    final ApiResponse response =
        await _api.post(AppUrl.home, {"uid": userId, "lat": lat, "lon": long});
    if (isStatusSuccess(response.status)) {
      return ApiResponse.success(CategoryModel.fromJson(response.data));
    } else {
      return ApiResponse.error(response.message);
    }
  }

  Future<ApiResponse<CalculatedPriceModel>> calculateRide({
    required String uid,
    required String pickupLatLon,
    required String dropLatLon,
    required List dropLatLonList,
    required String serviceCategory,
  }) async {
    final body = {
      "uid": uid,
      // "mid": mid,
      // "mrole": mrole,
      "service_category": serviceCategory,
      "pickup_lat_lon": pickupLatLon,
      "drop_lat_lon": dropLatLon,
      "drop_lat_lon_list": dropLatLonList,
    };

    final response = await _api.post(AppUrl.calculate, body);

    if (isStatusSuccess(response.status)) {
      return ApiResponse.success(CalculatedPriceModel.fromJson(response.data));
    } else {
      return ApiResponse.error(response.message);
    }
  }

  Future<ApiResponse<AvailableDriverModel>> getAvailableDrivers({
    required String uid,
    required String vehicleId,
    required String serviceCategory,
    required String pickupLatLon,
    required String dropLatLon,
    required List dropLatLonList,
  }) async {
    final body = {
      "uid": uid,
      "mid": vehicleId,
      "service_category": serviceCategory,
      "pickup_lat_lon": pickupLatLon,
      "drop_lat_lon": dropLatLon,
      "drop_lat_lon_list": dropLatLonList,
    };

    final response = await _api.post(AppUrl.availableDriver, body);

    return isStatusSuccess(response.status)
        ? ApiResponse.success(
            AvailableDriverModel.fromJson(response.data),
          )
        : ApiResponse.error(response.message);
  }

    Future<ApiResponse<PaymentCouponModel>> getPaymentCoupon() async {
    final ApiResponse response =
        await _api.get(AppUrl.couponPayment);
    if (isStatusSuccess(response.status)) {
      return ApiResponse.success(PaymentCouponModel.fromJson(response.data));
    } else {
      return ApiResponse.error(response.message);
    }
  }

}
