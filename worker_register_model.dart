import 'package:cloud_firestore/cloud_firestore.dart';

class WorkerRegisterModel {
  String? phone;
  String? email;
  String? password;
  String? fullName;
  String? location;
  String? age;
  int experienceYear;
  String? specialty;
  String? bio;
  bool hasBrigade;

  WorkerRegisterModel({
    this.phone,
    this.email,
    this.password,
    this.fullName,
    this.location,
    this.age,
    this.experienceYear = 3,
    this.specialty,
    this.bio,
    this.hasBrigade = false,
  });

  // Бастапқы бос күйі
  factory WorkerRegisterModel.empty() {
    return WorkerRegisterModel(
      experienceYear: 3, 
      specialty: "Әмбебап шебер",
      hasBrigade: false
    );
  }

  // 🔥 FIREBASE-КЕ ЖІБЕРЕТІН MAP (ТҮЗЕТІЛГЕН)
  Map<String, dynamic> toJson() {
    return {
      // 1. Негізгі ақпарат (Басты беттегі WorkerModel-мен сәйкестендірілді)
      'role': 'worker',
      'firstName': fullName ?? "Аты жоқ", // 'full_name' ЕМЕС, 'firstName' болуы керек!
      'phone': phone,
      'email': email,
      'city': location ?? "Алматы",
      'age': int.tryParse(age ?? "25") ?? 25,
      'experience': "$experienceYear жыл", // String түрінде сақтаған ыңғайлы
      'about': bio ?? "",
      'hasBrigade': hasBrigade,
      'specialty': specialty ?? "Әмбебап",
      
      // 2. Дефолт мәндер (Карточка әдемі көрінуі үшін)
      'hourlyRate': "Келісім бойынша",
      'rating': 5.0,            // Жаңа шеберге 5 жұлдыз береміз
      'completedOrders': 0,
      'reviewCount': 0,
      
      // 3. ТІЗІМГЕ ШЫҒАРУ КІЛТІ 🔑
      'isPromoted': true,       // Бұлсыз басты бетте КӨРІНБЕЙДІ!
      
      // 4. Сурет және уақыт
      'avatarUrl': 'https://img.freepik.com/free-photo/portrait-smiling-manual-worker-with-helmet_329181-3745.jpg',
      'tags': [specialty ?? 'Шебер', 'Сапалы', 'Тез'],
      'createdAt': FieldValue.serverTimestamp(), // Сервер уақыты дұрысырақ
    };
  }
}