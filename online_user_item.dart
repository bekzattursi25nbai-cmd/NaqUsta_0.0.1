import 'package:flutter/material.dart';
import '../models/chat_model.dart';

class OnlineUserItem extends StatelessWidget {
  final ChatModel chat;

  const OnlineUserItem({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [Color(0xFFFFD700), Colors.transparent],
                ),
              ),
              child: ClipOval(
                child: Image.network(
                  chat.img,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: Color(0xFF121212),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  margin: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 56,
          child: Text(
            chat.name.split(' ')[0],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF888888), fontSize: 10),
          ),
        ),
      ],
    );
  }
}