import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movewell/core/theme/colors.dart';
import 'package:movewell/core/models/mock_data.dart';
import 'package:movewell/core/features/doctor_dashboard/screens/doctor_patient_detail_screen.dart';
import 'package:movewell/core/features/doctor_dashboard/screens/doctor_qr_scanner_screen.dart';

class DoctorPatientsScreen extends StatefulWidget {
  const DoctorPatientsScreen({super.key});

  @override
  State<DoctorPatientsScreen> createState() => _DoctorPatientsScreenState();
}

class _DoctorPatientsScreenState extends State<DoctorPatientsScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  static const _filters = ['All', 'Active', 'Needs Attention', 'Discharged'];

  List<DoctorPatientModel> get _filteredPatients {
    var list = DoctorMockData.patientList.toList();

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((p) =>
          p.name.toLowerCase().contains(q) ||
          p.diagnosis.toLowerCase().contains(q)).toList();
    }

    if (_selectedFilter != 'All') {
      list = list.where((p) => p.status == _selectedFilter).toList();
    }

    return list;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Patients',
                    style: GoogleFonts.leagueSpartan(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DoctorQrScannerScreen()),
                      );
                      if (result == true) setState(() {});
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.qr_code_scanner_rounded,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                '${DoctorMockData.patientList.length} total patients',
                style: GoogleFonts.leagueSpartan(
                    fontSize: 14, color: AppColors.textMuted),
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  style: GoogleFonts.leagueSpartan(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search patients...',
                    hintStyle: GoogleFonts.leagueSpartan(
                        fontSize: 14, color: AppColors.textHint),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: AppColors.textMuted),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded,
                                color: AppColors.textMuted, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _filters.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = filter == _selectedFilter;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = filter),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: isSelected
                            ? null
                            : Border.all(color: AppColors.border),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        filter,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color:
                              isSelected ? Colors.white : AppColors.textMuted,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: _filteredPatients.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded,
                              size: 56, color: AppColors.textHint),
                          const SizedBox(height: 12),
                          Text(
                            'No patients found',
                            style: GoogleFonts.leagueSpartan(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _filteredPatients.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _buildPatientCard(_filteredPatients[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientCard(DoctorPatientModel patient) {
    Color adherenceColor;
    if (patient.adherencePercent >= 0.8) {
      adherenceColor = const Color(0xFF4ECDC4);
    } else if (patient.adherencePercent >= 0.6) {
      adherenceColor = const Color(0xFFFFB347);
    } else {
      adherenceColor = const Color(0xFFFF6B6B);
    }

    Color statusBgColor;
    Color statusTextColor;
    if (patient.status == 'Needs Attention') {
      statusBgColor = const Color(0xFFFFB347).withValues(alpha: 0.12);
      statusTextColor = const Color(0xFFFFB347);
    } else if (patient.status == 'Discharged') {
      statusBgColor = AppColors.textMuted.withValues(alpha: 0.12);
      statusTextColor = AppColors.textMuted;
    } else {
      statusBgColor = const Color(0xFF4ECDC4).withValues(alpha: 0.12);
      statusTextColor = const Color(0xFF4ECDC4);
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DoctorPatientDetailScreen(patient: patient),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 52,
              height: 52,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 52,
                    height: 52,
                    child: CircularProgressIndicator(
                      value: patient.adherencePercent,
                      strokeWidth: 3,
                      backgroundColor: AppColors.border,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(adherenceColor),
                    ),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.surface,
                    child: Text(
                      patient.name[0],
                      style: GoogleFonts.leagueSpartan(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          patient.name,
                          style: GoogleFonts.leagueSpartan(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusBgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          patient.status,
                          style: GoogleFonts.leagueSpartan(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: statusTextColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    patient.diagnosis,
                    style: GoogleFonts.leagueSpartan(
                        fontSize: 13, color: AppColors.textMuted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded,
                          size: 13, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Text(
                        'Last visit: ${patient.lastVisit}',
                        style: GoogleFonts.leagueSpartan(
                            fontSize: 12, color: AppColors.textHint),
                      ),
                      const Spacer(),
                      Text(
                        '${(patient.adherencePercent * 100).toInt()}%',
                        style: GoogleFonts.leagueSpartan(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: adherenceColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
