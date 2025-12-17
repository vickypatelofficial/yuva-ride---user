import 'package:flutter/material.dart';
import 'package:yuva_ride/models/profile_model.dart';
import 'package:yuva_ride/repository/auth_repository.dart';
import 'package:yuva_ride/services/local_storage.dart';
import 'package:yuva_ride/services/status.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repo = AuthRepository();

  ApiResponse requestOtpState = ApiResponse.nothing();
  ApiResponse mobileCheckState = ApiResponse.nothing();
  ApiResponse verifyOtpState = ApiResponse.nothing();
  ApiResponse signupState = ApiResponse.nothing();
  ApiResponse loginState = ApiResponse.nothing();
  ApiResponse<ProfileModel> profileState = ApiResponse.nothing();

  /// OTP
  Future<void> requestOtp({
    required String phone,
    required String ccode,
  }) async {
    requestOtpState = ApiResponse.loading();
    notifyListeners();
    requestOtpState = await _repo.requestOtp(phone: phone, ccode: ccode);
    notifyListeners();
  }

  Future<void> mobileCheck(
      {required String phone, required String ccode}) async {
    mobileCheckState = ApiResponse.loading();
    notifyListeners();
    mobileCheckState = await _repo.mobileChecck(phone: phone, ccode: ccode);
    notifyListeners();
  }

  /// VERIFY OTP
  Future<void> verifyOtp({
    String? userId,
    required String phone,
    required String ccode,
    required String otp,
  }) async {
    verifyOtpState = ApiResponse.loading();
    notifyListeners();
    verifyOtpState = await _repo.verifyOtp(
      userId: userId ?? "",
      phone: phone,
      ccode: ccode,
      otp: otp,
    );
    if (isStatusSuccess(verifyOtpState.status)) {
      LocalStorage.saveToken(verifyOtpState.data['data']?['token'] ?? '');
    }
    notifyListeners();
  }

  /// SIGNUP
  Future<void> signup(
      {required String userId,
      required String name,
      required String email,
      required String password,
      required String phone,
      required String ccode}) async {
    signupState = ApiResponse.loading();
    notifyListeners();

    signupState = await _repo.signup(
      userId: userId,
      ccode: ccode,
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
    notifyListeners();
  }

  /// LOGIN
  // Future<void> login({
  //   required String phone,
  //   required String ccode,
  //   required String password,
  // }) async {
  //   loginState = ApiResponse.loading();
  //   notifyListeners();

  //   loginState = await _repo.login(
  //     phone: phone,
  //     ccode: ccode,
  //     password: password,
  //   );
  //   notifyListeners();
  // }

  /// PROFILE
  Future<void> fetchProfile({String? userId}) async {
    if (userId == null) return;

    profileState = ApiResponse.loading();
    notifyListeners();

    profileState = await _repo.getCustomerProfile(userId: userId);
    notifyListeners();
  }
}
