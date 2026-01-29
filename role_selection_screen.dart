// lib/features/auth/screens/role_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:kuryl_kz/features/auth/screens/login_screen.dart';
import 'package:kuryl_kz/features/auth/widgets/role_card.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  void _handleRoleSelect(String selectedRole) {
    final bool isWorkerRole = selectedRole == 'worker';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(initialIsWorker: isWorkerRole),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color amber400 = Color(0xFFFFC107);
    const Color amber600 = Color(0xFFD97706);
    const Color gray900 = Color(0xFF111827);

    return Scaffold(
      backgroundColor: Colors.white,
      // SafeArea + LayoutBuilder қолдану арқылы экранға бейімдейміз
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              // "ConstrainedBox" экран кішкентай болса да,
              // элементтерді қыспай, Scroll жасауға мүмкіндік береді
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),

                        /// 🔹 LOGO / ICON
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: amber400,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: amber400.withOpacity(0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.engineering,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// 🔹 TITLE
                        const Text(
                          "NaqUsta",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: gray900,
                          ),
                        ),

                        const SizedBox(height: 8),

                        /// 🔹 SUBTITLE
                        const Text(
                          "Жалғастыру үшін рөліңізді таңдаңыз",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 40),

                        /// 🔹 WORKER ROLE
                        RoleCard(
                          title: "Шебермін",
                          subtitle: "Жұмыс іздеймін, бригада басқарамын",
                          icon: Icons.engineering,
                          bgColor: amber400,
                          textColor: gray900,
                          iconBgColor: Colors.white,
                          iconColor: amber600,
                          onTap: () => _handleRoleSelect('worker'),
                        ),

                        const SizedBox(height: 20),

                        /// 🔹 CLIENT ROLE
                        RoleCard(
                          title: "Тапсырыс беремін",
                          subtitle: "Үй саламын, жөндеу жасаймын",
                          icon: Icons.home_work,
                          bgColor: gray900,
                          textColor: Colors.white,
                          iconBgColor: Colors.grey,
                          iconColor: Colors.white,
                          onTap: () => _handleRoleSelect('client'),
                        ),

                        // Spacer экран кішкентай болғанда қате береді,
                        // сондықтан Expanded қолданамыз немесе бос орын қалдырамыз
                        const Expanded(child: SizedBox(height: 20)),

                        /// 🔹 FOOTER
                        const Text(
                          "V 1.0.0 kuryl",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}