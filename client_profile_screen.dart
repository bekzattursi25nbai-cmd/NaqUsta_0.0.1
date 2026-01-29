import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:kuryl_kz/features/client/settings/client_settings_screen.dart';
import 'package:kuryl_kz/features/auth/screens/login_screen.dart';
// MODEL IMPORT
import '../../registration/models/client_register_model.dart';

class ClientProfileScreen extends StatefulWidget {
  final ClientRegisterModel? userData;

  const ClientProfileScreen({super.key, this.userData});

  @override
  State<ClientProfileScreen> createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  @override
  Widget build(BuildContext context) {
    const kGold = Color(0xFFFFD700);

    // Деректерді дайындау
    final userData = widget.userData;
    final String name = userData?.name.isNotEmpty == true ? userData!.name : "Қонақ";
    final String city = userData?.city.isNotEmpty == true ? userData!.city : "Қала таңдалмады";
    final String phone = userData?.phone ?? "";
    // Аватар үшін бірінші әріпті алу
    final String firstLetter = name.isNotEmpty ? name[0].toUpperCase() : "Q";
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. BACKGROUND GLOW (Артқы фондағы жарық - САҚТАЛДЫ)
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kGold.withOpacity(0.08),
                boxShadow: [
                  BoxShadow(
                    color: kGold.withOpacity(0.15),
                    blurRadius: 120,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // 2. HEADER (САҚТАЛДЫ)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Профиль",
                        style: TextStyle(
                          color: Color(0xFFEEEEEE),
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: IconButton(
                          icon: const Icon(CupertinoIcons.settings, size: 20, color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ClientSettingsScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // SCROLLABLE CONTENT
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        // --- ЖАҢА ҚАРАПАЙЫМ ПРОФИЛЬ БЛОГЫ (Картаның орнына) ---
                        Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              // Аватар (Жай ғана дөңгелек сурет орны)
                              Container(
                                width: 100, height: 100,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E1E1E), // Сәл ашық қара фон
                                  shape: BoxShape.circle,
                                  // Жіңішке алтын жиек (жалпы стильден шықпау үшін)
                                  border: Border.all(color: kGold.withOpacity(0.3), width: 1.5),
                                ),
                                child: Center(
                                  child: Text(
                                    firstLetter,
                                    style: const TextStyle(
                                      fontSize: 40, 
                                      fontWeight: FontWeight.bold, 
                                      color: kGold // Әріптің түсі алтын
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Аты-жөні
                              Text(
                                name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Қала және телефон (қосымша ақпарат)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.location_solid, color: Colors.white.withOpacity(0.5), size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    city,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 14,
                                    ),
                                  ),
                                  if (phone.isNotEmpty) ...[
                                    Text(
                                      "  |  $phone",
                                       style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 14,
                                      ),
                                    )
                                  ]
                                ],
                              ),
                            ],
                          ),
                        ),
                        // --------------------------------------------------

                        const SizedBox(height: 40),

                        // 4. MENU ITEMS (САҚТАЛДЫ)
                        const _SectionHeader(title: "БАПТАУЛАР"),
                        const SizedBox(height: 12),
                        
                        _MenuItem(
                          icon: CupertinoIcons.person,
                          label: "Жеке деректер",
                          desc: name, // Деректерден келген атты көрсетеміз
                          onTap: () {},
                        ),
                        const SizedBox(height: 12),
                        _MenuItem(
                          icon: Icons.account_balance_wallet_outlined,
                          label: "Төлем тәсілдері",
                          desc: "Kaspi Gold",
                          onTap: () {},
                        ),
                        const SizedBox(height: 12),
                        _MenuItem(
                          icon: CupertinoIcons.bell,
                          label: "Хабарламалар",
                          desc: "Қосулы",
                          onTap: () {},
                        ),
                        const SizedBox(height: 12),
                        _MenuItem(
                          icon: CupertinoIcons.shield,
                          label: "Құпиялылық",
                          desc: "Пароль, FaceID",
                          onTap: () {},
                        ),

                        const SizedBox(height: 32),
                        
                        // 5. ADDITIONAL (САҚТАЛДЫ)
                        const _SectionHeader(title: "ҚОСЫМША"),
                        const SizedBox(height: 12),
                        
                        _MenuItem(
                          icon: CupertinoIcons.question_circle,
                          label: "Қолдау қызметі",
                          onTap: () {},
                        ),
                        const SizedBox(height: 12),
                        
                        // LOGOUT BUTTON (САҚТАЛДЫ)
                        const _LogoutButton(),
                        
                        // Төменгі жақтағы бос орын (Навигация үшін)
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// WIDGETS (Карта класы жойылды, қалғаны сақталды)
// ---------------------------------------------------------------------------

/// БӨЛІМ ТАҚЫРЫБЫ
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF666666),
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }
}

/// МӘЗІР ЭЛЕМЕНТІ (MENU ITEM)
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? desc;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.desc,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: const Color(0xFFFFD700).withOpacity(0.1),
        highlightColor: Colors.white.withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF121212),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Icon(icon, color: const Color(0xFFFFD700), size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Color(0xFFEEEEEE),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (desc != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        desc!,
                        style: const TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                CupertinoIcons.chevron_right,
                color: Color(0xFF444444),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ШЫҒУ ТҮЙМЕСІ (LOGOUT)
class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(initialIsWorker: false),
            ),
            (route) => false,
          );
        },
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.red.withOpacity(0.2),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.red.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.logout, color: Colors.red, size: 20),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  "Шығу",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
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