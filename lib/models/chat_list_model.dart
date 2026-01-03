// To parse this JSON data, do
//
//     final chatListModel = chatListModelFromJson(jsonString);

import 'dart:convert';

ChatListModel chatListModelFromJson(String str) => ChatListModel.fromJson(json.decode(str));

String chatListModelToJson(ChatListModel data) => json.encode(data.toJson());

class ChatListModel {
  int responseCode;
  bool result;
  String message;
  UserData userData;
  List<ChatList> chatList;

  ChatListModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.userData,
    required this.chatList,
  });

  factory ChatListModel.fromJson(Map<String, dynamic> json) => ChatListModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    userData: UserData.fromJson(json["user_data"]),
    chatList: List<ChatList>.from(json["chat_list"].map((x) => ChatList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "user_data": userData.toJson(),
    "chat_list": List<dynamic>.from(chatList.map((x) => x.toJson())),
  };
}

class ChatList {
  String date;
  List<Chat> chat;

  ChatList({
    required this.date,
    required this.chat,
  });

  factory ChatList.fromJson(Map<String, dynamic> json) => ChatList(
    date: json["date"],
    chat: List<Chat>.from(json["chat"].map((x) => Chat.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "chat": List<dynamic>.from(chat.map((x) => x.toJson())),
  };
}

class Chat {
  int id;
  String date;
  String message;
  int status;

  Chat({
    required this.id,
    required this.date,
    required this.message,
    required this.status,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    id: json["id"],
    date: json["date"],
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date,
    "message": message,
    "status": status,
  };
}

class UserData {
  int id;
  String name;
  String firstName;
  String lastName;
  String profileImage;

  UserData({
    required this.id,
    required this.name,required this.firstName,required this.lastName,required this.profileImage,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json?["id"]??0,
    name: json?["name"]??'',
    lastName: json?["last_name"]??'',
    firstName: json?["first_name"]??'',
    profileImage: json?["profile_image"]??'', 
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "first_name": id,
    "last_name": name,
    "profile_image": id,
  };
}
