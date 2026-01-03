import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:yuva_ride/provider/chat_provider.dart';

import 'package:yuva_ride/services/status.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';
import 'package:yuva_ride/utils/app_urls.dart';

class ChatScreenNew extends StatefulWidget {
  final String driverId;
  final String userId;

  const ChatScreenNew({
    super.key,
    required this.driverId,
    required this.userId,
  });

  @override
  State<ChatScreenNew> createState() => _ChatScreenNewState();
}

class _ChatScreenNewState extends State<ChatScreenNew> {
  late ScrollController _controller;
  TextEditingController messageController = TextEditingController();
  late IO.Socket socket;
  late ColorNotifier notifier;

  // ---------------- DARK MODE ----------------
  getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    notifier.setIsDark = prefs.getBool("setIsDark") ?? false;
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    socketConnect();
    getDarkMode();
  }

  // ---------------- SOCKET ----------------
  socketConnect() {
    socket = IO.io(
      AppUrl.socketUrl,
      <String, dynamic>{
        'autoConnect': false,
        'transports': ['websocket'],
      },
    );

    socket.connect();
    _connectSocket();

    context.read<ChatProvider>().getChat(
          recieverId: widget.driverId,
        );
  }

  void _connectSocket() {
    socket.onConnect((_) => debugPrint("User Socket Connected"));
    socket.onDisconnect((_) => debugPrint("User Socket Disconnected"));
    socket.onConnectError((e) => debugPrint("Socket Error: $e"));
    socket.on("New_Chat${widget.userId}", (_) {
      context.read<ChatProvider>().getChat(recieverId: widget.driverId);
    });
  }

  // ---------------- SEND MESSAGE ----------------
  void sendMessage() {
    print('+++++++++++++++++++');
    print(messageController.text.trim().isEmpty);
    print( {
      'sender_id': widget.userId,
      'recevier_id': widget.driverId,
      'status': "customer",
      'message': messageController.text.trim(),
    });
    if (messageController.text.trim().isEmpty) return;
    socket.emit('Send_Chat', {
      'sender_id': widget.userId,
      'recevier_id': widget.driverId,
      'status': "customer",
      'message': messageController.text.trim()
    });
    
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context);

    final chatProvider = context.watch<ChatProvider>();

    return Scaffold(
      backgroundColor: notifier.background,
      appBar: AppBar( 
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon:const Icon(Icons.arrow_back, color: AppColors.white),
            onPressed: () => Navigator.pop(context),
          // onPressed: () {
          //   context.read<ChatProvider>().getChat(recieverId: widget.driverId);
          // },
        ),
        title: !isStatusLoading(chatProvider.chatListState.status)
            ? Text(
                chatProvider.chatListState.data?.userData.firstName ?? '',
                style:const TextStyle(color:  AppColors.white),
              )
            : const SizedBox(),
      ),
      // ---------------- CHAT BODY ----------------
      body: Consumer<ChatProvider>(builder: (context, chatProvider, _) {
        return !isStatusLoading(chatProvider.chatListState.status)
            ? chatProvider.chatListState.data?.chatList.isNotEmpty == true
                ? Scrollbar(
                    controller: _controller,
                    child: SingleChildScrollView(
                      reverse: true,
                      controller: _controller,
                      child: Column(
                        children: chatProvider.chatListState.data!.chatList
                            .map((day){
                          return Column(
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                day.date,
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontSize: 14,
                                ),
                              ),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(10),
                                itemCount: day.chat.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 6),
                                itemBuilder: (_, index) {
                                  final chat = day.chat[index];
                                  final isMe = chat.status == 1;

                                  return Align(
                                    alignment: isMe
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: isMe
                                            ? AppColors.primaryColor
                                            : notifier.containerColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: isMe
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            chat.message,
                                            style: TextStyle(
                                              color: isMe
                                                  ? Colors.white
                                                  : notifier.textColor,
                                              fontFamily: AppFonts.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            chat.date,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: isMe
                                                  ? Colors.white70
                                                  : notifier.textColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  )
                : const Center(child: Text("No Chat Found"))
            : const Center(child: CircularProgressIndicator());
      }),

      // ---------------- INPUT ----------------
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: messageController, 
            decoration: InputDecoration(
              contentPadding:const EdgeInsets.only(top: 10),
              filled: true,
              fillColor: notifier.containerColor,
              hintText: "Say Something...",
              suffixIcon: IconButton(
                icon: Icon(Icons.send, color: notifier.textColor),
                onPressed: (){
                  sendMessage();
                  chatProvider.getChat(recieverId: widget.driverId);
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ColorNotifier with ChangeNotifier {
  bool _isDark = false;
  set setIsDark(value) {
    _isDark = value;
    notifyListeners();
  }

  get background => _isDark ? const Color(0xff202427) : Colors.grey.shade100;
  get textColor => _isDark ? AppColors.white : AppColors.black;
  get containerColor => _isDark ? AppColors.black : AppColors.white;
  get borderColor =>
      _isDark ? const Color(0xff24211F) : const Color(0xffe1e6ef);
}
