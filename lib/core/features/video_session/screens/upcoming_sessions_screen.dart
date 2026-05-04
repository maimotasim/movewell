import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movewell/core/theme/colors.dart';
import 'package:movewell/core/widgets/header_background.dart';
import 'package:movewell/core/features/booking/screens/booking_screen.dart';
import 'package:movewell/core/features/video_session/screens/waiting_room_screen.dart';
import 'package:movewell/core/models/mock_data.dart';
import 'package:movewell/core/services/agora_service.dart';

class UpcomingSessionsScreen extends StatefulWidget {
  const UpcomingSessionsScreen({super.key});

  @override
  State<UpcomingSessionsScreen> createState() => _UpcomingSessionsScreenState();
}

class _UpcomingSessionsScreenState extends State<UpcomingSessionsScreen> {
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Upcoming Sessions',
                                  style: GoogleFonts.leagueSpartan(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const BookingScreen()),
                                  );
                                  if (result == true) {
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.add_rounded, color: AppColors.primary, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Book New',
                                        style: GoogleFonts.leagueSpartan(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          if (MockData.upcomingAppointments.isEmpty)
                             Center(
                               child: Padding(
                                 padding: const EdgeInsets.symmetric(vertical: 48),
                                 child: Column(
                                   children: [
                                     Container(
                                       padding: const EdgeInsets.all(24),
                                       decoration: const BoxDecoration(
                                         color: AppColors.surface,
                                         shape: BoxShape.circle,
                                       ),
                                       child: const Icon(Icons.event_busy_rounded, size: 48, color: AppColors.textHint),
                                     ),
                                     const SizedBox(height: 24),
                                     Text(
                                       "No sessions booked",
                                       style: GoogleFonts.leagueSpartan(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                       ),
                                     ),
                                     const SizedBox(height: 8),
                                     Text(
                                       "Tap 'Book New' to schedule a physical therapy session.",
                                       style: GoogleFonts.leagueSpartan(
                                          color: AppColors.textMuted,
                                          fontSize: 14,
                                       ),
                                       textAlign: TextAlign.center,
                                     ),
                                   ],
                                 ),
                               ),
                             )
                          else
                            ...MockData.upcomingAppointments.map((appointment) => _buildSessionCard(appointment)),
                          
                          const SizedBox(height: 100), // scroll area
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

  Widget _buildSessionCard(AppointmentModel appointment) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
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
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.video_camera_front_rounded, color: AppColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.doctor.name,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appointment.dateString,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 14,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final channelName = AgoraService.channelForAppointment(appointment.id);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WaitingRoomScreen(
                      channelName: channelName,
                      remoteName: appointment.doctor.name,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                'Enter Waiting Room',
                style: GoogleFonts.leagueSpartan(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
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

