import 'package:yuva_ride/models/driver_profile_model.dart';
import 'package:yuva_ride/models/home/active_ride_model.dart';
import 'package:yuva_ride/models/home/available_driver_model.dart';
import 'package:yuva_ride/models/home/calculator_price_model.dart';
import 'package:yuva_ride/models/home/cancel_ride_reason_model.dart';
import 'package:yuva_ride/models/home/contact_model.dart';
import 'package:yuva_ride/models/home/home_model.dart';
import 'package:yuva_ride/models/home/payment_coupon_model.dart';
import 'package:yuva_ride/models/location_item_model.dart';
import 'package:yuva_ride/models/ride_detail_model.dart';
import 'package:yuva_ride/models/ride_list_response.dart';
import 'package:yuva_ride/services/api_services.dart';
import 'package:yuva_ride/services/local_storage.dart';
import 'package:yuva_ride/services/status.dart';
import 'package:yuva_ride/utils/app_urls.dart';
import 'package:yuva_ride/utils/globle_func.dart';

class RideRepository {
  final ApiService _api = ApiService();

  Future<ApiResponse> createRide({
    required String uid,
    required List driverIds,
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
    int? couponId,
    String bidAutoStatus = "0",
    String droplist = "",
    String? bookFor,
    String? otherName,
    String? otherPhone,
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
      if (couponId != null) "coupon_id": couponId,
      "bidd_auto_status": bidAutoStatus,
      "pickup": pickup,
      "drop": drop,
      "droplist": droplist,
      "pickupadd": pickupAdd,
      "dropadd": dropAdd,
      "droplistadd": droplistAdd,
      "tip": tip,
      "service_category": serviceCategory,
      "book_for": bookFor ?? 'my_self',
      if (otherName != null) "other_name": otherName,
      if (otherPhone != null) "other_phone": otherPhone
    };
    print(body);
    // return ApiResponse.error('');

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
    int? couponId,
    String? couponCode,
  }) async {
    final body = {
      "uid": uid,
      // "mid": mid,
      // "mrole": mrole,
      "service_category": serviceCategory,
      "pickup_lat_lon": pickupLatLon,
      "drop_lat_lon": dropLatLon,
      "drop_lat_lon_list": dropLatLonList,
      if (couponId != null && couponCode == null) "coupon_id": couponId,
      if (couponCode != null) "coupon_code": couponCode,
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
    final ApiResponse response = await _api.get(AppUrl.couponPayment);
    if (isStatusSuccess(response.status)) {
      return ApiResponse.success(PaymentCouponModel.fromJson(response.data));
    } else {
      return ApiResponse.error(response.message);
    }
  }

  Future<ApiResponse<List<SavedContactModel>>> getContacts(
      {required String uid}) async {
    final response = await _api.post(AppUrl.getSavedContacts, {"uid": uid});

    if (isStatusSuccess(response.status)) {
      final list = (response.data['contacts'] as List? ?? [])
          .map((e) => SavedContactModel.fromJson(e))
          .toList();
      print('+++++++++++++++');
      print(list.length);
      return ApiResponse.success(list);
    }
    return ApiResponse.error(response.message);
  }

  /// 🔹 ADD CONTACT
  Future<ApiResponse> addContact({
    required String uid,
    required String name,
    required String phone,
    required String countryCode,
  }) async {
    final body = {
      "uid": uid,
      "name": name,
      "phone": phone,
      "country_code": countryCode,
    };

    return await _api.post(AppUrl.addSavedContact, body);
  }

  /// 🔹 DELETE CONTACT
  Future<ApiResponse> deleteContact({
    required String uid,
    required String contactId,
  }) async {
    return await _api.post(
      AppUrl.deleteSavedContact,
      {"uid": uid, "contact_id": contactId},
    );
  }

  /// 🔹 Driver Profile
  Future<ApiResponse<DriverProfileModel>> getDriverProfile({
    required String driverId,
  }) async {
    final response = await _api.post(
      AppUrl.driverProfileDetail,
      {"d_id": driverId},
    );
    if (isStatusSuccess(response.status)) {
      return ApiResponse.success(DriverProfileModel.fromJson(response.data));
    } else {
      return ApiResponse.error(response.message);
    }
  }

  /// 🔹 Cancel Ride
  Future<ApiResponse> cancelRide({
    required String userId,
    required String cancelId,
    required String requestId,
    required String lat,
    required String lng,
  }) async {
    return await _api.post(
      AppUrl.cancelRide,
      {
        "uid": userId,
        "request_id": requestId,
        "cancel_id": cancelId,
        "lat": lat,
        "lon": lng
      },
    );
  }

  Future<ApiResponse<CancelRideReasonModel>> cancelRideReason() async {
    final response = await _api.get(AppUrl.cancelRideReason);
    if (isStatusSuccess(response.status)) {
      return ApiResponse.success(CancelRideReasonModel.fromJson(response.data));
    } else {
      return ApiResponse.error(response.message);
    }
  }

  /// 🔹 Remove Ride Request
  Future<ApiResponse> removeRideRequest({required String requestId}) async {
    return await _api.post(
      AppUrl.removeRideRequest,
      {"uid": await LocalStorage.getUserId() ?? '', "request_id": requestId},
    );
  }

  /// 🔹 Get ride Ride
  Future<ApiResponse<RideDetailModel>> getRideDetail({
    required String requestId,
  }) async {
    final response = await _api.post(AppUrl.rideDetail,
        {"uid": await LocalStorage.getUserId(), "request_id": requestId},
        isToast: false);
    if (isStatusSuccess(response.status)) {
      return ApiResponse.success(RideDetailModel.fromJson(response.data));
    } else {
      return ApiResponse.error(response.message);
    }
  }

  Future<ApiResponse<ActiveRideModel>> getUserActiveRide() async {
    final uid = await LocalStorage.getUserId();

    final response = await _api.post(
      AppUrl.customerRunningRide,
      {
        "uid": uid,
        "role": "customer",
      },
      isToast: false,
    );

    if (isStatusSuccess(response.status)) {
      return ApiResponse.success(ActiveRideModel.fromJson(response.data));
    } else {
      return ApiResponse.error(response.message);
    }
  }

  ///  CREATE RAZORPAY ORDER
  Future<ApiResponse> createRazorpayOrder({
    required String uid,
    required String orderId,
  }) async {
    final body = {
      "uid": uid,
      "order_id": orderId,
    };

    return await _api.post(AppUrl.createRazorpayOrder, body,
        isSuccessToast: false);
  }

  ///  COMPLETE ONLINE PAYMENT
  Future<ApiResponse> completeOnlinePayment({
    required String uid,
    required String orderId,
    required String paymentMethod,
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
    required String paymentStatus,
  }) async {
    final body = {
      "uid": uid,
      "order_id": orderId,
      "payment_method": paymentMethod,
      "razorpay_payment_id": razorpayPaymentId,
      "razorpay_order_id": razorpayOrderId,
      "razorpay_signature": razorpaySignature,
      "payment_status": paymentStatus,
    };

    return await _api.post(
      AppUrl.completeOnlinePayment,
      body,
    );
  }

  Future<ApiResponse<RideListResponse>> getRideList({
    required String status,
  }) async {
    final uid = await LocalStorage.getUserId();

    final response = await _api.post(
      AppUrl.allServiceRequest,
      {
        "uid": uid,
        "status": status, // upcoming | completed | cancelled
        "service_category": "all"
      },
    );

    if (isStatusSuccess(response.status)) {
      return ApiResponse.success(
        RideListResponse.fromJson(response.data),
      );
    } else {
      return ApiResponse.error(response.message);
    }
  }

  Future<ApiResponse<List<LocationItem>>> fetchLocations() async {
    try {
      await Future.delayed(const Duration(seconds: 3)); // ⏳ simulate API

      final list = [
        LocationItem(
          latitude: 17.4483,
          longitude: 78.3915,
          title: "Madhapur",
          subtitle: "9-120, Madhapur metro station, Hyderabad, Telangana",
        ),
        LocationItem(
          latitude: 17.4375,
          longitude: 78.4482,
          title: "Hitech City",
          subtitle: "Hitech City Rd, Hyderabad, Telangana",
        ),
        LocationItem(
          latitude: 17.4300,
          longitude: 78.4019,
          title: "Gachibowli",
          subtitle: "Gachibowli IT Park, Hyderabad, Telangana",
        ),
        LocationItem(
          latitude: 17.4065,
          longitude: 78.4772,
          title: "Ameerpet",
          subtitle: "Ameerpet Metro Station, Hyderabad",
        ),
      ];

      return ApiResponse.success(list);
    } catch (e) {
      return ApiResponse.error("Failed to load locations");
    }
  }
}
