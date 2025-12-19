class ApiStatus {
  static const nothing = "nothing";
  static const loading = "loading";
  static const success = "success";
  static const error = "error";
}

class ApiResponse<T> {
  final T? data;
  final String? message;
  final String status;

  ApiResponse.nothing() : status = ApiStatus.nothing, data = null, message = null;
  ApiResponse.loading() : status = ApiStatus.loading, data = null, message = null;
  ApiResponse.success(this.data) : status = ApiStatus.success, message = null;
  ApiResponse.error(this.message) : status = ApiStatus.error, data = null;
}

bool isStatusSuccess(String status){
  return ApiStatus.success == status;
}
bool isStatusLoading(String status){
  return ApiStatus.loading == status;
}
bool isStatusError(String status){
  return ApiStatus.error == status;
}

bool isStatusLoadingOrError(String status){
  return (ApiStatus.loading == status)|| (ApiStatus.error == status);
}