import 'package:flutter/material.dart';
import 'package:yuva_ride/models/chat_list_model.dart';
import 'package:yuva_ride/repository/chat_repository.dart';
import 'package:yuva_ride/services/local_storage.dart';
import 'package:yuva_ride/services/status.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository _repository = ChatRepository();

  ApiResponse<ChatListModel> chatListState = ApiResponse.nothing();
  getChat({required String recieverId}) async {
    if (chatListState.data?.chatList.isEmpty ?? true) {
      chatListState = ApiResponse.loading();
    }
    notifyListeners();
    chatListState = await _repository.chatList(
        userId: await LocalStorage.getUserId() ?? '', recieverId: recieverId);
    notifyListeners();
  }
}
