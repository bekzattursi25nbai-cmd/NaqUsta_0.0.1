import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../chat/models/chat_model.dart';
import '../widgets/chat_item.dart';
import 'chat_detail_screen.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  // Деректер
  final List<ChatModel> chats = [
    ChatModel(
      id: 1,
      name: 'Ержан Құрылыс',
      lastMessage: 'Иә, ертең бастай аламыз.',
      time: '14:30',
      unread: 2,
      online: true,
      img: 'https://images.unsplash.com/photo-1540569014015-19a7be504e3a?w=100',
    ),
    ChatModel(
      id: 2,
      name: 'Бригада "Тұлпар"',
      lastMessage: 'Материалды өзіңіз аласыз ба?',
      time: 'Кеше',
      unread: 0,
      online: false,
      img: 'https://images.unsplash.com/photo-1503387762-592deb58ef4e?w=100',
    ),
    ChatModel(
      id: 3,
      name: 'Сантехник 24/7',
      lastMessage: 'Суретті жібердім.',
      time: 'Дс',
      unread: 1,
      online: true,
      img: 'https://images.unsplash.com/photo-1581578731117-104f2a863a30?w=100',
    ),
    ChatModel(
      id: 4,
      name: 'Асқар Электрик',
      lastMessage: 'Рахмет, хабарласамын.',
      time: '12.05',
      unread: 0,
      online: false,
      img: 'https://randomuser.me/api/portraits/men/32.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000), // Тұтас қара фон
      body: Stack(
        children: [
          // АРТҚЫ ФОНДАҒЫ ЖАРЫҚ (GLOW) - ТҮЗЕТІЛГЕН БӨЛІК
          Positioned(
            top: -100,
            right: -100,
            child: ImageFiltered( // <--- ImageFiltered қолданамыз
              imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // HEADER
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Хабарламалар",
                        style: TextStyle(
                          color: Color(0xFFEEEEEE),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(LucideIcons.search, color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                ),

                // ТІЗІМ
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: chats.length,
                    separatorBuilder: (c, i) => Divider(color: Colors.white.withOpacity(0.05), height: 1),
                    itemBuilder: (context, index) {
                      return ChatItem(
                        chat: chats[index],
                        onTap: () {
                          // Чат ішіне кіру
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatDetailScreen(chat: chats[index]),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}