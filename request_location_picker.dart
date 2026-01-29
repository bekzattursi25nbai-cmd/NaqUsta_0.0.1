// lib/features/request/widgets/request_location_picker.dart

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class RequestLocationPicker extends StatefulWidget {
  final Function(String fullAddress) onSelect;

  const RequestLocationPicker({
    super.key,
    required this.onSelect,
  });

  @override
  State<RequestLocationPicker> createState() => _RequestLocationPickerState();
}

class _RequestLocationPickerState extends State<RequestLocationPicker> {
  String? selectedCity;
  String? selectedDistrict;
  String? selectedVillage;

  final Map<String, List<String>> districts = {
    "Алматы": ["Бостандық", "Медеу", "Алмалы", "Әуезов"],
    "Астана": ["Есіл", "Сарыарқа", "Алматы ауданы"],
    "Шымкент": ["Қаратау", "Әл-Фараби", "Еңбекші"],
  };

  final Map<String, List<String>> villages = {
    "Бостандық": ["Орбита", "Керемет", "Алатау"],
    "Медеу": ["Көктөбе", "Самал", "Есентай"],
    "Алмалы": ["Төле би", "Байтұрсын", "Қонаев"],
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF111111),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(top: BorderSide(color: Color(0xFF333333))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Мекен-жай таңдау",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF222222),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    CupertinoIcons.xmark,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ---------------------------------------
          // 1) CITY PICKER
          // ---------------------------------------
          _buildSelectTile(
            label: "Қала",
            value: selectedCity,
            onTap: () => _showList(
              title: "Қаланы таңдаңыз",
              items: districts.keys.toList(),
              onSelect: (v) {
                setState(() {
                  selectedCity = v;
                  selectedDistrict = null;
                  selectedVillage = null;
                });
              },
            ),
          ),

          // ---------------------------------------
          // 2) DISTRICT PICKER
          // ---------------------------------------
          if (selectedCity != null)
            _buildSelectTile(
              label: "Аудан",
              value: selectedDistrict,
              onTap: () => _showList(
                title: "Ауданды таңдаңыз",
                items: districts[selectedCity]!,
                onSelect: (v) {
                  setState(() {
                    selectedDistrict = v;
                    selectedVillage = null;
                  });
                },
              ),
            ),

          // ---------------------------------------
          // 3) VILLAGE PICKER
          // ---------------------------------------
          if (selectedDistrict != null)
            _buildSelectTile(
              label: "Ауыл",
              value: selectedVillage,
              onTap: () => _showList(
                title: "Ауыл таңдаңыз",
                items: villages[selectedDistrict] ?? ["Орталық", "Шет ауданы"],
                onSelect: (v) {
                  setState(() {
                    selectedVillage = v;
                  });
                },
              ),
            ),

          const Spacer(),

          // CONFIRM BUTTON
          ElevatedButton(
            onPressed: (selectedCity != null &&
                    selectedDistrict != null &&
                    selectedVillage != null)
                ? () {
                    final full = "$selectedCity, $selectedDistrict, $selectedVillage";
                    widget.onSelect(full);
                    Navigator.pop(context);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD700),
              foregroundColor: Colors.black,
              disabledBackgroundColor: Colors.grey[700],
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text(
              "Қабылдау",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------
  // SELECT TILE UI
  // ---------------------------------------------------
  Widget _buildSelectTile({
    required String label,
    required String? value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF333333)),
            ),
            child: Row(
              children: [
                Text(
                  value ?? "Таңдау...",
                  style: TextStyle(
                    color: value == null ? Colors.grey[600] : Colors.white,
                    fontSize: 15,
                    fontWeight:
                        value == null ? FontWeight.w400 : FontWeight.bold,
                  ),
                ),
                const Spacer(),
                const Icon(CupertinoIcons.chevron_down, color: Colors.white38),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------
  // GENERAL LIST PICKER
  // ---------------------------------------------------
  void _showList({
    required String title,
    required List<String> items,
    required Function(String) onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111111),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(24),
          height: 400,
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(color: Colors.white12),
                  itemBuilder: (_, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        onSelect(items[index]);
                      },
                      title: Text(
                        items[index],
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
