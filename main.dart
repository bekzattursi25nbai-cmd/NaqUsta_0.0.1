import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // 1. Firebase Core импорттау
import 'firebase_options.dart'; // 2. Настройка файлын импорттау
import 'package:kuryl_kz/features/auth/screens/role_selection_screen.dart';

void main() async {
  // 3. Flutter-дің жүйемен байланысын тексереміз (Міндетті!)
  WidgetsFlutterBinding.ensureInitialized();

  // 4. Firebase-ті іске қосамыз
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quryl',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        primarySwatch: Colors.amber,
        useMaterial3: true,
      ),
      // Қосымша Рөл таңдау экранынан басталады
      home: const RoleSelectionScreen(),
    );
  }
}