// constants.dart

class AppUrl {
  static const String baseUrl = 'https://yuvaride.techlanditsolutions.com';
  static const String customerBaseUrl =
      '$baseUrl/customer/';
  static const String imageUrl = '';

  //  AUTH APIs
  static const String requestOtp = '${customerBaseUrl}msg91';
  static const String mobileCheck = '${customerBaseUrl}mobile_check';
  static const String verifyOtp = '${customerBaseUrl}otp_verify';
  static const String signup = '${customerBaseUrl}signup';
  static const String login = '${customerBaseUrl}login';

  //  PROFILE
  static String getCustomer(String userId) => '${customerBaseUrl}get_customer/$userId';

  // HOME
  static String home = '${customerBaseUrl}home';

  static const String calculate = '${customerBaseUrl}module_calculate';

  ///Ride
  static const String addVehicleRequest = '${customerBaseUrl}add_vehicle_request';

  static const String availableDriver = '${customerBaseUrl}vehicle_calculate';

  static const String couponPayment = '${customerBaseUrl}coupon_payment';

  static const String getSavedContacts = '${customerBaseUrl}get_saved_contacts';
  static const String addSavedContact = '${customerBaseUrl}add_saved_contact';
  static const String deleteSavedContact = '${customerBaseUrl}delete_saved_contact';
  static const String driverProfileDetail = '${customerBaseUrl}driver_profile_detail';
  static const String cancelRide = '${customerBaseUrl}vehicle_ride_cancel';

  static const String rideDetail = '$baseUrl/driver/cus_ride_detail';
    static const String chatList =
      '$baseUrl/chat/chat_list';

  static const String socketUrl = 'https://yuvaride.techlanditsolutions.com';

// static const String url = '${baseUrl}url';
// static const String url = '${baseUrl}url';
// static const String url = '${baseUrl}url';
// static const String url = '${baseUrl}url';
// static const String url = '${baseUrl}url';
// static const String url = '${baseUrl}url';
// static const String url = '${baseUrl}url';
// static const String url = '${baseUrl}url';
}
