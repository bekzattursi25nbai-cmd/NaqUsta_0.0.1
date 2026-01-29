import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lucide_icons/lucide_icons.dart'; // Егер бұл пакет жоқ болса, кәдімгі Icons-ты қолдан

// Модельді импорттау
import '../models/worker_model.dart'; 

class WorkerDetailScreen extends StatelessWidget {
  final WorkerModel worker;

  const WorkerDetailScreen({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    // Түстер (Сенің түстерің)
    const kGold = Color(0xFFFFD700);
    const kBgColor = Color(0xFF0F0F0F); // Терең қара
    const kCardBg = Color(0xFF1A1A1A); // Сәл ашық қара
    const kBorder = Color(0xFF333333);

    return Scaffold(
      backgroundColor: kBgColor,
      body: Stack(
        children: [
          // 1. SCROLLABLE CONTENT
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // HEADER (СУРЕТ + АТЫ)
              SliverAppBar(
                expandedHeight: 320,
                backgroundColor: kBgColor,
                pinned: true,
                stretch: true,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Артқы фондық сәуле (Soft Glow)
                      Positioned(
                        top: 60,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kGold.withOpacity(0.15),
                            boxShadow: [
                              BoxShadow(
                                color: kGold.withOpacity(0.2),
                                blurRadius: 100,
                                spreadRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Аватар және Негізгі инфо
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          Hero(
                            tag: 'avatar_${worker.id}',
                            child: Container(
                              width: 120,
                              height: 120,
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: kGold, width: 2),
                                boxShadow: [
                                  BoxShadow(color: kGold.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 5))
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(worker.img, fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            worker.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: kGold.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: kGold.withOpacity(0.3)),
                            ),
                            child: Text(
                              worker.spec.toUpperCase(),
                              style: const TextStyle(
                                color: kGold,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // BODY CONTENT
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      
                      // СТАТИСТИКА БЛОГЫ
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: kCardBg,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: kBorder),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatItem("Рейтинг", "${worker.rate}", Icons.star, kGold),
                            _buildDivider(),
                            _buildStatItem("Жұмыс", "${worker.jobs}+", LucideIcons.briefcase, Colors.white),
                            _buildDivider(),
                            _buildStatItem("Тәжірибе", worker.exp, LucideIcons.clock, Colors.white),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // БАҒАСЫ
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Сағаттық бағасы:", style: TextStyle(color: Colors.grey, fontSize: 16)),
                          Text(
                            worker.price,
                            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // НЕГІЗГІ ҚЫЗМЕТТЕРІ (TAGS)
                      _buildSectionTitle("ҚЫЗМЕТТЕР"),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: worker.tags.map((tag) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: kCardBg,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: kBorder),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        )).toList(),
                      ),

                      const SizedBox(height: 30),

                      // ТУРАЛЫ (ABOUT)
                      _buildSectionTitle("ШЕБЕР ТУРАЛЫ"),
                      ...worker.about.map((text) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          text,
                          style: TextStyle(color: Colors.grey[400], fontSize: 15, height: 1.6),
                        ),
                      )).toList(),

                      const SizedBox(height: 30),

                      // ПІКІРЛЕР (REVIEWS)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSectionTitle("ПІКІРЛЕР (${worker.reviews})"),
                          const Text("Барлығын көру", style: TextStyle(color: kGold, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      _buildReviewCard("Асқар Б.", "Уақытында келді, жұмысы таза. Ұсынамын!", 5, "2 күн бұрын"),
                      _buildReviewCard("Гүлнәр К.", "Өте сыпайы маман. Бәрін түсіндіріп берді.", 5, "1 апта бұрын"),
                      
                      // АСТЫҢҒЫ БОС ОРЫН (Батырма жауып қалмау үшін)
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 2. STICKY BOTTOM BAR (ТҰРАҚТЫ ТӨМЕНГІ БАТЫРМА)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).padding.bottom + 20),
                  decoration: BoxDecoration(
                    color: kBgColor.withOpacity(0.85),
                    border: const Border(top: BorderSide(color: kBorder)),
                  ),
                  child: Row(
                    children: [
                      // ХАБАРЛАМА ЖАЗУ (ICON ONLY)
                      Container(
                        width: 56,
                        height: 56,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: kCardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: kBorder),
                        ),
                        child: IconButton(
                          icon: const Icon(LucideIcons.messageSquare, color: Colors.white),
                          onPressed: () {},
                        ),
                      ),
                      
                      // ҚОҢЫРАУ ШАЛУ (BIG BUTTON)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kGold,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(LucideIcons.phone, size: 20),
                              SizedBox(width: 10),
                              Text(
                                "ХАБАРЛАСУ",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER METHODS ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey[800],
    );
  }

  Widget _buildReviewCard(String name, String text, int rating, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF252525)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.grey[800],
                    child: Text(name[0], style: const TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                  const SizedBox(width: 8),
                  Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const SizedBox(width: 4),
                  Text("$rating.0", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(text, style: TextStyle(color: Colors.grey[400], fontSize: 13, height: 1.4)),
          const SizedBox(height: 8),
          Text(date, style: TextStyle(color: Colors.grey[700], fontSize: 11)),
        ],
      ),
    );
  }
}