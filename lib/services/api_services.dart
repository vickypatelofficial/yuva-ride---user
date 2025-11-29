import 'dart:convert';
import 'package:http/http.dart' as http;
import 'exception_handler.dart';
import 'status.dart';

class ApiService {
  Future<ApiResponse> get(String url) async {
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization':
            'Bearer 66|HFfYefRZRIdBpf2Mugi6h1yxsF088coqRrnll4D98b83faf1',
        'Accept': 'application/json',
      });
      return _handleResponse(response);
    } catch (e) {
      return ApiResponse.error("Failed to load data: ${e.toString()}");
    }
  }

  // Generic POST request
  Future<ApiResponse> post(String url, Map<String, String> body,{Map<String, String>? files}) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll(body);
      request.headers.addAll({
        'Authorization':
            'Bearer 66|HFfYefRZRIdBpf2Mugi6h1yxsF088coqRrnll4D98b83faf1',
        'Accept': 'application/json',
      });
      http.StreamedResponse response = await request.send();
      return _handleResponsePost(response);
    } catch (e) {
      return ApiResponse.error("Failed to post data: ${e.toString()}");
    }
  }

  // Response handler
  ApiResponse _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return ApiResponse.success(json.decode(response.body));
    } else {
      return ApiResponse.error(
          ExceptionHandler.getErrorMessage(response.statusCode));
    }
  }

  Future<ApiResponse> _handleResponsePost(
      http.StreamedResponse response) async {
    var finalResponse = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      return ApiResponse.success(json.decode(finalResponse));
    } else {
      return ApiResponse.error(
          ExceptionHandler.getErrorMessage(response.statusCode));
    }
  }
}
