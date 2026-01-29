import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class ClientSettingsScreen extends StatefulWidget {
  const ClientSettingsScreen({super.key});

  @override
  State<ClientSettingsScreen> createState() => _ClientSettingsScreenState();
}

class _ClientSettingsScreenState extends State<ClientSettingsScreen> {
  // State variables (Күй айнымалылары)
  bool _notificationsEnabled = true;
  bool _faceIdEnabled = true;
  String _selectedLang = 'kz'; // 'kz' or 'ru'

  @override
  Widget build(BuildContext context) {
    // Негізгі түстер палитрасы
    const kGold = Color(0xFFFFD700);
    const kBgColor = Color(0xFF000000);
    
    return Scaffold(
      backgroundColor: kBgColor,
      body: Stack(
        children: [
          // ---------------------------------------------------------
          // 1. BACKGROUND DECOR (Артқы фон эффектілері)
          // ---------------------------------------------------------
          
          // Carbon texture imitation (Optional subtle noise pattern could go here)
          Positioned.fill(
             child: Container(color: Colors.black),
          ),

          // Golden Glow (Жарқырау эффектісі)
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
                    color: kGold.withOpacity(0.12),
                    blurRadius: 100,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),

          // ---------------------------------------------------------
          // 2. MAIN CONTENT (Негізгі контент)
          // ---------------------------------------------------------
          SafeArea(
            child: Column(
              children: [
                // HEADER (Тақырып және Артқа қайту)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Row(
                    children: [
                      // Back Button
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: IconButton(
                          icon: const Icon(CupertinoIcons.arrow_left, size: 20, color: Colors.white),
                          splashRadius: 24,
                          onPressed: () {
                            // Артқа қайту логикасы
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            } else {
                              debugPrint("Back button pressed (No previous route)");
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Title
                      const Text(
                        "Баптаулар",
                        style: TextStyle(
                          color: Color(0xFFEEEEEE),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // SCROLLABLE BODY
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        
                        // LANGUAGE SELECTOR (Тіл таңдау виджеті)
                        _buildLanguageSelector(),
                        const SizedBox(height: 24),

                        // GROUP: GENERAL (Жалпы)
                        _SettingsGroup(
                          title: "ЖАЛПЫ",
                          children: [
                            _SettingsItem.switchItem(
                              icon: CupertinoIcons.bell,
                              label: "Хабарламалар",
                              value: _notificationsEnabled,
                              onChanged: (val) => setState(() => _notificationsEnabled = val),
                            ),
                            _SettingsItem.textItem(
                              icon: CupertinoIcons.globe,
                              label: "Тіл параметрлері",
                              valueText: "Қазақша",
                            ),
                            _SettingsItem.textItem(
                              icon: CupertinoIcons.moon,
                              label: "Түнгі режим",
                              valueText: "Авто",
                              isLast: true,
                            ),
                          ],
                        ),

                        // GROUP: SECURITY (Қауіпсіздік)
                        _SettingsGroup(
                          title: "ҚАУІПСІЗДІК",
                          children: [
                            _SettingsItem.navItem(
                              icon: CupertinoIcons.shield,
                              label: "Пароль өзгерту",
                            ),
                            _SettingsItem.switchItem(
                              icon: Icons.phonelink_lock, // Smartphone icon imitation
                              label: "Face ID / Touch ID",
                              value: _faceIdEnabled,
                              onChanged: (val) => setState(() => _faceIdEnabled = val),
                            ),
                            _SettingsItem.navItem(
                              icon: CupertinoIcons.lock,
                              label: "Құпиялылық саясаты",
                              isLast: true,
                            ),
                          ],
                        ),

                        // GROUP: DATA (Деректер)
                        _SettingsGroup(
                          title: "ДЕРЕКТЕР",
                          children: [
                            _SettingsItem.textItem(
                              icon: CupertinoIcons.creditcard,
                              label: "Сақталған карталар",
                              valueText: "2 карта",
                            ),
                            // Custom item for Clear Cache (Trash icon)
                            _buildClearCacheItem(),
                          ],
                        ),

                        // GROUP: SUPPORT (Қолдау)
                        _SettingsGroup(
                          title: "ҚОЛДАУ",
                          children: [
                            _SettingsItem.navItem(
                              icon: CupertinoIcons.question_circle,
                              label: "Сұрақ-жауап (FAQ)",
                            ),
                            _SettingsItem.navItem(
                              icon: CupertinoIcons.doc_text,
                              label: "Оферта келісімі",
                              isLast: true,
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // LOGOUT BUTTON
                        _buildLogoutButton(),

                        // VERSION TEXT
                        const SizedBox(height: 24),
                        const Center(
                          child: Text(
                            "Quryl App v1.0.2 (Build 402)",
                            style: TextStyle(
                              color: Color(0xFF444444),
                              fontSize: 10,
                              fontFamily: 'Courier',
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
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

  // ---------------------------------------------------------------------------
  // UI COMPONENTS METHODS
  // ---------------------------------------------------------------------------

  /// Тіл таңдау панелі (Custom Animated Toggle)
  Widget _buildLanguageSelector() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      padding: const EdgeInsets.all(4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          // Екі бөлікке бөлеміз
          final itemWidth = width / 2;

          return Stack(
            children: [
              // Sliding Golden Pill
              AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: _selectedLang == 'kz' ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  width: itemWidth,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              
              // Text Buttons
              Row(
                children: [
                  _buildLangButton('kz', "🇰🇿 Қазақша"),
                  _buildLangButton('ru', "🇷🇺 Русский"),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLangButton(String code, String label) {
    final isSelected = _selectedLang == code;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedLang = code),
        behavior: HitTestBehavior.opaque,
        child: Container(
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.bold,
              // Анимация кезінде түстің ауысуы үшін
            ),
          ),
        ),
      ),
    );
  }

  /// Кеш тазалау элементі (Trash Icon)
  Widget _buildClearCacheItem() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Кешті тазалау логикасы
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Кеш тазаланды!")),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(CupertinoIcons.trash, color: Colors.grey, size: 18),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Кешті тазалау",
                    style: TextStyle(
                      color: Color(0xFFEEEEEE),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Text(
                "124 MB",
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 12,
                  fontFamily: 'Courier',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Шығу батырмасы (Logout)
  Widget _buildLogoutButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Шығу логикасы
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.red.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.logout, color: Colors.red, size: 18),
              SizedBox(width: 8),
              Text(
                "Шығу",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// REUSABLE WIDGETS
// ---------------------------------------------------------------------------

/// Баптаулар тобының контейнері
class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsGroup({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF666666),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

/// Баптаулар элементінің түрлері
class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget trailing;
  final VoidCallback? onTap;
  final bool isLast;

  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.trailing,
    this.onTap,
    this.isLast = false,
  });

  // Factory 1: Тексті бар элемент (мысалы: "Тіл", "Карта")
  factory _SettingsItem.textItem({
    required IconData icon,
    required String label,
    required String valueText,
    bool isLast = false,
  }) {
    return _SettingsItem(
      icon: icon,
      label: label,
      isLast: isLast,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            valueText,
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(CupertinoIcons.chevron_right, color: Color(0xFF444444), size: 16),
        ],
      ),
      onTap: () {},
    );
  }

  // Factory 2: Қосқышы бар элемент (Switch)
  factory _SettingsItem.switchItem({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isLast = false,
  }) {
    return _SettingsItem(
      icon: icon,
      label: label,
      isLast: isLast,
      // Custom Switch
      trailing: GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 44,
          height: 24,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: value ? const Color(0xFFFFD700) : const Color(0xFF333333),
            borderRadius: BorderRadius.circular(12),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Factory 3: Жай навигация элементі
  factory _SettingsItem.navItem({
    required IconData icon,
    required String label,
    bool isLast = false,
  }) {
    return _SettingsItem(
      icon: icon,
      label: label,
      isLast: isLast,
      trailing: const Icon(CupertinoIcons.chevron_right, color: Color(0xFF444444), size: 16),
      onTap: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: isLast 
            ? const BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24))
            : null,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: !isLast 
                ? Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05)))
                : null,
          ),
          child: Row(
            children: [
              // Icon Box
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFFFFD700), size: 18),
              ),
              const SizedBox(width: 12),
              
              // Label
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFFEEEEEE),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              
              // Trailing Widget (Switch or Text/Arrow)
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}