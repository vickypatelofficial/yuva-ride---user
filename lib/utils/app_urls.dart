// constants.dart

class AppUrl {
  static const String baseUrl =
      'https://yuvaride.techlanditsolutions.com/customer/';
  static const String imageUrl = '';

  //  AUTH APIs
  static const String requestOtp = '${baseUrl}msg91';
  static const String mobileCheck = '${baseUrl}mobile_check';
  static const String verifyOtp = '${baseUrl}otp_verify';
  static const String signup = '${baseUrl}signup';
  static const String login = '${baseUrl}login';

  //  PROFILE
  static String getCustomer(String userId) => '${baseUrl}get_customer/$userId';

  // HOME
  static String home = '${baseUrl}home';

  static const String calculate = '${baseUrl}module_calculate';

  ///Ride
  static const String addVehicleRequest = '${baseUrl}add_vehicle_request';

  static const String availableDriver = '${baseUrl}vehicle_calculate';

  static const String couponPayment = '${baseUrl}coupon_payment';

  static const String getSavedContacts = '${baseUrl}get_saved_contacts';
  static const String addSavedContact = '${baseUrl}add_saved_contact';
  static const String deleteSavedContact = '${baseUrl}delete_saved_contact';
  static const String driverProfileDetail = '${baseUrl}driver_profile_detail';
  static const String cancelRide = '${baseUrl}vehicle_ride_cancel'; 
  
  static const String socketUrl =
      'https://yuvaride.techlanditsolutions.com';

// static const String url = '${baseUrl}url';
// static const String url = '${baseUrl}url';
// static const String url = '${baseUrl}url';
// static const String url = '${baseUrl}url';
// static const String url = '${baseUrl}url';
// static const String url = '${baseUrl}url';
// static const String url = '${baseUrl}url';
// static const String url = '${baseUrl}url';
}
