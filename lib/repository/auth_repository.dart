import 'package:yuva_ride/models/profile_model.dart';
import 'package:yuva_ride/services/api_services.dart';
import 'package:yuva_ride/services/status.dart';
import 'package:yuva_ride/utils/app_urls.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  /// 🔹 1. REQUEST OTP
  Future<ApiResponse> requestOtp({
    required String phone,
    required String ccode,
  }) async {
    return await _apiService.post(
      AppUrl.requestOtp,
      {
        "phone": phone,
        "ccode": ccode,
      },
    );
  }

  //  mobile check
  Future<ApiResponse> mobileChecck({
    required String phone,
    required String ccode,
  }) async {
    return await _apiService.post(
      AppUrl.mobileCheck,
      {
        "phone": phone,
        "ccode": ccode,
      },
    );
  }

  /// 🔹 2. VERIFY OTP
  Future<ApiResponse> verifyOtp({
    required String userId,
    required String phone,
    required String ccode,
    required String otp,
  }) async {
    return await _apiService.post(
      AppUrl.verifyOtp,
      {
        "user_id": userId,
        "phone": phone,
        "ccode": ccode,
        "otp": otp,
      },
    );
  }

  /// 🔹 3. SIGNUP
  Future<ApiResponse> signup({
    required String name,
    required String userId,
    required String email,
    required String password,
    required String phone,
    required String ccode,
    String referralCode = "1234",
  }) async {
    return await _apiService.post(
      AppUrl.signup,
      {
        "user_id": userId,
        "phone": phone,
        "ccode": ccode,
        "name": name,
        "email": email,
        "password": password,
        "referral_code": referralCode,
      },
    );
  }

  /// 🔹 4. LOGIN
  Future<ApiResponse> login({
    required String phone,
    required String ccode,
    required String password,
  }) async {
    return await _apiService.post(
      AppUrl.login,
      {
        "ccode": ccode,
        "phone": phone,
        "password": password,
      },
    );
  }

  /// 🔹 5. GET CUSTOMER PROFILE
  Future<ApiResponse<ProfileModel>> getCustomerProfile({
    required String userId,
  }) async {
    return ApiResponse.success(profileModelFromJson(await _apiService.get(
      AppUrl.getCustomer(userId),
    ) as String));
  }
}
