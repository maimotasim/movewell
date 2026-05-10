import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movewell/core/theme/colors.dart';
import 'package:movewell/core/models/mock_data.dart';

class DoctorWorkingHoursScreen extends StatefulWidget {
  const DoctorWorkingHoursScreen({super.key});

  @override
  State<DoctorWorkingHoursScreen> createState() =>
      _DoctorWorkingHoursScreenState();
}

class _DoctorWorkingHoursScreenState extends State<DoctorWorkingHoursScreen> {
  static const _allTimeSlots = [
    '08:00 AM',
    '08:30 AM',
    '09:00 AM',
    '09:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '12:30 PM',
    '01:00 PM',
    '01:30 PM',
    '02:00 PM',
    '02:30 PM',
    '03:00 PM',
    '03:30 PM',
    '04:00 PM',
    '04:30 PM',
    '05:00 PM',
    '05:30 PM',
    '06:00 PM',
    '06:30 PM',
    '07:00 PM',
  ];

  static const _dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  late Map<String, Set<String>> _availability;
  late Set<String> _enabledDays;

  @override
  void initState() {
    super.initState();
    _loadCurrentAvailability();
  }

  void _loadCurrentAvailability() {
    _availability = {};
    _enabledDays = {};

    for (final dayData in MockData.aiGeneratedDoctorDates) {
      final day = dayData['day'] as String;
      final times = dayData['times'] as List<String>;
      _enabledDays.add(day);
      _availability[day] = Set<String>.from(times);
    }

    for (final day in _dayNames) {
      _availability.putIfAbsent(day, () => {});
    }
  }

  void _saveAndPop() {
    final now = DateTime.now();
    final List<Map<String, dynamic>> newDates = [];

    int daysGenerated = 0;
    int dayOffset = 0;

    while (daysGenerated < 5 && dayOffset < 14) {
      final date = now.add(Duration(days: dayOffset));
      final dayName = _dayNames[date.weekday - 1];

      if (_enabledDays.contains(dayName) &&
          _availability[dayName]!.isNotEmpty) {
        final sortedTimes = _availability[dayName]!.toList()
          ..sort((a, b) => _timeToMinutes(a).compareTo(_timeToMinutes(b)));

        const months = [
          'January', 'February', 'March', 'April', 'May', 'June',
          'July', 'August', 'September', 'October', 'November', 'December'
        ];

        newDates.add({
          'day': dayName,
          'date': '${date.day}',
          'monthYear': '${months[date.month - 1]} ${date.year}',
          'times': sortedTimes,
        });
        daysGenerated++;
      }
      dayOffset++;
    }

    MockData.aiGeneratedDoctorDates = newDates;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Working hours updated successfully!'),
        backgroundColor: Color(0xFF4ECDC4),
      ),
    );
    Navigator.pop(context);
  }

  int _timeToMinutes(String time) {
    final parts = time.split(' ');
    final hm = parts[0].split(':');
    int hours = int.parse(hm[0]);
    final minutes = int.parse(hm[1]);
    if (parts[1] == 'PM' && hours != 12) hours += 12;
    if (parts[1] == 'AM' && hours == 12) hours = 0;
    return hours * 60 + minutes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppColors.textPrimary, size: 18),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Working Hours',
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _saveAndPop,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Save',
                        style: GoogleFonts.leagueSpartan(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Set your available days and time slots. Patients will only see these when booking.',
                style: GoogleFonts.leagueSpartan(
                    fontSize: 13, color: AppColors.textMuted),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                itemCount: _dayNames.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final day = _dayNames[index];
                  return _buildDayCard(day);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCard(String day) {
    final isEnabled = _enabledDays.contains(day);
    final selectedSlots = _availability[day] ?? {};
    final fullDayName = _fullDayName(day);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isEnabled
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      day,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isEnabled
                            ? AppColors.primary
                            : AppColors.textMuted,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullDayName,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isEnabled
                              ? AppColors.textPrimary
                              : AppColors.textMuted,
                        ),
                      ),
                      Text(
                        isEnabled
                            ? '${selectedSlots.length} slot${selectedSlots.length == 1 ? '' : 's'} selected'
                            : 'Day off',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 12,
                          color: isEnabled
                              ? AppColors.primary
                              : AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: isEnabled,
                  activeTrackColor: AppColors.primary,
                  onChanged: (val) {
                    setState(() {
                      if (val) {
                        _enabledDays.add(day);
                      } else {
                        _enabledDays.remove(day);
                      }
                    });
                  },
                ),
              ],
            ),
          ),

          if (isEnabled) ...[
            const Divider(height: 24, indent: 20, endIndent: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _allTimeSlots.map((time) {
                  final isSelected = selectedSlots.contains(time);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _availability[day]!.remove(time);
                        } else {
                          _availability[day]!.add(time);
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: isSelected
                            ? null
                            : Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        time,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ] else
            const SizedBox(height: 12),
        ],
      ),
    );
  }

  String _fullDayName(String abbr) {
    const map = {
      'Mon': 'Monday',
      'Tue': 'Tuesday',
      'Wed': 'Wednesday',
      'Thu': 'Thursday',
      'Fri': 'Friday',
      'Sat': 'Saturday',
      'Sun': 'Sunday',
    };
    return map[abbr] ?? abbr;
  }
}
