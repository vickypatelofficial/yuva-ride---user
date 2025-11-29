class ApiStatus {
  static const loading = "loading";
  static const success = "success";
  static const error = "error";
}

class ApiResponse<T> {
  final T? data;
  final String? message;
  final String status;

  ApiResponse.loading() : status = ApiStatus.loading, data = null, message = null;
  ApiResponse.success(this.data) : status = ApiStatus.success, message = null;
  ApiResponse.error(this.message) : status = ApiStatus.error, data = null;
}
