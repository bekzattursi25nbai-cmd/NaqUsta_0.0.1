import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/worker_register_controller.dart';
import 'worker_step1_contact.dart';
import 'worker_step2_profile.dart';
import 'worker_success.dart';

class WorkerRegistrationSteps extends StatelessWidget {
  const WorkerRegistrationSteps({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller-ді осы жерде жасаймыз, барлық қадамдар осыны қолданады
    return ChangeNotifierProvider(
      create: (_) => WorkerRegisterController(),
      child: const _WorkerRegistrationContent(),
    );
  }
}

class _WorkerRegistrationContent extends StatefulWidget {
  const _WorkerRegistrationContent();

  @override
  State<_WorkerRegistrationContent> createState() => _WorkerRegistrationContentState();
}

class _WorkerRegistrationContentState extends State<_WorkerRegistrationContent> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Келесі бетке өту анимациясы
  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Артқа қайту
  void _prevPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300), 
        curve: Curves.easeInOut
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<WorkerRegisterController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: _prevPage,
        ),
        // Прогресс индикаторы (жолақшалар)
        title: _buildProgressIndicator(),
        centerTitle: true,
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1E1E1E)))
          : PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // Қолмен сырғытуға болмайды
              onPageChanged: (index) => setState(() => _currentStep = index),
              children: [
                // 1-ҚАДАМ: БАЙЛАНЫС ЖӘНЕ ҚҰПИЯ СӨЗ
                WorkerStep1Contact(
                  onNext: (phone, email, password) {
                    // Контроллерге үшеуін де жібереміз
                    controller.updateContactInfo(phone, email, password);
                    _nextPage();
                  },
                ),

                // 2-ҚАДАМ: ПРОФИЛЬ (Минималистік)
                WorkerStep2Profile(
                  onUpdate: (name, loc, age, exp, bio, brigade) {
                    controller.updateProfileInfo(
                      name: name, 
                      location: loc, 
                      age: age, 
                      experience: exp, 
                      bio: bio, 
                      hasBrigade: brigade
                    );
                  },
                  onFinish: () async {
                    // Тіркелуді бастау
                    bool success = await controller.registerWorker();
                    
                    if (!mounted) return;
                    
                    if (success) {
                      // Сәтті аяқталса -> Success бетіне өту
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkerSuccessScreen(
                            userName: controller.workerData.fullName ?? "Шебер",
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
    );
  }

  // Прогресс бар (Сары және Сұр сызықтар)
  Widget _buildProgressIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _stepBar(isActive: true), // 1-қадам әрқашан активті
        const SizedBox(width: 8),
        _stepBar(isActive: _currentStep >= 1), // 2-қадам
      ],
    );
  }

  Widget _stepBar({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFFFD700) : Colors.grey[200], // Сары немесе Сұр
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}