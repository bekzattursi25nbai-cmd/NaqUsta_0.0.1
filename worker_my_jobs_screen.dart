import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class WorkerMyJobsScreen extends StatefulWidget {
  const WorkerMyJobsScreen({super.key});

  @override
  State<WorkerMyJobsScreen> createState() => _WorkerMyJobsScreenState();
}

class _WorkerMyJobsScreenState extends State<WorkerMyJobsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Менің жұмыстарым", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFFFFD700), // Сары сызық
          indicatorWeight: 3,
          tabs: const [
            Tab(text: "Ағымдағы"),
            Tab(text: "Аяқталған"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. АҒЫМДАҒЫ ЖҰМЫСТАР
          _buildActiveJobsList(),

          // 2. АЯҚТАЛҒАН ЖҰМЫСТАР (Тарих)
          _buildHistoryJobsList(),
        ],
      ),
    );
  }

  // АҒЫМДАҒЫ ЖҰМЫСТАР ТІЗІМІ
  Widget _buildActiveJobsList() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildJobCard(
          title: "Кран ауыстыру",
          address: "Абай даңғылы, 150",
          price: "5 000 ₸",
          status: "Орындалуда",
          statusColor: Colors.blue,
          date: "Бүгін, 14:00",
          isActive: true,
        ),
      ],
    );
  }

  // АЯҚТАЛҒАН ЖҰМЫСТАР ТІЗІМІ
  Widget _buildHistoryJobsList() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildJobCard(
          title: "Розетка орнату",
          address: "Достық 89, 45 пәтер",
          price: "3 000 ₸",
          status: "Аяқталды",
          statusColor: Colors.green,
          date: "Кеше, 10:30",
          isActive: false,
        ),
        const SizedBox(height: 16),
        _buildJobCard(
          title: "Люстра ілу",
          address: "Төле би 50",
          price: "7 000 ₸",
          status: "Бас тартылды",
          statusColor: Colors.red,
          date: "12 Қаңтар",
          isActive: false,
        ),
      ],
    );
  }

  // КАРТОЧКА ДИЗАЙНЫ
  Widget _buildJobCard({
    required String title,
    required String address,
    required String price,
    required String status,
    required Color statusColor,
    required String date,
    required bool isActive,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ЖОҒАРҒЫ ЖАҚ: Күн және Статус
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // ОРТА: Аты және Мекенжай
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(LucideIcons.mapPin, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(address, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
          
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),

          // ТӨМЕНГІ ЖАҚ: Баға және Әрекет
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              
              if (isActive)
                ElevatedButton(
                  onPressed: () {
                    // Чатқа немесе аяқтауға өту
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: const Text("Ашу", style: TextStyle(color: Colors.white)),
                )
              else
                 const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }
}