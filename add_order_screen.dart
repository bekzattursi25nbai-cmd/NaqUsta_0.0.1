import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  // ... Контроллерлер мен логика (Алдыңғы кодтан алынады)
  // Қысқаша нұсқасын көрсетейін:

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Жаңа тапсырыс"),
        backgroundColor: AppTheme.primaryYellow,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("Жұмыс түрін таңдаңыз", style: AppTheme.titleStyle),
          const SizedBox(height: 10),
          // 3D Grid Category осында болады
          
          const SizedBox(height: 20),
          TextField(decoration: AppTheme.inputStyle("Не істеу керек? (Атауы)")),
          
          const SizedBox(height: 15),
          TextField(
            maxLines: 3,
            decoration: AppTheme.inputStyle("Толық сипаттамасы"),
          ),

          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: AppTheme.primaryButtonStyle,
              onPressed: () {
                // Firebase-ке жіберу
              },
              child: const Text("Жариялау"),
            ),
          )
        ],
      ),
    );
  }
}