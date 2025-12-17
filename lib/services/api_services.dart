import 'dart:io';
import 'package:dio/dio.dart';
import 'package:yuva_ride/services/local_storage.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/globle_func.dart';
import 'status.dart';

class ApiService {
  late Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
    // _dio.interceptors.add(
    //   InterceptorsWrapper(
    //     onRequest: (options, handler) async {
    //       final token = await LocalStorage.getToken();
    //       if (token != null && token.isNotEmpty) {
    //         options.headers['Authorization'] = 'Bearer $token';
    //       }

    //       handler.next(options);
    //     },
    //   ),
    // );
  }

  /// 🔹 GET REQUEST
  Future<ApiResponse> get(
    String url, {
    bool isToast = true,
    bool isSuccessToast = true,
    bool isErrorToast = true,
  }) async {
    try {
      print('========url=========');
      print(url);
      String endPoint =
          'https://yuvaride.techlanditsolutions.com/customer/home';
      final response = await _dio.get(endPoint);
      print('===========++++++++=========');
      print(response.data.toString());
      if (isToast) {
        if (isSuccessToast) {
          showToastSuccess(response.data);
        }
      }
      return ApiResponse.success(response.data);
    } on DioException catch (e) {
      print('==========dio error=============');
      print(e.toString());
      if (isToast) {
        if (isErrorToast) {
          showToastError(_handleDioError(e));
        }
      }
      return ApiResponse.error(_handleDioError(e));
    } catch (e) {
      print('==========catche error=============');
      print(e.toString());
      if (isToast) {
        if (isErrorToast) {
          showToastError('Something went wrong');
        }
      }
      return ApiResponse.error("Something went wrong");
    }
  }

  /// 🔹 POST REQUEST
  Future<ApiResponse> post(
    String url,
    Map<String, dynamic> body, {
    Map<String, File>? files,
    bool isToast = true,
    bool isSuccessToast = true,
    bool isErrorToast = true,
  }) async {
    try {
      // FormData formData =
      //     FormData.fromMap({"phone": "7995976215", "ccode": "+91"});

      // 🔹 Attach files if present
      // if (files != null) {
      //   for (var entry in files.entries) {
      //     formData.files.add(
      //       MapEntry(
      //         entry.key,
      //         await MultipartFile.fromFile(entry.value.path),
      //       ),
      //     );
      //   }
      // }
      print('========url=========');
      print(url);
      print('======body========');
      print(body);

      final response = await _dio.post(url, data: body);
      print('===============++++ after response++++++++');
      print(response.data.toString());

      if (isToast) {
        showToastOnResponse(response.data);
      }

      if (isSuccess(response.data)) {
        return ApiResponse.success(response.data);
      } else {
        return ApiResponse.error(messageFromResponse(response.data));
      }
      //  return ApiResponse.success(response.data);
    } on DioException catch (e) {
      print('DioException error=======');
      print(e.toString());
      if (isToast) {
        if (isErrorToast) {
          showToastError(_handleDioError(e));
        }
      }
      return ApiResponse.error(_handleDioError(e));
    } catch (e, s) {
      print('catch error=======');
      print(e.toString());
      print('stacktrace=======');
      print(s.toString());
      if (isToast) {
        if (isErrorToast) {
          showToastError('Failed');
        }
      }
      return ApiResponse.error("Failed");
    }
  }

  /// 🔹 DIO ERROR HANDLER
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timeout";
      case DioExceptionType.receiveTimeout:
        return "Server took too long to respond";
      case DioExceptionType.sendTimeout:
        return "Request timeout";
      case DioExceptionType.badResponse:
        return "Bad response from server";
      case DioExceptionType.unknown:
        return "Unknown error occurred";
      case DioExceptionType.badCertificate:
        return "Certificate verification failed";
      case DioExceptionType.connectionError:
        return "No internet connection";
      default:
        return 'Something went wrong';
    }
  }

  showToastOnResponse(dynamic data) {
    showCustomToast(
      title: data['message']?.toString() ?? '',
      backgroundColor:
          ((data['Result'].runtimeType == bool) ? data['Result'] : false)
              ? AppColors.success
              : AppColors.red,
      textColor: AppColors.white,
    );
  }

  String messageFromResponse(dynamic data) {
    return data['message']?.toString() ?? '';
  }

  bool isSuccess(dynamic data) {
    return ((data['Result'].runtimeType == bool) ? data['Result'] : false);
  }

  showToastSuccess(dynamic data) {
    showCustomToast(title: data['message']?.toString() ?? '');
  }

  showToastError(String error) {
    showCustomToast(
        title: error,
        backgroundColor: AppColors.red,
        textColor: AppColors.white);
  }
}
