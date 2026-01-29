import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MyRequestScreen extends StatefulWidget {
  const MyRequestScreen({super.key});

  @override
  State<MyRequestScreen> createState() => _MyRequestScreenState();
}

class _MyRequestScreenState extends State<MyRequestScreen> {
  // Фильтр статусы (0 - Барлығы, 1 - Белсенді, 2 - Аяқталды)
  int _selectedFilter = 0;

  final List<Map<String, dynamic>> requests = [
    {
      "id": 1,
      "title": "Крыша жабу (120м²)",
      "cat": "КРЫША",
      "status": "active",
      "date": "Бүгін, 14:30",
      "price": "450 000 ₸",
      // Жаңа жұмыс істейтін сурет сілтемесі
      "img": "https://picsum.photos/id/10/200/200"
    },
    {
      "id": 2,
      "title": "Электр монтаж",
      "cat": "ЭЛЕКТРИК",
      "status": "active",
      "date": "Кеше",
      "price": "80 000 ₸",
      "img": "https://picsum.photos/id/20/200/200"
    },
    {
      "id": 3,
      "title": "Сантехника жөндеу",
      "cat": "САНТЕХНИК",
      "status": "done",
      "date": "10 Мамыр",
      "price": "15 000 ₸",
      "img": "https://picsum.photos/id/30/200/200"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Таза қара фон
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. ТАҚЫРЫП
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: Text(
                "Тапсырыстарым",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 2. ФИЛЬТР
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _FilterChip(
                      label: "Барлығы",
                      isActive: _selectedFilter == 0,
                      onTap: () => setState(() => _selectedFilter = 0)),
                  const SizedBox(width: 12),
                  _FilterChip(
                      label: "Белсенді",
                      isActive: _selectedFilter == 1,
                      onTap: () => setState(() => _selectedFilter = 1)),
                  const SizedBox(width: 12),
                  _FilterChip(
                      label: "Аяқталды",
                      isActive: _selectedFilter == 2,
                      onTap: () => setState(() => _selectedFilter = 2)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 3. ТІЗІМ
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: requests.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final item = requests[index];
                  // Фильтрация логикасы
                  if (_selectedFilter == 1 && item['status'] != 'active') {
                    return const SizedBox.shrink();
                  }
                  if (_selectedFilter == 2 && item['status'] != 'done') {
                    return const SizedBox.shrink();
                  }

                  return _MinimalRequestCard(data: item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------
// МИНИМАЛИСТІК КАРТОЧКА (ҚАТЕ ТҮЗЕТІЛДІ)
// -----------------------------------------------------------------
class _MinimalRequestCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const _MinimalRequestCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final bool isActive = data['status'] == 'active';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. СУРЕТ (Қате шықса сұр фон көрсетеді)
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: 80,
              height: 80,
              child: Image.network(
                data['img'],
                fit: BoxFit.cover,
                // ЕГЕР СУРЕТ ЖҮКТЕЛМЕСЕ (404), ҚАТЕ ШЫҚПАЙДЫ:
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: const Center(
                      child: Icon(Icons.image_not_supported, color: Colors.grey, size: 24),
                    ),
                  );
                },
                // СУРЕТ ЖҮКТЕЛІП ЖАТҚАНДА:
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[900],
                    child: const Center(
                      child: CupertinoActivityIndicator(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 16),

          // 2. АҚПАРАТ (Flexible қолданылды - экраннан шықпайды)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Категория және Күн
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        data['cat'],
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      data['date'],
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Тақырып
                Text(
                  data['title'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // Сыймаса "..." болады
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                // Баға және Статус
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        data['price'],
                        style: const TextStyle(
                            color: Color(0xFFFFD700),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Статус индикаторы
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFFFFD700).withOpacity(0.1)
                            : Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isActive ? "Ізделуде..." : "Аяқталды",
                        style: TextStyle(
                          color: isActive
                              ? const Color(0xFFFFD700)
                              : Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------
// ФИЛЬТР БАТЫРМАСЫ
// -----------------------------------------------------------------
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip(
      {required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.black : Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}