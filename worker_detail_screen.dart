import 'package:flutter/material.dart';
import 'package:kuryl_kz/features/worker/business_card/models/worker_model.dart';
import 'package:kuryl_kz/features/worker/business_card/widgets/worker_business_card.dart';


class WorkerDetailScreen extends StatelessWidget {
  final WorkerModel worker;

  const WorkerDetailScreen({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full Business Card
                  Hero(
                    tag: 'worker_${worker.id}',
                    child: WorkerBusinessCard(
                      name: worker.name,
                      city: worker.city,
                      exp: worker.experienceYears,
                      hasBrigade: worker.hasBrigade,
                      brigadeSize: worker.brigadeSize?.toString() ?? '',
                      specs: worker.specs,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailStat(
                          'РЕЙТИНГ', worker.rating.toString(), Icons.star, Colors.amber),
                      _buildDetailStat(
                          'ТАПСЫРЫС', '${worker.completedJobs}', Icons.check_circle, Colors.green),
                      _buildDetailStat(
                          'БАҒАСЫ', '₸${worker.minPrice}+', Icons.attach_money, Colors.white),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Bio
                  const Text("ТУРАЛЫ",
                      style: TextStyle(
                          color: Color(0xFF888888),
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    worker.bio.isEmpty ? "Қосымша ақпарат жоқ." : worker.bio,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Actions
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFF333333))),
              color: Color(0xFF1A1A1A),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD700),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Жұмысқа шақыру",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF333333),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.message, color: Colors.white),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDetailStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
                color: Color(0xFF888888), fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }
}