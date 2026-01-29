import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'worker_job_detail_screen.dart'; // Деталь экранын қосуды ұмытпа!

class WorkerHomeScreen extends StatefulWidget {
  final String userName;
  const WorkerHomeScreen({super.key, this.userName = "Шебер Бекзат"});

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
  bool isOnline = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EC),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 448, maxHeight: 880),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFC),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 24, offset: const Offset(0, 10))
            ],
          ),
          child: Column(
            children: [
              // -------------------------------------------------------
              // 1. HEADER
              // -------------------------------------------------------
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 50, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 24, 
                          backgroundColor: Colors.white, 
                          child: Icon(Icons.person, color: Colors.black)
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("ҚОШ КЕЛДІҢІЗ", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                            Text(widget.userName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                          ],
                        ),
                      ],
                    ),
                    Switch(
                      value: isOnline,
                      activeColor: Colors.amber,
                      onChanged: (v) => setState(() => isOnline = v),
                    ),
                  ],
                ),
              ),

              // -------------------------------------------------------
              // 2. ТАПСЫРЫСТАР ТІЗІМІ
              // -------------------------------------------------------
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Жаңа тапсырыстар", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                        ),
                      ),
                      
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('requests')
                              .where('status', isEqualTo: 'pending')
                              .orderBy('created_at', descending: true)
                              .snapshots(),

                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text("Қате: ${snapshot.error}", style: const TextStyle(color: Colors.red, fontSize: 12)),
                                )
                              );
                            }
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator(color: Colors.amber));
                            }
                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return const Center(child: Text("Әзірге тапсырыс жоқ", style: TextStyle(color: Colors.grey)));
                            }

                            final docs = snapshot.data!.docs;

                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: docs.length,
                              itemBuilder: (context, index) {
                                final data = docs[index].data() as Map<String, dynamic>;

                                // --- 1. ДЕРЕКТЕРДІ ОҚУ ---
                                
                                // 🔥 ID алу (Қаралым санау үшін керек)
                                final String docId = docs[index].id;

                                final category = data['category'] ?? 'Тапсырыс';
                                final description = data['description'] ?? 'Сипаттама жоқ';
                                final address = data['location'] ?? 'Мекенжай белгісіз';
                                final priceStr = data['price'] != null ? "${data['price']} ₸" : "Келісімді";
                                final deadlineStr = data['duration'] ?? '1';
                                
                                // 🔥 ЖАҢА ДЕРЕКТЕРДІ ОҚУ:
                                final int views = data['views'] ?? 0; // Қаралым
                                final String area = data['area'] ?? "Белгісіз"; // Көлемі
                                // Материалды қазақшаға аудару
                                final String materialRaw = data['material_by'] ?? 'worker';
                                final String material = materialRaw == 'worker' ? 'Шеберден' : 'Клиенттен';

                                // --- 2. УАҚЫТТЫ ЕСЕПТЕУ ---
                                String timeAgo = "Жаңа";
                                if (data['created_at'] != null) {
                                  final Timestamp timestamp = data['created_at'];
                                  final DateTime dateTime = timestamp.toDate();
                                  final Duration diff = DateTime.now().difference(dateTime);
                                  
                                  if (diff.inDays > 0) {
                                    timeAgo = "${diff.inDays} күн бұрын";
                                  } else if (diff.inHours > 0) {
                                    timeAgo = "${diff.inHours} сағат бұрын";
                                  } else {
                                    timeAgo = "${diff.inMinutes} мин бұрын";
                                  }
                                }

                                // --- 3. СУРЕТТЕРДІ ЖИНАУ ---
                                // Ескі 'image_url' мен жаңа 'images' тізімін біріктіреміз
                                List<String> imagesList = [];
                                
                                // Егер жаңа 'images' тізімі болса, соны аламыз
                                if (data['images'] != null && (data['images'] as List).isNotEmpty) {
                                  imagesList = List<String>.from(data['images']);
                                } 
                                // Егер ол жоқ болса, ескі 'image_url'-ді аламыз
                                else if (data['image_url'] != null && data['image_url'] != "") {
                                  imagesList.add(data['image_url']);
                                }

                                // Басты сурет (тізімнің біріншісі немесе image_url)
                                final String? mainImageUrl = imagesList.isNotEmpty ? imagesList.first : null;

                                return GestureDetector(
                                  // --- 4. ДЕТАЛЬ БЕТІНЕ ЖІБЕРУ ---
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WorkerJobDetailScreen(
                                          // БАРЛЫҚ ЖАҢА ПАРАМЕТРЛЕРДІ ҚОСТЫМ:
                                          docId: docId,           // 🔥 ID
                                          title: category,
                                          price: priceStr,
                                          address: address,
                                          description: description,
                                          tags: [category, "Жаңа"],
                                          images: imagesList,     // 🔥 Суреттер тізімі
                                          datePosted: timeAgo,
                                          deadline: deadlineStr,
                                          imageUrl: mainImageUrl, // Басты сурет
                                          views: views,           // 🔥 Қаралым саны
                                          area: area,             // 🔥 Көлемі
                                          material: material,     // 🔥 Материал
                                        ),
                                      ),
                                    );
                                  },
                                  child: JobCard(
                                    title: description.isNotEmpty ? description : category,
                                    price: priceStr,
                                    address: address,
                                    tag: category,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------
// JOB CARD
// ------------------------------------------
class JobCard extends StatelessWidget {
  final String title;
  final String price;
  final String address;
  final String tag;

  const JobCard({super.key, required this.title, required this.price, required this.address, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: const Color(0xFFFFFBEB), borderRadius: BorderRadius.circular(8)),
                child: Text(tag, style: const TextStyle(color: Color(0xFFD97706), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const Icon(Icons.circle, size: 8, color: Colors.green),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(child: Text(address, style: const TextStyle(color: Colors.grey, fontSize: 12), maxLines: 1)),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
            ],
          ),
        ],
      ),
    );
  }
}