import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';

// SCREEN IMPORTS
import '../home/screens/client_home_screen.dart';
import '../chat/screens/client_list_screen.dart';
import 'package:kuryl_kz/features/client/my_request/screens/my_requests_screen.dart';
import '../profile/screens/client_profile_screen.dart';
import '../request/screens/request_create_screen.dart';
// MODEL IMPORT
import '../registration/models/client_register_model.dart';

final myRequestKey = GlobalKey();

class ClientMainNavigation extends StatefulWidget {
  // Біз бұл жерде MAP қабылдаймыз (өйткені тіркелуден Map келеді)
  final Map<String, dynamic>? userData;

  const ClientMainNavigation({super.key, this.userData});

  @override
  State<ClientMainNavigation> createState() => _ClientMainNavigationState();
}

class _ClientMainNavigationState extends State<ClientMainNavigation> {
  int _currentIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    
    // 1. MAP-ты MODEL-ге айналдыру логикасы
    // Профиль беті Model сұрап тұрғандықтан, біз Map-тан Model жасап аламыз
    ClientRegisterModel? profileModel;

    if (widget.userData != null) {
      profileModel = ClientRegisterModel();
      profileModel.name = widget.userData!['name'] ?? '';
      profileModel.phone = widget.userData!['phone'] ?? '';
      profileModel.city = widget.userData!['city'] ?? '';
      profileModel.email = widget.userData!['email'] ?? '';
      profileModel.address = widget.userData!['address'] ?? '';
      profileModel.addressType = widget.userData!['address_type'] ?? '';
      profileModel.floor = widget.userData!['floor'] ?? '';
    }

    // 2. Экрандар тізімі
    _screens = [
      const ClientHomeScreen(),
      MyRequestScreen(key: myRequestKey),
      const ClientListScreen(),
      // Енді Профильге дайын Model-ді береміз
      ClientProfileScreen(userData: profileModel), 
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),

          // FLOATING NAVIGATION BAR
          Positioned(
            bottom: 32,
            left: 24,
            right: 24,
            child: SafeArea(
              child: Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // GLASS BAR
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                        child: Container(
                          height: 70,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E1E).withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _NavIcon(
                                icon: LucideIcons.home,
                                active: _currentIndex == 0,
                                onTap: () => _onTabTapped(0),
                              ),
                              _NavIcon(
                                icon: LucideIcons.clock,
                                active: _currentIndex == 1,
                                onTap: () => _onTabTapped(1),
                              ),
                              const SizedBox(width: 56), 
                              _NavIcon(
                                icon: LucideIcons.messageSquare,
                                active: _currentIndex == 2,
                                onTap: () => _onTabTapped(2),
                              ),
                              _NavIcon(
                                icon: LucideIcons.user,
                                active: _currentIndex == 3,
                                onTap: () => _onTabTapped(3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // CENTER BUTTON (PLUS)
                    Positioned(
                      top: -24,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RequestCreateScreen(),
                            ),
                          );
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color(0xFFFFD700),
                              ),
                            ).animate().blurXY(begin: 12, end: 0),
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xFFFFD700), Color(0xFFFFC107)],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFF121212),
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: const Center(
                                child: Icon(LucideIcons.plus, color: Color(0xFF121212), size: 32),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _NavIcon({required this.icon, required this.active, required this.onTap});

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
              color: active ? const Color(0xFFFFD700) : const Color(0xFF555555),
            ),
            if (active) ...[
              const SizedBox(height: 6),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD700),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Color(0xFFFFD700), blurRadius: 6)],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}