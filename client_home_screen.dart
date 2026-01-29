import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ИМПОРТТАР (ДҰРЫСТАЛҒАН)
import 'package:kuryl_kz/features/client/home/widgets/worker_mini_card.dart';
import 'package:kuryl_kz/features/client/home/widgets/worker_preview_card.dart'; // Егер файл аты басқа болса, өзгерт
import 'package:kuryl_kz/features/client/home/models/worker_model.dart'; // Модельдің жолын дұрыста

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = "Барлығы";
  String _searchQuery = "";

  final Color kGold = const Color(0xFFFFD700);
  final Color kBgBlack = const Color(0xFF000000);
  final Color kInputBg = const Color(0xFF1A1A1A);
  final Color kBorder = const Color(0xFF333333);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgBlack,
      body: Stack(
        children: [
          // 1. ФОНДЫҚ ЖАРЫҚ (GLOW)
          Positioned(
            top: -150,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kGold.withOpacity(0.15),
                boxShadow: [
                  BoxShadow(
                    color: kGold.withOpacity(0.15),
                    blurRadius: 180,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // 2. HEADER
                _buildHeader(),

                // 3. ТІЗІМ (StreamBuilder)
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('role', isEqualTo: 'worker')
                        .where('isPromoted', isEqualTo: true) 
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: Color(0xFFFFD700)));
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text("Қате: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
                      }

                      var docs = snapshot.data?.docs ?? [];
                      
                      // СҮЗГІЛЕУ (Filter Logic)
                      if (_selectedCategory != "Барлығы") {
                        docs = docs.where((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return data['specialty'] == _selectedCategory;
                        }).toList();
                      }
                      if (_searchQuery.isNotEmpty) {
                        docs = docs.where((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final name = (data['firstName'] ?? "").toString().toLowerCase();
                          return name.contains(_searchQuery.toLowerCase());
                        }).toList();
                      }

                      if (docs.isEmpty) {
                        return const Center(child: Text("Шеберлер табылмады...", style: TextStyle(color: Colors.grey)));
                      }

                      return CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(child: _buildCategories()),
                          
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Үздік шеберлер", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                  Text("${docs.length} шебер", style: TextStyle(color: Colors.grey[600])),
                                ],
                              ),
                            ),
                          ),

                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                // 1. Деректерді аламыз
                                final data = docs[index].data() as Map<String, dynamic>;
                                final id = docs[index].id;

                                // 2. WorkerModel-ге айналдырамыз (ТҮЗЕТІЛГЕН ЖЕРІ ОСЫ!)
                                final worker = WorkerModel.fromMap(data, id);

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        // DetailScreen енді WorkerModel сұрайды
                                        builder: (context) => WorkerDetailScreen(worker: worker),
                                      ),
                                    );
                                  },
                                  // MiniCard та енді WorkerModel сұрайды
                                  child: WorkerMiniCard(worker: worker),
                                );
                              },
                              childCount: docs.length,
                            ),
                          ),
                          const SliverToBoxAdapter(child: SizedBox(height: 100)),
                        ],
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

  // ... (Header және Categories кодтары сол қалпы)
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("МЕКЕН-ЖАЙ", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(CupertinoIcons.map_pin_ellipse, color: kGold, size: 14),
                      const SizedBox(width: 4),
                      const Text("Қазақстан, Барлық қала", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              CircleAvatar(backgroundColor: kInputBg, child: const Icon(Icons.person, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: kInputBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kBorder),
            ),
            child: Row(
              children: [
                const Icon(CupertinoIcons.search, color: Colors.grey),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Шебер іздеу...",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Icon(Icons.filter_list, color: kGold),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    final categories = ["Барлығы", "Крыша", "Электрик", "Сантехник", "Бетон", "Сварка", "Тазалық"];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isActive = _selectedCategory == cat;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isActive ? kGold : kInputBg,
                borderRadius: BorderRadius.circular(20),
                border: isActive ? null : Border.all(color: kBorder),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  color: isActive ? Colors.black : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}