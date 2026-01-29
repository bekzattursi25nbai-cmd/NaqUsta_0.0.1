import 'package:flutter/material.dart';
import '../models/worker_register_model.dart';
// AuthService-ті импорттауды ұмытпа! (жолын дұрыстап жаз)
import '../../../../core/services/auth_service.dart'; 

class WorkerRegisterController extends ChangeNotifier {
  final WorkerRegisterModel _model = WorkerRegisterModel.empty();
  final AuthService _authService = AuthService(); // Сервисті қостық
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  WorkerRegisterModel get workerData => _model;

  // 1-қадам: Байланыс
  void updateContactInfo(String phone, String email, String password) {
    _model.phone = phone;
    _model.email = email;
    _model.password = password;
    notifyListeners();
  }

  // 2-қадам: Профиль
  void updateProfileInfo({
    required String name,
    required String location,
    required String age,
    required int experience,
    required String bio,
    required bool hasBrigade,
  }) {
    _model.fullName = name;
    _model.location = location;
    _model.age = age;
    _model.experienceYear = experience;
    _model.bio = bio;
    _model.hasBrigade = hasBrigade;
    notifyListeners();
  }

  // 🔥 НАҒЫЗ ТІРКЕЛУ ФУНКЦИЯСЫ
  Future<bool> registerWorker() async {
    _isLoading = true;
    notifyListeners();

    // Егер email бос болса, уақытша email жасап береміз (Firebase email-сіз тіркемейді)
    String finalEmail = _model.email!.isEmpty 
        ? "${_model.phone!.replaceAll('+', '').replaceAll(' ', '')}@naqusta.kz" 
        : _model.email!;

    bool success = await _authService.registerWorker(
      email: finalEmail,
      password: _model.password!, // Step 1-де жинаған пароль
      workerData: _model.toJson(), // Барлық деректер
    );

    _isLoading = false;
    notifyListeners();
    
    return success;
  }
}