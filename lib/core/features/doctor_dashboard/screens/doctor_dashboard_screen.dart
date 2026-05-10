import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movewell/core/theme/colors.dart';
import 'package:movewell/core/widgets/header_background.dart';
import 'package:movewell/core/models/mock_data.dart';
import 'package:movewell/core/features/doctor_dashboard/screens/doctor_patients_screen.dart';
import 'package:movewell/core/features/doctor_dashboard/screens/doctor_patient_detail_screen.dart';
import 'package:movewell/core/features/doctor_dashboard/screens/doctor_schedule_screen.dart';
import 'package:movewell/core/features/doctor_dashboard/screens/doctor_profile_settings_screen.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeContent(context),
          const DoctorPatientsScreen(),
          const DoctorScheduleScreen(),
          const DoctorProfileSettingsScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHomeContent(BuildContext context) {
    return Stack(
      children: [
        const HeaderBackground(),
        SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHeaderTopArea(),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
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
                        _buildGreeting(),
                        const SizedBox(height: 24),
                        _buildStatsRow(),
                        const SizedBox(height: 28),
                        _buildSectionTitle("Today's Agenda"),
                        const SizedBox(height: 16),
                        _buildTodayAgenda(context),
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
    );
  }

  Widget _buildHeaderTopArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.notifications_outlined,
                color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final month = months[now.month - 1];
    final day = now.day;
    String suffix = 'th';
    if (day % 10 == 1 && day != 11) {
      suffix = 'st';
    } else if (day % 10 == 2 && day != 12) {
      suffix = 'nd';
    } else if (day % 10 == 3 && day != 13) {
      suffix = 'rd';
    }
    return '$day$suffix of $month';
  }

  Widget _buildGreeting() {
    final firstName = DoctorMockData.currentDoctor.name.split(' ').first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good Morning, $firstName',
          style: GoogleFonts.leagueSpartan(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          _getFormattedDate(),
          style: GoogleFonts.leagueSpartan(
              color: AppColors.textMuted,
              fontSize: 14,
              fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    final upcomingCount = DoctorMockData.todaySchedule
        .where((s) => s.status != 'Completed')
        .length;
    final pendingCount = DoctorMockData.todaySchedule
        .where((s) => s.status == 'Pending')
        .length;
    final avgAdherence = DoctorMockData.patientList.isEmpty
        ? 0.0
        : DoctorMockData.patientList
                .map((p) => p.adherencePercent)
                .reduce((a, b) => a + b) /
            DoctorMockData.patientList.length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.people_outline,
            value: '$upcomingCount',
            label: 'Upcoming',
            color: const Color(0xFF4ECDC4),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.pending_actions_outlined,
            value: '$pendingCount',
            label: 'Pending',
            color: const Color(0xFFFFB347),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.trending_up_rounded,
            value: '${(avgAdherence * 100).toInt()}%',
            label: 'Adherence',
            color: const Color(0xFF6C63FF),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
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
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.leagueSpartan(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.leagueSpartan(
                fontSize: 12, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayAgenda(BuildContext context) {
    final upcoming = DoctorMockData.todaySchedule
        .where((s) => s.status != 'Completed')
        .take(3)
        .toList();

    if (upcoming.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(Icons.check_circle_outline,
                color: AppColors.primary, size: 48),
            const SizedBox(height: 12),
            Text(
              'All appointments completed!',
              style: GoogleFonts.leagueSpartan(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary),
            ),
          ],
        ),
      );
    }

    return Column(
      children: upcoming.map((slot) {
        return _buildAgendaCard(context, slot);
      }).toList(),
    );
  }

  Widget _buildAgendaCard(BuildContext context, DoctorScheduleSlotModel slot) {
    Color typeColor;
    IconData typeIcon;
    switch (slot.sessionType) {
      case 'Video Call':
        typeColor = const Color(0xFF6C63FF);
        typeIcon = Icons.videocam_rounded;
        break;
      case 'Home Visit':
        typeColor = const Color(0xFF4ECDC4);
        typeIcon = Icons.home_rounded;
        break;
      default:
        typeColor = AppColors.primary;
        typeIcon = Icons.person_rounded;
    }

    Color statusColor;
    switch (slot.status) {
      case 'Pending':
        statusColor = const Color(0xFFFFB347);
        break;
      case 'Completed':
        statusColor = const Color(0xFF4ECDC4);
        break;
      default:
        statusColor = AppColors.primary;
    }

    return GestureDetector(
      onTap: () {
        if (slot.patientId != null) {
          final patient = DoctorMockData.patientList
              .where((p) => p.id == slot.patientId)
              .firstOrNull;
          if (patient != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DoctorPatientDetailScreen(patient: patient),
              ),
            );
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            Container(
              width: 56,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    slot.time.split(' ')[0],
                    style: GoogleFonts.leagueSpartan(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary),
                  ),
                  Text(
                    slot.time.split(' ')[1],
                    style: GoogleFonts.leagueSpartan(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    slot.patientName,
                    style: GoogleFonts.leagueSpartan(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(typeIcon, size: 14, color: typeColor),
                      const SizedBox(width: 4),
                      Text(
                        slot.sessionType,
                        style: GoogleFonts.leagueSpartan(
                            fontSize: 13, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                slot.status,
                style: GoogleFonts.leagueSpartan(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.leagueSpartan(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_outline), label: 'Patients'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined), label: 'Schedule'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
