import 'package:flutter/material.dart';
import '../widgets/worker_card_preview.dart';
import 'worker_detail_screen.dart';
import 'package:kuryl_kz/features/worker/business_card/models/worker_model.dart';
import 'package:kuryl_kz/features/worker/business_card/models/worker_category_model.dart';




class WorkerListScreen extends StatelessWidget {
  final WorkerCategoryModel category;

  const WorkerListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Filter logic (Mock)
    final workers = category.id == 'all'
        ? mockWorkers
        : mockWorkers
            .where((w) => w.categories.contains(category.id))
            .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: Text(category.name, style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: workers.length,
        itemBuilder: (context, index) {
          final worker = workers[index];
          return WorkerCardPreview(
            worker: worker,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkerDetailScreen(worker: worker),
                ),
              );
            },
          );
        },
      ),
    );
  }
}