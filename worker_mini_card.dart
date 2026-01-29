import 'package:flutter/material.dart';
import '../models/worker_model.dart';
import '../widgets/worker_preview_card.dart'; // PreviewCard қай жерде тұрса, соны дұрыста

class WorkerMiniCard extends StatelessWidget {
  final WorkerModel worker;

  const WorkerMiniCard({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    const kGold = Color(0xFFFFD700);
    const kCardBg = Color(0xFF161616); // Сәл ашықтау қара (Contrast үшін)
    const kBorder = Color(0xFF2A2A2A);

    return GestureDetector(
      onTap: () {
        // Анимациямен ашу (Fade + Slide)
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (context, _, __) => WorkerDetailScreen (worker: worker),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 0.05); // Сәл төменнен шығады
              const end = Offset.zero;
              const curve = Curves.easeOutCubic;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(position: animation.drive(tween), child: child),
              );
            },
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // 1. АВАТАР
            Hero(
              tag: 'avatar_${worker.id}',
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(worker.img),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: kBorder),
                ),
              ),
            ),
            
            const SizedBox(width: 16),

            // 2. АҚПАРАТ
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Мамандығы (Gold Badge)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: kGold.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          worker.spec.toUpperCase(),
                          style: const TextStyle(color: kGold, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Рейтинг
                      Row(
                        children: [
                          const Icon(Icons.star, color: kGold, size: 14),
                          const SizedBox(width: 4),
                          Text("${worker.rate}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    worker.name,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.wallet, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        worker.price,
                        style: TextStyle(color: Colors.grey[400], fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // 3. СТРЕЛКА (Navigation Hint)
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[700], size: 14),
          ],
        ),
      ),
    );
  }
}