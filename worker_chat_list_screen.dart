import 'package:flutter/material.dart';
import 'worker_chat_detail_screen.dart';

class WorkerChatListScreen extends StatelessWidget {
  const WorkerChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Хабарламалар", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 3, // Демо үшін 3 чат
        separatorBuilder: (c, i) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return _buildChatItem(context, index);
        },
      ),
    );
  }

  Widget _buildChatItem(BuildContext context, int index) {
    // Жалған деректер
    final names = ["Асқар (Клиент)", "Гүлнәр (Клиент)", "Қолдау қызметі"];
    final messages = ["Рахмет, бәрі жақсы!", "Қашан келесіз?", "Сұрағыңыз қабылданды"];
    final times = ["10:30", "Кеше", "Дс"];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WorkerChatDetailScreen(clientName: names[index]),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            // АВАТАР
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey[200],
                  child: Text(names[index][0], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
                if (index == 0) // Біріншісі онлайн болсын
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      width: 14, height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            // МӘТІН
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(names[index], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(times[index], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    messages[index],
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}