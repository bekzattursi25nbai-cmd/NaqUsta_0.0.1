import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input_field.dart';

class ChatDetailScreen extends StatefulWidget {
  final ChatModel chat;

  const ChatDetailScreen({super.key, required this.chat});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  // Хабарламалар тізімі
  List<MessageModel> messages = [
    MessageModel(id: 1, text: "Сәлеметсіз бе! Крыша жабу керек еді.", time: "14:30", isMe: true),
    MessageModel(id: 2, text: "Сәлем! Әрине. Квадраты қанша болады?", time: "14:32", isMe: false),
    MessageModel(id: 3, text: "Шамамен 120 квадрат. Материал өзімнен.", time: "14:33", isMe: true),
    MessageModel(id: 4, text: "Жақсы. Бағасы 450 000 теңге болады. Ертең бастай аламыз.", time: "14:35", isMe: false),
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Хабарлама жіберу
  void _handleSend(String text) {
    setState(() {
      messages.add(MessageModel(
        id: DateTime.now().millisecondsSinceEpoch,
        text: text,
        time: "${DateTime.now().hour}:${DateTime.now().minute}",
        isMe: true,
      ));
    });

    // Автоматты түрде төменге түсу
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Тұтас қара
      body: Stack(
        children: [
          // HEADER (Custom AppBar)
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
              decoration: BoxDecoration(
                color: const Color(0xFF121212).withOpacity(0.95),
                border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(CupertinoIcons.arrow_left, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CircleAvatar(backgroundImage: NetworkImage(widget.chat.img)),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.chat.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text(widget.chat.online ? "Online" : "Offline", style: const TextStyle(color: Color(0xFFFFD700), fontSize: 10)),
                    ],
                  ),
                  const Spacer(),
                  IconButton(icon: const Icon(CupertinoIcons.phone, color: Colors.white), onPressed: () {}),
                ],
              ),
            ),
          ),

          // MESSAGES LIST
          Positioned.fill(
            top: 100, bottom: 80, // Орын қалдыру
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return MessageBubble(text: msg.text, time: msg.time, isMe: msg.isMe);
              },
            ),
          ),

          // INPUT FIELD (Төменгі жақ)
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: ChatInputField(onSend: _handleSend),
          ),
        ],
      ),
    );
  }
}