import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RequestDetailsScreen extends StatelessWidget {
  const RequestDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const kGold = Color(0xFFFFD700);
    const kCardBg = Color(0xFF111111);
    const kBorderColor = Color(0xFF222222);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            // -------------------------------------------------------
            // 1. IMAGE HEADER + TOP BUTTONS
            // -------------------------------------------------------
            Stack(
              children: [
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Image.network(
                    "https://images.unsplash.com/photo-1581094794329-c8112a89af12?w=500",
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: Colors.grey[900]),
                  ),
                ),

                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                          Colors.black,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),

                // Top Buttons
                Positioned(
                  top: 50,
                  left: 24,
                  right: 24,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _GlassButton(
                        icon: CupertinoIcons.arrow_left,
                        onTap: () => Navigator.pop(context),
                      ),
                      Row(
                        children: [
                          _GlassButton(icon: Icons.share_outlined, onTap: () {}),
                          const SizedBox(width: 12),
                          _GlassButton(icon: CupertinoIcons.heart, onTap: () {}),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // -------------------------------------------------------
            // 2. CONTENT
            // -------------------------------------------------------
            Transform.translate(
              offset: const Offset(0, -24),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // TITLE CARD
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: kCardBg,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: kBorderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 20,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: kGold.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: kGold.withOpacity(0.2)),
                            ),
                            child: const Text(
                              "БЕТОН ЖҰМЫСТАРЫ",
                              style: TextStyle(
                                color: kGold,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Стяжка құю",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // PRICE CARD
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: kCardBg,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: kBorderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1A1A1A),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.account_balance_wallet_outlined,
                                  color: kGold,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "БЮДЖЕТ",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            "120 000 ₸",
                            style: TextStyle(
                              color: kGold,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Courier',
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // INFO GRID
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 2.5,
                      padding: const EdgeInsets.only(top: 8),
                      children: const [
                        _InfoTile(
                            icon: CupertinoIcons.layers,
                            label: "КӨЛЕМІ",
                            value: "45 м²"),
                        _InfoTile(
                            icon: CupertinoIcons.time,
                            label: "МЕРЗІМ",
                            value: "2 күн"),
                        _InfoTile(
                            icon: CupertinoIcons.hammer,
                            label: "МАТЕРИАЛ",
                            value: "Шеберден"),
                        _InfoTile(
                            icon: Icons.history,
                            label: "ЖАРИЯЛАНДЫ",
                            value: "2 сағ бұрын"),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // LOCATION CARD
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: kCardBg,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: kBorderColor),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: const Color(0xFF333333)),
                            ),
                            child: const Icon(
                              CupertinoIcons.location_solid,
                              color: kGold,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "МЕКЕН-ЖАЙЫ",
                                style: TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Алматы, Бостандық, Абай 150",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // DESCRIPTION
                    const Text(
                      "Сипаттама",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Пәтерге стяжка құю керек. 5-қабат, лифт бар. Материалды өзіміз алып береміз немесе келісуге болады. Тезірек бастау керек.",
                      style: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 14,
                        height: 1.8,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ACTION BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            label: "Телефон",
                            icon: CupertinoIcons.phone_fill,
                            isPrimary: false,
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _ActionButton(
                            label: "Чатқа жазу",
                            icon: CupertinoIcons.chat_bubble_fill,
                            isPrimary: true,
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// HELPER WIDGETS (PRIVATE)
// -----------------------------------------------------------------------------

class _GlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF222222)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF666666), size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const kGold = Color(0xFFFFD700);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: isPrimary ? kGold : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(24),
          border: isPrimary ? null : Border.all(color: const Color(0xFF333333)),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: kGold.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isPrimary ? Colors.black : Colors.white,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? Colors.black : Colors.grey[400],
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
