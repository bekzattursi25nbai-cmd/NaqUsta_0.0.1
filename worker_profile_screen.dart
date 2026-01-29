import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Импорттарды өз жобаңызға сай тексеріңіз
import '../../../auth/screens/login_screen.dart';
import 'worker_settings_screen.dart';

class WorkerProfileScreen extends StatefulWidget {
  const WorkerProfileScreen({super.key});

  @override
  State<WorkerProfileScreen> createState() => _WorkerProfileScreenState();
}

class _WorkerProfileScreenState extends State<WorkerProfileScreen> {
  // FIREBASE АЙНЫМАЛЫЛАРЫ
  final User? currentUser = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool isPromoted = false; // Жарнамалау статусы

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // 1. БАЗАДАН ДЕРЕК АЛУ
  Future<void> _fetchUserData() async {
    if (currentUser == null) return;

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>;
          isPromoted = userData?['isPromoted'] ?? false; // Базадан статус алу
          isLoading = false;
        });
      }
    } catch (e) {
      print("Қате: $e");
      setState(() => isLoading = false);
    }
  }

  // 2. ЖАРНАМАЛАУДЫ ҚОСУ/ӨШІРУ (FIREBASE UPDATE)
  Future<void> _togglePromotion(bool value) async {
    if (currentUser == null) return;

    // Оптимистік UI (Бірден өзгертеміз, қате болса кері қайтарамыз)
    setState(() => isPromoted = value);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update({'isPromoted': value});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(value 
            ? "Сіз енді клиенттерге жарнамаланасыз! 🎉" 
            : "Жарнамалау тоқтатылды."),
          backgroundColor: value ? Colors.green : Colors.grey,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      setState(() => isPromoted = !value); // Қате болса кері қайтару
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Қате орын алды")),
      );
    }
  }

  // 3. АККАУНТТЫ ӨШІРУ
  Future<void> _deleteAccount() async {
    if (currentUser == null) return;

    try {
      // Алдымен Firestore-дан өшіреміз
      await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).delete();
      
      // Сосын Auth-тан өшіреміз
      await currentUser!.delete();

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen(initialIsWorker: true)),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Қате: $e. Қайта кіріп көріңіз.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF3F4F6),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Менің аккаунтым",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.settings, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WorkerSettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // HEADER
            _buildProfileHeader(),

            const SizedBox(height: 24),

            // ЖАРНАМАЛАУ БЛОГЫ
            _buildPromotionCard(),

            const SizedBox(height: 24),

            // СТАТИСТИКА
            _buildStatisticsCard(),

            const SizedBox(height: 24),

            // МЕНЮ
            _buildMenuSection(context),

            const SizedBox(height: 30),

            // ШЫҒУ
            _buildLogoutButton(context),
            
            const SizedBox(height: 20),

            // АККАУНТТЫ ӨШІРУ
            TextButton(
              onPressed: () => _showDeleteConfirmDialog(context),
              child: Text("Аккаунтты өшіру", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // --- ӨЗГЕРТІЛГЕН HEADER (СУРЕТ ЖҮКТЕУ ҚАТЕСІН ТҮЗЕТУ) ---
  Widget _buildProfileHeader() {
    String avatarUrl = userData?['avatarUrl'] ?? "https://cdn-icons-png.flaticon.com/512/149/149071.png";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              // 1. АВАТАР (Image.network + errorBuilder)
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Жүктеліп жатқанда сұр болып тұрады
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    avatarUrl,
                    fit: BoxFit.cover,
                    // ЕГЕР СУРЕТ ЖҮКТЕЛМЕСЕ (404), ҚАТЕ ШЫҚПАЙДЫ, ИКОНКА ШЫҒАДЫ:
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person, color: Colors.grey, size: 40);
                    },
                  ),
                ),
              ),
              // 2. ВЕРИФИКАЦИЯ БЕЛГІСІ
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 12),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userData?['firstName'] ?? "Аты жоқ",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  userData?['specialty'] ?? "Мамандығы көрсетілмеген",
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFFD700)),
                  ),
                  child: const Text(
                    "PRO Аккаунт",
                    style: TextStyle(color: Color(0xFFB45309), fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ... (Қалған бөліктер сол қалпы)

  Widget _buildPromotionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPromoted 
            ? [Colors.blue.shade600, Colors.blue.shade400] 
            : [Colors.white, Colors.white],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isPromoted ? Colors.white.withOpacity(0.2) : Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              LucideIcons.megaphone, 
              color: isPromoted ? Colors.white : Colors.blue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Мені жарнамалау",
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 16,
                        color: isPromoted ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => _showInfoDialog(context),
                      child: Icon(Icons.info_outline, size: 18, color: isPromoted ? Colors.white70 : Colors.grey),
                    )
                  ],
                ),
                Text(
                  isPromoted ? "Сіз клиенттерге көрініп тұрсыз" : "Тапсырыс алу үшін қосыңыз",
                  style: TextStyle(
                    fontSize: 12, 
                    color: isPromoted ? Colors.white70 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isPromoted,
            activeColor: Colors.white,
            activeTrackColor: Colors.blue.shade200,
            onChanged: _togglePromotion,
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem(userData?['rating']?.toString() ?? "5.0", "Рейтинг", Icons.star, Colors.amber),
          Container(width: 1, height: 40, color: Colors.white24),
          _statItem(userData?['completedOrders']?.toString() ?? "0", "Жұмыс", LucideIcons.briefcase, Colors.white),
          Container(width: 1, height: 40, color: Colors.white24),
          _statItem(userData?['experience'] ?? "1 жыл", "Тәжірибе", LucideIcons.clock, Colors.white),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Column(
      children: [
        _menuItem(context, icon: LucideIcons.user, title: "Жеке деректер", subtitle: "Өзгерту"),
        _menuItem(context, icon: LucideIcons.image, title: "Портфолио", subtitle: "Фотолар қосу"),
        _menuItem(context, icon: LucideIcons.creditCard, title: "Төлем картасы", subtitle: "Kaspi Gold"),
        _menuItem(
          context, 
          icon: LucideIcons.languages, 
          title: "Тіл / Язык", 
          subtitle: "Қазақша",
          onTap: () => _showLanguageBottomSheet(context),
        ),
      ],
    );
  }

  Widget _menuItem(BuildContext context, {required IconData icon, required String title, String? subtitle, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: Colors.black87, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)) : null,
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap ?? () {},
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return TextButton(
      onPressed: () => _showLogoutDialog(context),
      style: TextButton.styleFrom(
        foregroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.red.withOpacity(0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.logOut, size: 20),
          SizedBox(width: 8),
          Text("Аккаунттан шығу", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Мені жарнамалау деген не?"),
        content: const Text(
          "Бұл функция қосылғанда, сіздің профиліңіз клиенттерге іздеу нәтижесінде көрінеді.\n\n"
          "Егер демалғыңыз келсе немесе жұмыс көп болса, өшіріп қоюға болады.",
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Түсінікті")),
        ],
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Тілді таңдаңыз", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ListTile(
                leading: const Text("🇰🇿", style: TextStyle(fontSize: 24)),
                title: const Text("Қазақ тілі"),
                trailing: const Icon(Icons.check, color: Colors.blue),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Text("🇷🇺", style: TextStyle(fontSize: 24)),
                title: const Text("Русский язык"),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Шығу", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Сіз шынымен аккаунттан шыққыңыз келе ме?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Жоқ", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen(initialIsWorker: true)),
                  (route) => false,
                );
              }
            },
            child: const Text("Иә, шығу", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Аккаунтты өшіру", style: TextStyle(color: Colors.red)),
        content: const Text(
          "Бұл әрекетті қайтару мүмкін емес. Сіздің барлық деректеріңіз, портфолио және рейтингіңіз өшіріледі.\n\n"
          "Растайсыз ба?",
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Бас тарту")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
            child: const Text("Өшіру", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}