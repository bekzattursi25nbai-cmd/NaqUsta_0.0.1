import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Firebase & Image Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

// Widgets (Жолдарын тексеріп қойыңыз)
import '../widgets/request_category_picker.dart';
import '../widgets/request_input_field.dart';
import '../widgets/request_description_field.dart';
import '../widgets/request_price_field.dart';
import '../widgets/request_material_toggle.dart';
import '../widgets/request_location_card.dart';
import '../widgets/request_contact_method.dart';
import '../widgets/privacy_policy_row.dart';
import '../widgets/request_publish_button.dart';
import '../widgets/request_image_picker.dart'; // Жаңа widget!
import '../widgets/request_location_picker.dart'; 

import '../models/category_model.dart';

class RequestCreateScreen extends StatefulWidget {
  const RequestCreateScreen({super.key});

  @override
  State<RequestCreateScreen> createState() => _RequestCreateScreenState();
}

class _RequestCreateScreenState extends State<RequestCreateScreen> {
  // -------------------------------------------------------------------------
  // STATE VARIABLES
  // -------------------------------------------------------------------------

  JobCategory? _selectedCategory;
  
  // 🔥 ТІЗІМ: Көп фото сақтау үшін
  List<File> _imageFiles = []; 

  String _jobTitle = "";
  String _area = "";
  String _description = "";
  String _price = "";
  bool _isNegotiable = false;
  String _materialBy = "worker";
  String _duration = "";
  String _address = "";
  String _contactMethod = "call";
  String _phoneNumber = "";

  bool _isLoading = false; 

  final List<JobCategory> _categories = jobCategories;

  // UI COLORS
  final Color kGold = const Color(0xFFFFD700);
  final Color kBorder = const Color(0xFF333333);
  final Color kCardBg = const Color(0xFF111111);

  // -------------------------------------------------------------------------
  // FUNCTIONS: MULTI-IMAGE PICKER & COMPRESSOR 📸
  // -------------------------------------------------------------------------

  // 1. Көп сурет таңдау
  Future<void> _pickMultiImages() async {
    final picker = ImagePicker();
    // Галереядан бірнешеуін таңдау
    final List<XFile> pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      List<File> newFiles = [];
      
      for (var xFile in pickedFiles) {
        File file = File(xFile.path);
        // Сығу (Compress)
        File? compressed = await _compressImage(file);
        newFiles.add(compressed ?? file);
      }

      setState(() {
        _imageFiles.addAll(newFiles);
      });
    }
  }

  // 2. Суретті тізімнен өшіру
  void _removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
    });
  }

  // 3. Суретті сығу (Compress) - 🔥 ОСЫ ЖЕР ТҮЗЕТІЛДІ
  Future<File?> _compressImage(File file) async {
    final dir = await path_provider.getTemporaryDirectory();
    
    // ТҮЗЕТУ: Соңына нақты ".jpg" жалғадық. Бұл қатені жояды.
    final targetPath = "${dir.absolute.path}/temp_${DateTime.now().millisecondsSinceEpoch}.jpg";

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 60, // Сапасы 60%
    );

    return result != null ? File(result.path) : null;
  }

  // -------------------------------------------------------------------------
  // FUNCTION: SUBMIT TO FIREBASE
  // -------------------------------------------------------------------------

  Future<void> _submitRequest() async {
    if (_jobTitle.isEmpty || _selectedCategory == null || _address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Маңызды өрістерді толтырыңыз (Аты, Категория, Адрес)")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      
      // 2. Суреттерді Storage-қа жүктеу (Циклмен)
      List<String> imageUrls = [];

      if (_imageFiles.isNotEmpty) {
        for (var file in _imageFiles) {
          // Файл атын бірегей қыламыз
          final String fileName = '${user?.uid}_${DateTime.now().millisecondsSinceEpoch}_${_imageFiles.indexOf(file)}.jpg';
          
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('request_images')
              .child(fileName);

          await storageRef.putFile(file);
          String url = await storageRef.getDownloadURL();
          imageUrls.add(url);
        }
      }

      // 3. Firestore-ға сақтау
      await FirebaseFirestore.instance.collection('requests').add({
        'client_uid': user?.uid,
        'client_phone': user?.phoneNumber ?? user?.email,
        'title': _jobTitle,
        'category': _selectedCategory!.name,
        'area': _area,
        'description': _description,
        'price': _isNegotiable ? "Келісімді" : _price,
        'is_negotiable': _isNegotiable,
        'material_by': _materialBy,
        'duration': _duration,
        'location': _address,
        'contact_method': _contactMethod,
        'phone_number': _phoneNumber,
        
        // 🔥 Тізімді сақтаймыз
        'images': imageUrls, 
        // Басты бетте көріну үшін бірінші суретті жеке де сақтап қоямыз
        'image_url': imageUrls.isNotEmpty ? imageUrls.first : "",
        
        'status': 'pending',
        'created_at': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Тапсырыс сәтті жарияланды! ✅"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Қате: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _openLocationPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RequestLocationPicker(
        onSelect: (fullAddress) {
          setState(() {
            _address = fullAddress;
          });
        },
      ),
    );
  }

  // -------------------------------------------------------------------------
  // BUILD UI
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildBackgroundGlow(),

          Column(
            children: [
              _buildHeader(),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // CATEGORY
                      GestureDetector(
                        onTap: () => _openCategoryPicker(context),
                        child: _buildCategoryCard(),
                      ),
                      const SizedBox(height: 32),

                      // 🔥 IMAGE PICKER (ЖАҢАРТЫЛҒАН)
                      RequestImagePicker(
                        selectedImages: _imageFiles,  // Тізімді береміз
                        onTap: _pickMultiImages,      // Көп сурет функциясы
                        onRemove: _removeImage,       // Өшіру функциясы
                      ),

                      // TITLE
                      RequestInputField(
                        label: "ЖҰМЫС АТАУЫ",
                        placeholder: "Мысалы: Розетка орнату",
                        icon: CupertinoIcons.briefcase,
                        initialValue: _jobTitle,
                        onChanged: (v) => _jobTitle = v,
                      ),

                      // AREA
                      RequestInputField(
                        label: "КӨЛЕМІ / САНЫ",
                        placeholder: "120 м² немесе 5 дана",
                        icon: CupertinoIcons.layers,
                        initialValue: _area,
                        onChanged: (v) => _area = v,
                      ),

                      // DESCRIPTION
                      RequestDescriptionField(
                        value: _description,
                        onChanged: (v) => _description = v,
                      ),

                      // PRICE
                      RequestPriceField(
                        isNegotiable: _isNegotiable,
                        onToggleNegotiable: (val) {
                          setState(() => _isNegotiable = val);
                        },
                        price: _price,
                        onPriceChanged: (v) => _price = v,
                      ),

                      // MATERIAL
                      RequestMaterialToggle(
                        selected: _materialBy,
                        onChanged: (v) => setState(() => _materialBy = v),
                      ),

                      // DURATION
                      RequestInputField(
                        label: "МЕРЗІМ (КҮН)",
                        placeholder: "Неше күн?",
                        keyboardType: TextInputType.number,
                        icon: CupertinoIcons.time,
                        initialValue: _duration,
                        onChanged: (v) => _duration = v,
                      ),

                      // LOCATION
                      RequestLocationCard(
                        address: _address,
                        onTap: _openLocationPicker,
                      ),

                      // CONTACT
                      RequestContactMethod(
                        selectedMethod: _contactMethod,
                        phoneNumber: _phoneNumber,
                        onSelect: (m) => setState(() => _contactMethod = m),
                        onPhoneChanged: (v) => _phoneNumber = v,
                      ),

                      const SizedBox(height: 12),
                      const PrivacyPolicyRow(),
                    ],
                  ),
                ),
              )
            ],
          ),

          // PUBLISH BUTTON
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _isLoading
                ? Container(
                    height: 100,
                    color: Colors.black.withOpacity(0.8),
                    child: const Center(child: CircularProgressIndicator(color: Color(0xFFFFD700))),
                  )
                : RequestPublishButton(
                    onTap: _submitRequest,
                  ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // UI HELPERS
  // -------------------------------------------------------------------------

  Widget _buildBackgroundGlow() {
    return Positioned(
      top: -150,
      right: -100,
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kGold.withOpacity(0.1),
          boxShadow: [
            BoxShadow(
              color: kGold.withOpacity(0.15),
              blurRadius: 150,
              spreadRadius: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16)
              .add(EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
          ),
          child: Row(
            children: [
              _buildBackButton(),
              const SizedBox(width: 16),
              const Text(
                "Тапсырыс беру",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        shape: BoxShape.circle,
        border: Border.all(color: kBorder),
      ),
      child: IconButton(
        icon: const Icon(CupertinoIcons.arrow_left, color: Colors.white, size: 18),
        onPressed: () => Navigator.maybePop(context),
      ),
    );
  }

  Widget _buildCategoryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _selectedCategory != null ? kGold.withOpacity(0.5) : kBorder,
        ),
        boxShadow: _selectedCategory != null
            ? [
                BoxShadow(
                  color: kGold.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                )
              ]
            : [],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Text(
              _selectedCategory?.icon ?? "🏷️",
              style: const TextStyle(fontSize: 22),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              _selectedCategory?.name ?? "Категорияны таңдаңыз",
              style: TextStyle(
                color: _selectedCategory != null ? Colors.white : Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Icon(
            CupertinoIcons.chevron_right,
            color: _selectedCategory != null ? kGold : Colors.grey[600],
            size: 20,
          ),
        ],
      ),
    );
  }

  void _openCategoryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return RequestCategoryPicker(
          categories: _categories,
          selected: _selectedCategory,
          onSelect: (cat) {
            setState(() => _selectedCategory = cat);
          },
        );
      },
    );
  }
}