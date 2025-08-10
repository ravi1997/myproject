import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:myproject/models/student.dart';
import 'package:myproject/services/DB/isar_services.dart';

class StudentScreeningCard extends StatefulWidget {
  final Student student;
  final dynamic school;
  final IsarService isarService;
  final void Function()? onSaveComplete;

  const StudentScreeningCard({
    super.key,
    required this.student,
    required this.school,
    required this.isarService,
    this.onSaveComplete,
  });

  @override
  State<StudentScreeningCard> createState() => _StudentScreeningCardState();
}

class _StudentScreeningCardState extends State<StudentScreeningCard> {
  String? wearGlass, contactLens, cutoffUVA1, cutoffUVA2, eyeTest, referred;
  final phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final options = {
    'yesno': ['Yes', 'No'],
    'cutoff': ['Can read 6/9', "Can't read 6/9"],
    'eyeTest': [
      'Never',
      'Within last 1 year',
      'During last 1-2 years',
      'Beyond 2 years',
      'Don’t Know',
    ],
    'referred': [
      'Yes, as child uses glasses/ Contact Lens',
      'Yes Unaided Vision <6/9 in any eye',
      'Not Referred',
      'Control Case',
    ],
  };

  @override
  void initState() {
    super.initState();
    final s = widget.student;
    wearGlass = s.wearGlass;
    contactLens = s.contactLens;
    cutoffUVA1 = s.cutoffUVA1;
    cutoffUVA2 = s.cutoffUVA2;
    eyeTest = s.eyeTest;
    referred = s.referred;
    phoneController.text = s.phone!;
  }

  Future<void> _saveScreeningData() async {
    if (!_formKey.currentState!.validate()) return;

    widget.student
      ..wearGlass = wearGlass ?? ''
      ..contactLens = contactLens ?? ''
      ..cutoffUVA1 = cutoffUVA1 ?? ''
      ..cutoffUVA2 = cutoffUVA2 ?? ''
      ..eyeTest = eyeTest ?? ''
      ..referred = referred ?? ''
      ..phone = phoneController.text.trim()
      ..school.value = widget.school;

    await widget.isarService.addOrUpdateStudent(widget.student);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Screening data saved")));

    widget.onSaveComplete?.call();
  }

  Widget _buildChips(
    String title,
    List<String> choices,
    String? selected,
    void Function(String) onSelect,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600),
          ),
          Wrap(
            spacing: 8,
            children: choices.map((o) {
              return ChoiceChip(
                label: Text(o),
                selected: selected == o,
                onSelected: (_) => setState(() => onSelect(o)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildChips(
            "Wearing Glasses",
            options['yesno']!,
            wearGlass,
            (v) => wearGlass = v,
          ),
          _buildChips(
            "Contact Lens",
            options['yesno']!,
            contactLens,
            (v) => contactLens = v,
          ),
          _buildChips(
            "Cutoff UVA1",
            options['cutoff']!,
            cutoffUVA1,
            (v) => cutoffUVA1 = v,
          ),
          _buildChips(
            "Cutoff UVA2",
            options['cutoff']!,
            cutoffUVA2,
            (v) => cutoffUVA2 = v,
          ),
          _buildChips(
            "Eye Test",
            options['eyeTest']!,
            eyeTest,
            (v) => eyeTest = v,
          ),
          _buildChips(
            "Referred Reason",
            options['referred']!,
            referred,
            (v) => referred = v,
          ),

          Padding(
            padding: EdgeInsets.only(bottom: 2.h),
            child: TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final phone = value?.trim() ?? '';
                if (phone.isEmpty) return 'Phone number is required';
                if (!RegExp(r'^[6-9]\d{9}$').hasMatch(phone)) {
                  return 'Enter a valid 10-digit phone number';
                }
                return null;
              },
            ),
          ),

          ElevatedButton.icon(
            onPressed: _saveScreeningData,
            icon: const Icon(Icons.save),
            label: const Text("Save Screening"),
          ),
        ],
      ),
    );
  }
}
