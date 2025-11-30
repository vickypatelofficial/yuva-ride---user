import 'package:flutter/material.dart';
import 'package:yuva_ride/view/custom_widgets/cusotm_back.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageCtrl = TextEditingController();

  List<Map<String, dynamic>> messages = [
    {"msg": "Your trip has started", "isUser": false},
    {"msg": "Your captain arrive in shortly", "isUser": false},
    {"msg": "...", "isUser": false},
    {"msg": "Ohh okay", "isUser": true},
  ];

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return CustomScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        toolbarHeight: 70,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 10),
            const CustomBack(),
            const SizedBox(width: 12),
            Text(
              "Suresh Kumar",
              style: text.titleMedium!.copyWith(
                color: Colors.white,
                fontFamily: AppFonts.medium,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 4),

          /// DATE
          Text(
            "July 28,2025",
            style: text.bodySmall!.copyWith(color: Colors.grey),
          ),

          const SizedBox(height: 10),

          /// CHAT MESSAGES
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final m = messages[index];
                return _chatBubble(text, m["msg"], m["isUser"]);
              },
            ),
          ),

          /// INPUT FIELD
          _chatInput(text),

          const SizedBox(height: 6),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // HEADER BAR
  // -------------------------------------------------------------

  // -------------------------------------------------------------
  // CHAT BUBBLES
  // -------------------------------------------------------------
  Widget _chatBubble(TextTheme text, String msg, bool isUser) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primaryColor : const Color(0xffffe0cd),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          msg,
          style: text.bodyMedium!.copyWith(
            color: Colors.black,
            fontFamily: AppFonts.medium,
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // MESSAGE INPUT FIELD
  // -------------------------------------------------------------
  Widget _chatInput(TextTheme text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: messageCtrl,
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  // enabledBorder: InputBorder.none,
                  hintText: "Say something",
                  border: InputBorder.none,
                  hintStyle: text.bodyMedium,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.send, color: Colors.white),
          )
        ],
      ),
    );
  }
}
