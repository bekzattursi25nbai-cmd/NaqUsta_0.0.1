import 'package:flutter/material.dart';
import 'package:kuryl_kz/features/client/navigation/client_main_navigation.dart';
import '../controller/client_register_controller.dart';
import '../widgets/client_input_field.dart';
// ЖАҢА ИМПОРТ (Жолы сенің папка құрылымыңа сәйкес болуы керек)
// Егер 'core' папкасы 'lib' ішінде болса:
import '../../../../core/services/auth_service.dart';

class ClientRegisterScreen extends StatefulWidget {
  const ClientRegisterScreen({super.key});

  @override
  State<ClientRegisterScreen> createState() => _ClientRegisterScreenState();
}

class _ClientRegisterScreenState extends State<ClientRegisterScreen> {
  final controller = ClientRegisterController();
  final AuthService _authService = AuthService(); // Сервисті қостық

  String _selectedObjectType = 'Пәтер';
  final List<String> _objectTypes = ['Пәтер', 'Жер үй', 'Офис', 'Коммерция'];

  // Құпия сөз үшін айнымалылар
  bool _obscurePassword = true;
  String _password = "";
  String _confirmPassword = "";
  bool _isLoading = false; // Жүктелу индикаторы үшін

  // Хабарлама шығару
  void _showAlert(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // БАРЛЫҒЫН ТЕКСЕРІП, FIREBASE-КЕ ЖІБЕРУ
  void _validateAndSubmit() async {
    final model = controller.model;

    // 1. Бос өрістерді тексеру
    if (model.name.isEmpty) {
      _showAlert("Аты-жөніңізді жазыңыз");
      return;
    }
    if (model.phone.isEmpty || model.phone.length < 11) {
      _showAlert("Телефон нөмірін толық жазыңыз");
      return;
    }

    // 2. Құпия сөзді тексеру
    if (_password.length < 6) {
      _showAlert("Құпия сөз тым қысқа (кемі 6 таңба)");
      return;
    }
    if (_password != _confirmPassword) {
      _showAlert("Құпия сөздер сәйкес келмейді");
      return;
    }

    // 3. Мекенжайды тексеру
    if (model.city.isEmpty) {
      _showAlert("Қаланы көрсетіңіз");
      return;
    }
    if (model.address.isEmpty) {
      _showAlert("Нақты мекенжайды жазыңыз");
      return;
    }

    // 4. Тіркелуді бастау
    setState(() => _isLoading = true);

    // Firebase email талап етеді. Егер email бос болса, телефоннан жасаймыз
    String emailToSend = model.email.isEmpty
        ? "${model.phone.replaceAll('+', '').replaceAll(' ', '')}@client.kz"
        : model.email;

    // AuthService арқылы тіркеу
    bool success = await _authService.registerClient(
      email: emailToSend,
      password: _password,
      userData: model.toMap(),
    );

    setState(() => _isLoading = false);

    if (success) {
      _showAlert("Сәтті тіркелдіңіз!", isError: false);
      
      // Келесі бетке өту (Map жібереміз)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ClientMainNavigation(userData: model.toMap()),
        ),
      );
    } else {
      _showAlert("Қате шықты! Интернетті тексеріңіз немесе бұл нөмір тіркелген.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("Тіркелу", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(left: 24, right: 24, bottom: keyboardHeight + 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildHeaderTitle(),
                      const SizedBox(height: 30),
                      _buildMainFields(),
                      const SizedBox(height: 20),
                      _buildPasswordFields(), // Құпия сөз бөлімі
                      const SizedBox(height: 30),
                      _buildAddressSection(),
                    ],
                  ),
                ),
              ),
              _buildBottomButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderTitle() {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
            child: const Icon(Icons.person_add, size: 40, color: Colors.black),
          ),
          const SizedBox(height: 16),
          const Text("Тіркелу", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const Text("Мәліметтерді толтырыңыз", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildMainFields() {
    return Column(
      children: [
        ClientInputField(
          label: "Аты-жөніңіз", hint: "Мысалы: Асқар", icon: Icons.person_outline, initialValue: "",
          onChanged: (v) => controller.setName(v),
        ),
        const SizedBox(height: 20),
        ClientInputField(
          label: "Телефон нөмірі", hint: "+7 777 000 00 00", icon: Icons.phone_outlined, initialValue: "",
          keyboard: TextInputType.phone, onChanged: (v) => controller.setPhone(v),
        ),
      ],
    );
  }

  Widget _buildPasswordFields() {
    return Column(
      children: [
        ClientInputField(
          label: "Құпия сөз", 
          hint: "••••••", 
          icon: Icons.lock_outline, 
          initialValue: "",
          isPassword: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
          onChanged: (v) => _password = v,
        ),
        const SizedBox(height: 20),
        ClientInputField(
          label: "Құпия сөзді қайталаңыз", 
          hint: "••••••", 
          icon: Icons.lock_reset, 
          initialValue: "",
          isPassword: _obscurePassword,
          onChanged: (v) => _confirmPassword = v,
        ),
      ],
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClientInputField(
          label: "Қала / Елді мекен", hint: "Алматы", icon: Icons.location_city, initialValue: "",
          onChanged: (v) => controller.setCity(v),
        ),
        const SizedBox(height: 20),
        const Text("Объект түрі", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: _objectTypes.map((type) {
            final isSelected = _selectedObjectType == type;
            return ChoiceChip(
              label: Text(type),
              selected: isSelected,
              selectedColor: Colors.black,
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
              onSelected: (val) {
                if (val) {
                  setState(() => _selectedObjectType = type);
                  controller.setAddressType(type);
                }
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        ClientInputField(
          label: "Нақты мекенжай", hint: "Абай даңғылы, 150", icon: Icons.map_outlined, initialValue: "",
          onChanged: (v) => controller.setAddress(v),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade200))),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _validateAndSubmit, // Жүктелу кезінде басылмайды
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: _isLoading 
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Тіркелуді аяқтау", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}