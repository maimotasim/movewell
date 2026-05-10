import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movewell/core/theme/colors.dart';
import 'package:movewell/core/models/mock_data.dart';
import 'package:movewell/core/features/doctor_dashboard/screens/doctor_patient_detail_screen.dart';

class DoctorScheduleScreen extends StatefulWidget {
  const DoctorScheduleScreen({super.key});

  @override
  State<DoctorScheduleScreen> createState() => _DoctorScheduleScreenState();
}

class _DoctorScheduleScreenState extends State<DoctorScheduleScreen> {
  int _selectedDayIndex = 2; // "Today" in the middle

  List<Map<String, String>> get _weekDays {
    final now = DateTime.now();
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return List.generate(5, (i) {
      final date = now.add(Duration(days: i - 2));
      return {
        'day': dayNames[date.weekday - 1],
        'date': '${date.day}',
        'label': i == 2 ? 'Today' : (i == 3 ? 'Tomorrow' : ''),
      };
    });
  }

  List<DoctorScheduleSlotModel> get _slotsForSelectedDay {
    if (_selectedDayIndex == 2) {
      return DoctorMockData.todaySchedule;
    }
    return [];
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
              child: Text(
                'Schedule',
                style: GoogleFonts.leagueSpartan(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                '${DoctorMockData.todaySchedule.length} appointments today',
                style: GoogleFonts.leagueSpartan(
                    fontSize: 14, color: AppColors.textMuted),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              height: 95,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _weekDays.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final day = _weekDays[index];
                  final isSelected = index == _selectedDayIndex;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDayIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 64,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.3)
                                : Colors.black.withValues(alpha: 0.04),
                            blurRadius: isSelected ? 12 : 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            day['day']!,
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? Colors.white70
                                  : AppColors.textHint,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            day['date']!,
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                          if (day['label']!.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              day['label']!,
                              style: GoogleFonts.leagueSpartan(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white60
                                    : AppColors.textHint,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: _slotsForSelectedDay.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _slotsForSelectedDay.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 0),
                      itemBuilder: (context, index) {
                        return _buildTimelineSlot(
                          _slotsForSelectedDay[index],
                          isFirst: index == 0,
                          isLast:
                              index == _slotsForSelectedDay.length - 1,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.calendar_today_outlined,
                color: AppColors.primary, size: 36),
          ),
          const SizedBox(height: 16),
          Text(
            'No appointments',
            style: GoogleFonts.leagueSpartan(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'Your schedule is clear for this day',
            style: GoogleFonts.leagueSpartan(
                fontSize: 14, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSlot(
    DoctorScheduleSlotModel slot, {
    bool isFirst = false,
    bool isLast = false,
  }) {
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
    IconData statusIcon;
    switch (slot.status) {
      case 'Completed':
        statusColor = const Color(0xFF4ECDC4);
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'Pending':
        statusColor = const Color(0xFFFFB347);
        statusIcon = Icons.schedule_rounded;
        break;
      case 'Cancelled':
        statusColor = const Color(0xFFFF6B6B);
        statusIcon = Icons.cancel_rounded;
        break;
      default:
        statusColor = AppColors.primary;
        statusIcon = Icons.check_circle_outline;
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
                builder: (_) =>
                    DoctorPatientDetailScreen(patient: patient),
              ),
            );
          }
        }
      },
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 60,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    slot.time.split(' ')[0],
                    style: GoogleFonts.leagueSpartan(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary),
                  ),
                  Text(
                    slot.time.split(' ')[1],
                    style: GoogleFonts.leagueSpartan(
                        fontSize: 11, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 6),
                  Icon(statusIcon, size: 18, color: statusColor),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        color: AppColors.border,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border(
                    left: BorderSide(color: typeColor, width: 3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            slot.patientName,
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
                            color: statusColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
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
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: typeColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(typeIcon, size: 14, color: typeColor),
                              const SizedBox(width: 4),
                              Text(
                                slot.sessionType,
                                style: GoogleFonts.leagueSpartan(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: typeColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
