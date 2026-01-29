import 'package:flutter/material.dart';
import '../../chat/models/chat_model.dart';

class ChatItem extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback onTap;

  const ChatItem({super.key, required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(chat.img),
            backgroundColor: Colors.grey[900],
          ),
          if (chat.online)
            Positioned(
              bottom: 0, right: 0,
              child: Container(
                width: 14, height: 14,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        chat.name,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(
        chat.lastMessage,
        style: TextStyle(color: chat.unread > 0 ? Colors.white : Colors.grey, fontWeight: chat.unread > 0 ? FontWeight.bold : FontWeight.normal),
        maxLines: 1, overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(chat.time, style: const TextStyle(color: Color(0xFFFFD700), fontSize: 12)),
          const SizedBox(height: 6),
          if (chat.unread > 0)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFFFFD700), // Сары (Gold) - Жұмысшы стилі
                shape: BoxShape.circle,
              ),
              child: Text(
                "${chat.unread}",
                style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}