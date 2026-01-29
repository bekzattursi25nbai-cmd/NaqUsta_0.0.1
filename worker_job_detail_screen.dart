import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase қосу керек

class WorkerJobDetailScreen extends StatefulWidget {
  final String docId; // 🔥 Құжат ID (Views көбейту үшін)
  final String title;
  final String price;
  final String address;
  final String description;
  final List<String> tags;
  final List<String> images;
  final String datePosted;
  final String deadline;
  final String? imageUrl;
  final int views; // 🔥 Келген қаралым саны
  final String area; // 🔥 Аумағы (Жер үйдің орнына осыны көрсетеміз)
  final String material; // 🔥 Материал кімнен

  const WorkerJobDetailScreen({
    super.key,
    required this.docId,
    required this.title,
    required this.price,
    required this.address,
    required this.description,
    required this.tags,
    required this.images,
    required this.datePosted,
    required this.deadline,
    required this.views,
    required this.area,
    required this.material,
    this.imageUrl,
  });

  @override
  State<WorkerJobDetailScreen> createState() => _WorkerJobDetailScreenState();
}

class _WorkerJobDetailScreenState extends State<WorkerJobDetailScreen> {
  int selectedImageIndex = 0;
  
  // Экрандағы қаралым саны (Базадан жауап келгенше ескіні көрсетіп тұру үшін)
  late int currentViews; 

  @override
  void initState() {
    super.initState();
    currentViews = widget.views;
    _incrementViewCount(); // 🔥 БЕТ АШЫЛҒАНДА САНАУДЫ БАСТАЙМЫЗ
  }

  // Қаралымды +1 қылу функциясы
  Future<void> _incrementViewCount() async {
    try {
      // Базадағы 'requests' коллекциясынан осы ID-ді тауып, views + 1 жасаймыз
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(widget.docId)
          .update({'views': FieldValue.increment(1)});
      
      // Экранда да бірден жаңартып қоямыз (пайдаланушы көрсін деп)
      setState(() {
        currentViews++;
      });
    } catch (e) {
      print("Error updating views: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? currentImage = (widget.images.isNotEmpty) 
        ? widget.images[selectedImageIndex] 
        : widget.imageUrl;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Stack(
        children: [
          // 1. БАСТЫ ФОТО
          Positioned(
            top: 0, left: 0, right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Container(
              color: Colors.black,
              child: currentImage != null
                  ? Image.network(
                      currentImage,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => const Center(
                        child: Icon(Icons.broken_image, color: Colors.white70, size: 50),
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.photo_library_outlined, size: 64, color: Colors.grey),
                    ),
            ),
          ),

          // Артқа қайту
          Positioned(
            top: 50, left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8)],
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
              ),
            ),
          ),

          // 2. АҚПАРАТ ПАНЕЛІ
          Positioned(
            top: MediaQuery.of(context).size.height * 0.38,
            left: 0, right: 0, bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 20),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // БАҒА
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.price, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF111827))),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(8)),
                                child: const Text("Белсенді", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // ТАҚЫРЫП
                          Text(widget.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.2)),
                          const SizedBox(height: 20),

                          // ЧИПТЕР (Қаралым саны енді шынайы!)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _featureChip(Icons.access_time_filled, widget.datePosted, Colors.blue),
                                const SizedBox(width: 10),
                                _featureChip(Icons.timer_outlined, "${widget.deadline} күнде", Colors.orange),
                                const SizedBox(width: 10),
                                // 🔥 МІНЕ, ШЫНАЙЫ ҚАРАЛЫМ САНЫ
                                _featureChip(Icons.remove_red_eye, "$currentViews қаралым", Colors.purple),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // КЛИЕНТ
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E7EB))),
                            child: Row(
                              children: [
                                const CircleAvatar(radius: 24, backgroundColor: Colors.white, child: Icon(Icons.person, color: Colors.black87)),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Тапсырыс беруші", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                      SizedBox(height: 2),
                                      Text("Сенімді клиент", style: TextStyle(fontSize: 12, color: Colors.grey)),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.verified, color: Colors.blueAccent),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // 🔥 ТЕХНИКАЛЫҚ ШАРТТАР (Артық заттар жоқ)
                          // Біз сұрамаған (Қабат, Жер үй) заттарды алып тастадым.
                          // Тек біз сұраған заттар қалды:
                          const Text("Жұмыс шарттары", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              _detailBox(Icons.handyman, "Материал", widget.material), // Шеберден/Менен
                              _detailBox(Icons.square_foot, "Көлемі", widget.area), // 120 м2
                            ],
                          ),
                          const SizedBox(height: 24),

                          // СИПАТТАМА
                          const Text("Толық сипаттамасы", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(widget.description, style: const TextStyle(fontSize: 15, height: 1.6, color: Color(0xFF4B5563))),
                          const SizedBox(height: 24),

                          // КАРТА
                          const Text("Орналасқан жері", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Container(
                            height: 140,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(16),
                              image: const DecorationImage(
                                image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQp8Vk1bF3vS6fXqXN3kP8jJ8hR5nZ5l7g8aA&usqp=CAU"),
                                fit: BoxFit.cover,
                                opacity: 0.8,
                              ),
                            ),
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.location_on, size: 18, color: Colors.red),
                                    const SizedBox(width: 6),
                                    Text(widget.address, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 24),

                          // ГАЛЕРЕЯ
                          if (widget.images.length > 1) ...[
                             Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Фотосуреттер", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text("${widget.images.length} фото", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 80,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.images.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () => setState(() => selectedImageIndex = index),
                                    child: Container(
                                      width: 80,
                                      margin: const EdgeInsets.only(right: 12),
                                      decoration: BoxDecoration(
                                        border: selectedImageIndex == index ? Border.all(color: Colors.amber, width: 2) : null,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(widget.images[index], fit: BoxFit.cover),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ТӨМЕНГІ БАТЫРМАЛАР
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56, height: 56,
                    decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(16)),
                    child: IconButton(
                      icon: const Icon(Icons.phone, color: Colors.black),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Тапсырыс қабылданды! Сәттілік! ✅")));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD700),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text("Тапсырысты алу", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- КӨМЕКШІ ВИДЖЕТТЕР ---

  Widget _featureChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
        ],
      ),
    );
  }

  // ТЕК КӨЛЕМ МЕН МАТЕРИАЛ ҮШІН
  Widget _detailBox(IconData icon, String label, String value) {
    // Енді екеу-ақ болған соң, енін үлкейтеміз (Жарты экран)
    double width = MediaQuery.of(context).size.width / 2 - 30; 
    
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(12), color: Colors.white),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: Color(0xFFF9FAFB), shape: BoxShape.circle),
            child: Icon(icon, size: 18, color: Colors.grey[600]),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}