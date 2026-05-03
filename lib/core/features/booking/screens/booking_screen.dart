import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movewell/core/theme/colors.dart';
import 'package:movewell/core/widgets/header_background.dart';
import 'package:movewell/core/models/mock_data.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _selectedDateIndex = 0;
  int _selectedTimeIndex = -1;




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
                            'Book an Appointment',
                            style: GoogleFonts.leagueSpartan(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Select an available physical therapy slot.',
                            style: GoogleFonts.leagueSpartan(
                                fontSize: 15,
                                color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 32),
                          
                          Text(
                            MockData.aiGeneratedDoctorDates.isNotEmpty 
                                ? MockData.aiGeneratedDoctorDates[_selectedDateIndex]['monthYear']! 
                                : 'April 2026',
                            style: GoogleFonts.leagueSpartan(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 16),
                          
                          // Horizontal Date Selector
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            clipBehavior: Clip.none,
                            child: Row(
                              children: List.generate(MockData.aiGeneratedDoctorDates.length, (index) {
                                final isSelected = index == _selectedDateIndex;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedDateIndex = index;
                                      _selectedTimeIndex = -1; // reset time selection
                                    });
                                  },
                                  child: Container(
                                    width: 70,
                                    margin: const EdgeInsets.only(right: 12),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.primary : Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.04),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          MockData.aiGeneratedDoctorDates[index]['day']!,
                                          style: GoogleFonts.leagueSpartan(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: isSelected ? Colors.white70 : AppColors.textHint,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          MockData.aiGeneratedDoctorDates[index]['date']!,
                                          style: GoogleFonts.leagueSpartan(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected ? Colors.white : AppColors.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 36),
                          
                          Text(
                            'Available Times',
                            style: GoogleFonts.leagueSpartan(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 16),
                          
                          // Time slots Grid
                          Builder(
                            builder: (context) {
                              final times = MockData.aiGeneratedDoctorDates[_selectedDateIndex]['times'] as List<String>;
                              if (times.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 32),
                                    child: Text(
                                      'Fully Booked',
                                      style: GoogleFonts.leagueSpartan(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              
                              return GridView.builder(
                                shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 2.5,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                                itemCount: times.length,
                                itemBuilder: (context, index) {
                                  final isSelected = index == _selectedTimeIndex;
                                  final timeStr = times[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedTimeIndex = index;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.surface : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: isSelected 
                                        ? Border.all(color: AppColors.primary, width: 1.5)
                                        : Border.all(color: AppColors.border),
                                  ),
                                  child: Text(
                                    timeStr,
                                    style: GoogleFonts.leagueSpartan(
                                      fontSize: 14,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                        const SizedBox(height: 48),
                          
                          // Confirm Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _selectedTimeIndex == -1 ? null : () {
                                final selectedDate = MockData.aiGeneratedDoctorDates[_selectedDateIndex];
                                final times = selectedDate['times'] as List<String>;
                                final timeStr = times[_selectedTimeIndex];
                                final dateStringUI = '${selectedDate['date']} ${selectedDate['monthYear']?.split(' ')[0]} @ $timeStr';
                                
                                MockData.upcomingAppointments.add(
                                  AppointmentModel(
                                    doctor: MockData.primaryDoctor,
                                    dateString: dateStringUI,
                                  ),
                                );
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Appointment Booked Successfully!')),
                                );
                                Navigator.pop(context, true);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                disabledBackgroundColor: AppColors.border,
                                elevation: 0,
                              ),
                              child: Text(
                                'Confirm Booking',
                                style: GoogleFonts.leagueSpartan(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
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
            onTap: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
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
