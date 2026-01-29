import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../chat/screens/worker_chat_list_screen.dart';
import '../profile/screens/worker_profile_screen.dart';
import '../jobs/screens/worker_my_jobs_screen.dart'; 
// 1. Home бетін импорттау
import '../home/worker_home_screen.dart';

class WorkerMainNavigation extends StatefulWidget {
  const WorkerMainNavigation({super.key});

  @override
  State<WorkerMainNavigation> createState() => _WorkerMainNavigationState();
}

class _WorkerMainNavigationState extends State<WorkerMainNavigation> {
  int _currentIndex = 0;

  // 2. ЭКРАНДАР ТІЗІМІ
  final List<Widget> _screens = [
    const WorkerHomeScreen(userName: "Бекзат"), // 0: Басты бет
    const WorkerMyJobsScreen(), // 1: Placeholder
    const WorkerChatListScreen(),             // 2: Placeholder
    const WorkerProfileScreen(),         // 3: Placeholder
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EC), 
      resizeToAvoidBottomInset: false,
      
      body: Stack(
        children: [
          // НЕГІЗГІ ЭКРАНДАР
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),

          // FLOATING NAVIGATION BAR (АҚ ТҮСТІ)
          Positioned(
            bottom: 32,
            left: 24,
            right: 24,
            child: SafeArea(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Container(
                      height: 70,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        // ӨЗГЕРІС: Қара емес, АҚ ТҮС (Күн сәулесінде көріну үшін)
                        color: Colors.white.withValues(alpha: 0.9), 
                        borderRadius: BorderRadius.circular(30),
                        // Жиек сызығын сәл сұрғылт қылдық
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.05),
                        ),
                        // Көлеңкесін жұмсарттық
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _NavIcon(
                            icon: LucideIcons.layoutList,
                            active: _currentIndex == 0,
                            onTap: () => _onTabTapped(0),
                          ),
                          _NavIcon(
                            icon: LucideIcons.briefcase,
                            active: _currentIndex == 1,
                            onTap: () => _onTabTapped(1),
                          ),
                          _NavIcon(
                            icon: LucideIcons.messageSquare,
                            active: _currentIndex == 2,
                            onTap: () => _onTabTapped(2),
                          ),
                          _NavIcon(
                            icon: LucideIcons.userCheck,
                            active: _currentIndex == 3,
                            onTap: () => _onTabTapped(3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ИКОНКА ВИДЖЕТІ
class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _NavIcon({
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 44,
        height: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 26,
              // Белсенді болса САРЫ, болмаса СҰР (ақ фонда анық көрінеді)
              color: active
                  ? const Color(0xFFFFD700) // Gold
                  : const Color(0xFF9CA3AF), // Cool Gray (көрінетін сұр)
            ),
            if (active) ...[
              const SizedBox(height: 6),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD700),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFFD700),
                      blurRadius: 6,
                    )
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}