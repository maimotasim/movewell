import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movewell/core/theme/colors.dart';
import 'package:movewell/core/widgets/header_background.dart';
import 'package:movewell/core/models/mock_data.dart';
import 'package:movewell/core/features/video_session/screens/waiting_room_screen.dart';
import 'package:movewell/core/services/agora_service.dart';

class DoctorPatientDetailScreen extends StatefulWidget {
  final DoctorPatientModel patient;

  const DoctorPatientDetailScreen({super.key, required this.patient});

  @override
  State<DoctorPatientDetailScreen> createState() => _DoctorPatientDetailScreenState();
}

class _DoctorPatientDetailScreenState extends State<DoctorPatientDetailScreen> {
  DoctorPatientModel get patient => widget.patient;
  final List<Map<String, dynamic>> _messages = [];

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
                const SizedBox(height: 10),
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
                          _buildPatientHeader(),
                          const SizedBox(height: 24),
                          _buildAdherenceCard(),
                          const SizedBox(height: 20),
                          _buildHealthSummaryCard(),
                          const SizedBox(height: 20),
                          _buildSessionProgress(),
                          const SizedBox(height: 20),
                          _buildClinicalNotes(),
                          const SizedBox(height: 20),
                          _buildPatientDocuments(),
                          const SizedBox(height: 20),
                          _buildActionButtons(context),
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

  Widget _buildHeaderTopArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
          const Spacer(),
          Text(
            'Patient Details',
            style: GoogleFonts.leagueSpartan(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
          const Spacer(),
          const SizedBox(width: 48), // Balance
        ],
      ),
    );
  }

  Widget _buildPatientHeader() {
    Color statusBg;
    Color statusText;
    if (patient.status == 'Needs Attention') {
      statusBg = const Color(0xFFFFB347).withValues(alpha: 0.12);
      statusText = const Color(0xFFFFB347);
    } else if (patient.status == 'Discharged') {
      statusBg = AppColors.textMuted.withValues(alpha: 0.12);
      statusText = AppColors.textMuted;
    } else {
      statusBg = const Color(0xFF4ECDC4).withValues(alpha: 0.12);
      statusText = const Color(0xFF4ECDC4);
    }

    return Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: AppColors.surface,
          child: Text(
            patient.name[0],
            style: GoogleFonts.leagueSpartan(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primary),
          ),
        ),
        const SizedBox(width: 16),
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
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      patient.status,
                      style: GoogleFonts.leagueSpartan(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: statusText),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${patient.age} years old · ${patient.gender}',
                style: GoogleFonts.leagueSpartan(
                    fontSize: 14, color: AppColors.textMuted),
              ),
              const SizedBox(height: 2),
              Text(
                patient.diagnosis,
                style: GoogleFonts.leagueSpartan(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdherenceCard() {
    final pct = (patient.adherencePercent * 100).toInt();
    Color barColor;
    String statusLabel;
    if (patient.adherencePercent >= 0.8) {
      barColor = const Color(0xFF4ECDC4);
      statusLabel = 'Excellent';
    } else if (patient.adherencePercent >= 0.6) {
      barColor = const Color(0xFFFFB347);
      statusLabel = 'Fair';
    } else {
      barColor = const Color(0xFFFF6B6B);
      statusLabel = 'Low';
    }

    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Exercise Adherence',
                style: GoogleFonts.leagueSpartan(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: barColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusLabel,
                  style: GoogleFonts.leagueSpartan(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: barColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: patient.adherencePercent,
                    minHeight: 10,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(barColor),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$pct%',
                style: GoogleFonts.leagueSpartan(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: barColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Summary',
            style: GoogleFonts.leagueSpartan(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child:
                      _buildInfoItem(Icons.water_drop_outlined, 'Blood', patient.bloodType)),
              Expanded(
                  child:
                      _buildInfoItem(Icons.height_rounded, 'Height', patient.height)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _buildInfoItem(
                      Icons.monitor_weight_outlined, 'Weight', patient.weight)),
              Expanded(
                  child:
                      _buildInfoItem(Icons.phone_outlined, 'Phone', patient.phone)),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoItem(
              Icons.emergency_outlined, 'Emergency', patient.emergencyContact),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _buildInfoItem(Icons.event_outlined, 'Last Visit',
                      patient.lastVisit)),
              Expanded(
                  child: _buildInfoItem(Icons.event_available_outlined,
                      'Next Appt.', patient.nextAppointment)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.leagueSpartan(
                      fontSize: 11, color: AppColors.textHint),
                ),
                Text(
                  value,
                  style: GoogleFonts.leagueSpartan(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionProgress() {
    final completed = patient.completedSessions;
    final total = patient.totalSessions;
    final progress = total > 0 ? completed / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Treatment Progress',
            style: GoogleFonts.leagueSpartan(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 6,
                        backgroundColor: AppColors.border,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary),
                      ),
                    ),
                    Text(
                      '$completed/$total',
                      style: GoogleFonts.leagueSpartan(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgressRow(
                        'Completed', '$completed sessions', AppColors.primary),
                    const SizedBox(height: 8),
                    _buildProgressRow('Remaining',
                        '${total - completed} sessions', AppColors.textMuted),
                    const SizedBox(height: 8),
                    _buildProgressRow(
                        'Completion',
                        '${(progress * 100).toInt()}%',
                        const Color(0xFF4ECDC4)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.leagueSpartan(
              fontSize: 13, color: AppColors.textMuted),
        ),
        Text(
          value,
          style: GoogleFonts.leagueSpartan(
              fontSize: 13, fontWeight: FontWeight.w600, color: color),
        ),
      ],
    );
  }

  Widget _buildClinicalNotes() {
    final patientNotes = DoctorMockData.recentNotes
        .where((n) => n.patientName == patient.name)
        .toList();

    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Clinical Notes',
                style: GoogleFonts.leagueSpartan(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary),
              ),
              GestureDetector(
                onTap: () => _showAddNoteSheet(),
                child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_rounded,
                        size: 16, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      'Add',
                      style: GoogleFonts.leagueSpartan(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (patientNotes.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(Icons.note_alt_outlined,
                      size: 36, color: AppColors.textHint),
                  const SizedBox(height: 8),
                  Text(
                    'No notes yet',
                    style: GoogleFonts.leagueSpartan(
                        fontSize: 14, color: AppColors.textMuted),
                  ),
                ],
              ),
            )
          else
            ...patientNotes.map((note) => _buildNoteCard(note)),
        ],
      ),
    );
  }

  Widget _buildNoteCard(DoctorNoteModel note) {
    Color typeColor;
    IconData typeIcon;
    switch (note.type) {
      case 'Assessment':
        typeColor = const Color(0xFFFFB347);
        typeIcon = Icons.assignment_outlined;
        break;
      case 'Discharge':
        typeColor = const Color(0xFF4ECDC4);
        typeIcon = Icons.exit_to_app_rounded;
        break;
      default:
        typeColor = AppColors.primary;
        typeIcon = Icons.trending_up_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: typeColor, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(typeIcon, size: 16, color: typeColor),
              const SizedBox(width: 6),
              Text(
                note.type,
                style: GoogleFonts.leagueSpartan(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: typeColor),
              ),
              const Spacer(),
              Text(
                note.date,
                style: GoogleFonts.leagueSpartan(
                    fontSize: 12, color: AppColors.textHint),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            note.content,
            style: GoogleFonts.leagueSpartan(
                fontSize: 13,
                height: 1.5,
                color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientDocuments() {
    final docs = patient.documents;

    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.folder_outlined, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Patient Documents',
                style: GoogleFonts.leagueSpartan(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${docs.length} file${docs.length == 1 ? '' : 's'}',
                  style: GoogleFonts.leagueSpartan(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (docs.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(Icons.folder_open_rounded, size: 36, color: AppColors.textHint),
                  const SizedBox(height: 8),
                  Text(
                    'No documents uploaded yet',
                    style: GoogleFonts.leagueSpartan(
                        fontSize: 14, color: AppColors.textMuted),
                  ),
                ],
              ),
            )
          else
            ...docs.map((doc) => _buildDocumentCard(doc)),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(MedicalReportModel doc) {
    String dateLabel;
    if (doc.daysAgo == 0) {
      dateLabel = 'Today';
    } else if (doc.daysAgo == 1) {
      dateLabel = 'Yesterday';
    } else {
      final date = DateTime.now().subtract(Duration(days: doc.daysAgo));
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      dateLabel = '${date.day} ${months[date.month - 1]} ${date.year}';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.picture_as_pdf_rounded,
                color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.title,
                  style: GoogleFonts.leagueSpartan(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(height: 3),
                Text(
                  '$dateLabel • ${doc.size}',
                  style: GoogleFonts.leagueSpartan(
                      fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.visibility_outlined,
                color: AppColors.primary, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionBtn(
                icon: Icons.videocam_rounded,
                label: 'Video Session',
                color: const Color(0xFF6C63FF),
                onTap: () => _showVideoSessionDialog(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionBtn(
                icon: Icons.chat_bubble_outline,
                label: 'Message',
                color: const Color(0xFF4ECDC4),
                onTap: () => _showMessageSheet(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: _buildActionBtn(
            icon: Icons.edit_note_rounded,
            label: 'Update Treatment Plan',
            color: AppColors.primary,
            onTap: () => _showTreatmentPlanSheet(),
          ),
        ),
      ],
    );
  }

  Widget _buildActionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.leagueSpartan(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddNoteSheet() {
    String selectedType = 'Progress';
    final noteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40, height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('Add Clinical Note',
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    Text('For ${patient.name}',
                      style: GoogleFonts.leagueSpartan(fontSize: 14, color: AppColors.textMuted)),
                    const SizedBox(height: 20),
                    Text('Note Type', style: GoogleFonts.leagueSpartan(
                      fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(height: 10),
                    Row(
                      children: ['Progress', 'Assessment', 'Discharge'].map((type) {
                        final isSelected = selectedType == type;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setSheetState(() => selectedType = type),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(type, style: GoogleFonts.leagueSpartan(
                                  fontSize: 13, fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.white : AppColors.textMuted)),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: noteController,
                      maxLines: 4,
                      style: GoogleFonts.leagueSpartan(fontSize: 14, color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Write your clinical note...',
                        hintStyle: GoogleFonts.leagueSpartan(fontSize: 14, color: AppColors.textHint),
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (noteController.text.trim().isEmpty) return;
                          setState(() {
                            DoctorMockData.recentNotes.insert(0, DoctorNoteModel(
                              date: 'Just now',
                              patientName: patient.name,
                              content: noteController.text.trim(),
                              type: selectedType,
                            ));
                          });
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('$selectedType note added.')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text('Save Note', style: GoogleFonts.leagueSpartan(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showVideoSessionDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: AppColors.background,
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72, height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.videocam_rounded, color: Color(0xFF6C63FF), size: 36),
                ),
                const SizedBox(height: 20),
                Text('Start Video Session', style: GoogleFonts.leagueSpartan(
                  fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                Text('You are about to start a video call with ${patient.name}.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.leagueSpartan(fontSize: 14, color: AppColors.textMuted)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      final channelName = AgoraService.channelForAppointment(patient.id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WaitingRoomScreen(
                            channelName: channelName,
                            remoteName: patient.name,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.videocam_rounded, size: 20),
                    label: Text('Join Call', style: GoogleFonts.leagueSpartan(
                      fontSize: 16, fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text('Cancel', style: GoogleFonts.leagueSpartan(
                    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMessageSheet() {
    final msgController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              height: MediaQuery.of(ctx).size.height * 0.65,
              padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.surface,
                          child: Text(patient.name[0], style: GoogleFonts.leagueSpartan(
                            fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(patient.name, style: GoogleFonts.leagueSpartan(
                              fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                            Text('Online', style: GoogleFonts.leagueSpartan(
                              fontSize: 12, color: const Color(0xFF4ECDC4))),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: const Icon(Icons.close_rounded, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  Expanded(
                    child: _messages.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.chat_bubble_outline, size: 48, color: AppColors.textHint),
                              const SizedBox(height: 12),
                              Text('No messages yet', style: GoogleFonts.leagueSpartan(
                                fontSize: 14, color: AppColors.textMuted)),
                              Text('Send a message to ${patient.name.split(' ')[0]}',
                                style: GoogleFonts.leagueSpartan(fontSize: 12, color: AppColors.textHint)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _messages.length,
                          itemBuilder: (_, i) {
                            final msg = _messages[i];
                            final isMe = msg['isMe'] as bool;
                            return Align(
                              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                constraints: BoxConstraints(maxWidth: MediaQuery.of(ctx).size.width * 0.65),
                                decoration: BoxDecoration(
                                  color: isMe ? AppColors.primary : AppColors.surface,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(msg['text'] as String, style: GoogleFonts.leagueSpartan(
                                  fontSize: 14, color: isMe ? Colors.white : AppColors.textPrimary)),
                              ),
                            );
                          },
                        ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: AppColors.border)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: msgController,
                            style: GoogleFonts.leagueSpartan(fontSize: 14, color: AppColors.textPrimary),
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: GoogleFonts.leagueSpartan(fontSize: 14, color: AppColors.textHint),
                              filled: true,
                              fillColor: AppColors.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            if (msgController.text.trim().isEmpty) return;
                            setSheetState(() {
                              _messages.add({'text': msgController.text.trim(), 'isMe': true});
                            });
                            msgController.clear();
                            Future.delayed(const Duration(seconds: 1), () {
                              if (ctx.mounted) {
                                setSheetState(() {
                                  _messages.add({
                                    'text': 'Thank you, Dr. Sara. I\'ll follow your advice.',
                                    'isMe': false,
                                  });
                                });
                              }
                            });
                          },
                          child: Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showTreatmentPlanSheet() {
    final diagnosisCtrl = TextEditingController(text: patient.diagnosis);
    final totalCtrl = TextEditingController(text: '${patient.totalSessions}');
    final completedCtrl = TextEditingController(text: '${patient.completedSessions}');
    String selectedStatus = patient.status;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40, height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('Update Treatment Plan', style: GoogleFonts.leagueSpartan(
                      fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    Text('For ${patient.name}', style: GoogleFonts.leagueSpartan(
                      fontSize: 14, color: AppColors.textMuted)),
                    const SizedBox(height: 20),
                    _buildSheetField('Diagnosis', diagnosisCtrl),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(child: _buildSheetField('Total Sessions', totalCtrl, isNumber: true)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildSheetField('Completed', completedCtrl, isNumber: true)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text('Status', style: GoogleFonts.leagueSpartan(
                      fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(height: 10),
                    Row(
                      children: ['Active', 'Needs Attention', 'Discharged'].map((s) {
                        final isSel = selectedStatus == s;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setSheetState(() => selectedStatus = s),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSel ? AppColors.primary : AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(s == 'Needs Attention' ? 'Attention' : s,
                                  style: GoogleFonts.leagueSpartan(fontSize: 12, fontWeight: FontWeight.w600,
                                    color: isSel ? Colors.white : AppColors.textMuted)),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            patient.diagnosis = diagnosisCtrl.text.trim();
                            patient.totalSessions = int.tryParse(totalCtrl.text) ?? patient.totalSessions;
                            patient.completedSessions = int.tryParse(completedCtrl.text) ?? patient.completedSessions;
                            patient.status = selectedStatus;
                          });
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Treatment plan updated.')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text('Save Changes', style: GoogleFonts.leagueSpartan(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSheetField(String label, TextEditingController ctrl, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.leagueSpartan(
          fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: GoogleFonts.leagueSpartan(fontSize: 14, color: AppColors.textPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
