// constants.dart

class AppUrl {
  static const String baseUrl = 'https://yuvaride.techlanditsolutions.com/customer/';
  static const String imageUrl = '';

  //  AUTH APIs
  static const String requestOtp   = '${baseUrl}msg91';
  static const String mobileCheck   = '${baseUrl}mobile_check';
  static const String verifyOtp    = '${baseUrl}otp_verify';
  static const String signup       = '${baseUrl}signup';
  static const String login        = '${baseUrl}login';

  //  PROFILE
  static String getCustomer(String userId) =>
      '${baseUrl}get_customer/$userId';

  // HOME
  static String home = '${baseUrl}home';

  static const String calculate = '${baseUrl}calculate';

  
// static const String url = '${baseUrl}url';
// static const String url = '${baseUrl}url';
// static const String url = '${baseUrl}url';
// static const String url = '${baseUrl}url';
// static const String url = '${baseUrl}url';
// static const String url = '${baseUrl}url';
// static const String url = '${baseUrl}url';
// static const String url = '${baseUrl}url';
}
