import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movewell/core/theme/colors.dart';
import 'package:movewell/core/widgets/header_background.dart';
import 'package:movewell/core/models/mock_data.dart';

class EditHealthDetailsScreen extends StatefulWidget {
  const EditHealthDetailsScreen({super.key});

  @override
  State<EditHealthDetailsScreen> createState() => _EditHealthDetailsScreenState();
}

class _EditHealthDetailsScreenState extends State<EditHealthDetailsScreen> {
  late TextEditingController _bloodTypeController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _diagnosisController;
  late TextEditingController _emergencyController;

  @override
  void initState() {
    super.initState();
    final patient = MockData.currentPatient;
    _bloodTypeController = TextEditingController(text: patient.bloodType);
    _heightController = TextEditingController(text: patient.height);
    _weightController = TextEditingController(text: patient.weight);
    _diagnosisController = TextEditingController(text: patient.primaryDiagnosis);
    _emergencyController = TextEditingController(text: patient.emergencyContact);
  }

  void _saveChanges() {
    MockData.currentPatient = MockData.currentPatient.copyWith(
      bloodType: _bloodTypeController.text.trim(),
      height: _heightController.text.trim(),
      weight: _weightController.text.trim(),
      primaryDiagnosis: _diagnosisController.text.trim(),
      emergencyContact: _emergencyController.text.trim(),
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Health details updated successfully!'),
        backgroundColor: AppColors.primary,
      ),
    );
    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _bloodTypeController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _diagnosisController.dispose();
    _emergencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const HeaderBackground(),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildHeaderTopArea(context),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Edit Health Details',
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Form Fields
                          _buildLabeledInput('Blood Type', _bloodTypeController, 'e.g., A+'),
                          const SizedBox(height: 20),
                          _buildLabeledInput('Height', _heightController, 'e.g., 170 cm'),
                          const SizedBox(height: 20),
                          _buildLabeledInput('Weight', _weightController, 'e.g., 65 kg'),
                          const SizedBox(height: 20),
                          _buildLabeledInput('Primary Diagnosis / Injury', _diagnosisController, 'Your condition'),
                          const SizedBox(height: 20),
                          _buildLabeledInput('Emergency Contact', _emergencyController, 'Name & Number'),
                          
                          const SizedBox(height: 48),
                          
                          // Save Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _saveChanges,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Save Details',
                                style: GoogleFonts.leagueSpartan(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 100),
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
    );
  }

  Widget _buildLabeledInput(String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.leagueSpartan(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.leagueSpartan(color: AppColors.textHint),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
            style: GoogleFonts.leagueSpartan(color: AppColors.textPrimary, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderTopArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (Navigator.canPop(context)) Navigator.pop(context, false);
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
