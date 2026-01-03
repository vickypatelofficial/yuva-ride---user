
import 'package:yuva_ride/models/chat_list_model.dart';
import 'package:yuva_ride/services/api_services.dart';
import 'package:yuva_ride/services/status.dart';
import 'package:yuva_ride/utils/app_urls.dart';

class ChatRepository {
  final ApiService _apiService = ApiService();
  Future<ApiResponse<ChatListModel>> chatList({
    required String userId,
    required String recieverId,
  }) async {
    final response = await _apiService.post(
      AppUrl.chatList,
      {
        "uid": userId,
        "sender_id": userId,
        "recevier_id": recieverId,
        "status": "customer" // customer, driver
      },isToast: false
    );
    if (isStatusSuccess(response.status)) {
      return ApiResponse.success(ChatListModel.fromJson(response.data));
    } else {
      return ApiResponse.error(response.message);
    }
  }
}
