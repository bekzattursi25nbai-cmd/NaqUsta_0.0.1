import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kuryl_kz/features/worker/registration/screens/worker_registration_steps.dart';
import 'package:kuryl_kz/features/client/registration/screens/client_register_screen.dart';
import 'package:kuryl_kz/features/worker/navigation/worker_main_navigation.dart';
import 'package:kuryl_kz/features/client/navigation/client_main_navigation.dart';

class LoginScreen extends StatefulWidget {
  final bool initialIsWorker;

  const LoginScreen({
    super.key,
    required this.initialIsWorker,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late bool isWorker;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  
  bool _isLoading = false;
  bool _isCodeSent = false;
  String? _verificationId;

  @override
  void initState() {
    super.initState();
    isWorker = widget.initialIsWorker;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Color get themeColor =>
      isWorker ? Colors.amber.shade400 : Colors.grey.shade900;

  Future<void> _verifyUserAndSendSMS() async {
    String phoneRaw = _phoneController.text.trim();
    if (phoneRaw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Нөмірді жазыңыз!")));
      return;
    }
    String phoneNumber = "+7$phoneRaw"; 
    
    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          _navigateToHome();
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Қате: ${e.message}")));
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _isCodeSent = true;
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("SMS код жіберілді!")));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );

    } catch (e) {
      setState(() => _isLoading = false);
      print("Error: $e");
    }
  }

  Future<void> _signInWithOTP() async {
    String smsCode = _otpController.text.trim();
    if (smsCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("6 сандық кодты толық жазыңыз")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      _navigateToHome();
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Қате код! Қайта тексеріңіз."), backgroundColor: Colors.red),
      );
    }
  }

  void _navigateToHome() {
    if (isWorker) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WorkerMainNavigation()),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ClientMainNavigation()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white, // Фонды ақ қылдым
        resizeToAvoidBottomInset: true, // Клавиатура шыққанда экран көтеріледі
        body: Stack(
          children: [
            // ФОНДЫҚ АНИМАЦИЯ (Шар)
            Positioned(
              top: -100,
              right: -50,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isWorker
                      ? Colors.amber.shade300.withOpacity(0.3)
                      : Colors.grey.shade300.withOpacity(0.3),
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // TOGGLE (Шебер / Тапсырысшы)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Opacity(
                      opacity: _isCodeSent ? 0.5 : 1.0, 
                      child: IgnorePointer(
                        ignoring: _isCodeSent, 
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Stack(
                            children: [
                              AnimatedAlign(
                                duration: const Duration(milliseconds: 300),
                                alignment: isWorker
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Container(
                                      width: constraints.maxWidth / 2,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.05),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() => isWorker = true),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        color: Colors.transparent,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.construction, size: 18, color: isWorker ? Colors.grey.shade900 : Colors.grey.shade400),
                                            const SizedBox(width: 8),
                                            Text("Шебер", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isWorker ? Colors.grey.shade900 : Colors.grey.shade400)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() => isWorker = false),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        color: Colors.transparent,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.home, size: 18, color: !isWorker ? Colors.grey.shade900 : Colors.grey.shade400),
                                            const SizedBox(width: 8),
                                            Text("Тапсырысшы", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: !isWorker ? Colors.grey.shade900 : Colors.grey.shade400)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // НЕГІЗГІ КОНТЕНТ
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ИКОНКА
                            Center(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: themeColor,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: themeColor.withOpacity(0.4),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: AnimatedRotation(
                                  turns: isWorker ? 0 : 0.03,
                                  duration: const Duration(milliseconds: 500),
                                  child: Icon(
                                    isWorker ? Icons.construction : Icons.home,
                                    size: 40,
                                    color: isWorker ? Colors.grey.shade900 : Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            const Text(
                              "Қош келдіңіз!",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Кіру үшін нөміріңізді енгізіңіз",
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),

                            const SizedBox(height: 32),

                            // PHONE INPUT
                            const Padding(
                              padding: EdgeInsets.only(left: 4, bottom: 8),
                              child: Text("Телефон нөмірі", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: _isCodeSent ? Colors.grey[200] : Colors.grey[50],
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade200, width: 2),
                              ),
                              child: TextField(
                                controller: _phoneController,
                                enabled: !_isCodeSent,
                                keyboardType: TextInputType.phone,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _isCodeSent ? Colors.grey : const Color(0xFF111827)),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                  prefixIcon: Container(
                                    width: 80, 
                                    padding: const EdgeInsets.only(left: 16),
                                    alignment: Alignment.centerLeft,
                                    child: const Text("🇰🇿 +7", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
                                  ),
                                  hintText: "(700) 000 00 00",
                                  hintStyle: TextStyle(color: Colors.grey.shade400),
                                ),
                              ),
                            ),

                            // SMS CODE INPUT
                            if (_isCodeSent) ...[
                              const SizedBox(height: 20),
                              const Padding(
                                padding: EdgeInsets.only(left: 4, bottom: 8),
                                child: Text("SMS код", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.blue, width: 2),
                                ),
                                child: TextField(
                                  controller: _otpController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 6,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 8),
                                  decoration: const InputDecoration(
                                    counterText: "",
                                    border: InputBorder.none,
                                    hintText: "000000",
                                    hintStyle: TextStyle(letterSpacing: 5),
                                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isCodeSent = false;
                                      _otpController.clear();
                                    });
                                  },
                                  child: const Text("Нөмірді өзгерту", style: TextStyle(color: Colors.grey, fontSize: 14)),
                                ),
                              ),
                            ],

                            const SizedBox(height: 32),

                            // LOGIN BUTTON
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                color: isWorker ? Colors.grey.shade900 : Colors.amber.shade400,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: (isWorker ? Colors.black : Colors.amber).withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: _isLoading 
                                  ? null 
                                  : (_isCodeSent ? _signInWithOTP : _verifyUserAndSendSMS),
                                child: Center(
                                  child: _isLoading 
                                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : Text(
                                    _isCodeSent ? "Кіру" : "Код алу",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isWorker ? Colors.white : Colors.grey.shade900),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            if (!_isCodeSent)
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: Divider(color: Colors.grey.shade300)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Text("НЕМЕСЕ", style: TextStyle(color: Colors.grey.shade400, fontSize: 12, fontWeight: FontWeight.bold)),
                                    ),
                                    Expanded(child: Divider(color: Colors.grey.shade300)),
                                  ],
                                ),

                                const SizedBox(height: 24),

                                Row(
                                  children: [
                                    // GOOGLE ICON
                                    Expanded(
                                      child: Container(
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(color: Colors.grey.shade200, width: 2),
                                        ),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(16),
                                          onTap: () { print("Google login tapped"); },
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Image.network(
                                              "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/512px-Google_%22G%22_Logo.svg.png", 
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    // APPLE ICON
                                    Expanded(
                                      child: Container(
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(16),
                                          onTap: () { print("Apple login tapped"); },
                                          child: const Center(child: Icon(Icons.apple, color: Colors.white, size: 28)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ТІРКЕЛУ (Төменге жабыстырылған)
                  if (!_isCodeSent) 
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: Colors.grey.shade100)),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        if (isWorker) {
                          Navigator.push(context, MaterialPageRoute(builder: (c) => const WorkerRegistrationSteps()));
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (c) => const ClientRegisterScreen()));
                        }
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey.shade500, fontFamily: 'Inter'),
                          children: [
                            const TextSpan(text: "Аккаунтыңыз жоқ па? "),
                            TextSpan(
                              text: "Тіркелу",
                              style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline, color: isWorker ? Colors.amber.shade700 : Colors.grey.shade900),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}