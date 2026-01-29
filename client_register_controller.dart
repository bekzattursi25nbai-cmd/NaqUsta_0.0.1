import 'package:flutter/foundation.dart';
import '../models/client_register_model.dart';

class ClientRegisterController {
  final ClientRegisterModel data = ClientRegisterModel(); // Модельді қолданамыз

  // Деректерді жинау (Сеттерлер)
  void setName(String value) => data.name = value.trim();
  void setPhone(String value) => data.phone = value.trim();
  void setCity(String value) => data.city = value.trim();
  void setEmail(String value) => data.email = value.trim();
  void setAddress(String value) => data.address = value.trim();
  void setAddressType(String value) => data.addressType = value;
  void setFloor(String value) => data.floor = value.trim();

  // Модельге қол жеткізу
  ClientRegisterModel get model => data;

  // ТЕРМИНАЛҒА ШЫҒАРУ ФУНКЦИЯСЫ
  void logData() {
    if (kDebugMode) {
      print("\n--------------------------------------------------");
      print("🚀 ЖАҢА КЛИЕНТ ТІРКЕЛДІ:");
      print("👤 Аты-жөні: ${data.name}");
      print("📞 Телефон: ${data.phone}");
      print("🏙 Қала: ${data.city}");
      print("🏠 Мекенжай: ${data.address}");
      print("🏢 Нысан түрі: ${data.addressType}");
      if (data.floor.isNotEmpty) print("↕ Қабат: ${data.floor}");
      print("--------------------------------------------------\n");
    }
  }
}