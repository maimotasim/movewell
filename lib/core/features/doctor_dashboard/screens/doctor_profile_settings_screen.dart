import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:movewell/core/theme/colors.dart';
import 'package:movewell/core/widgets/header_background.dart';
import 'package:movewell/core/models/mock_data.dart';
import 'package:movewell/core/features/auth/providers/auth_provider.dart';
import 'package:movewell/core/features/auth/screens/welcome_screen.dart';
import 'package:movewell/core/features/doctor_dashboard/screens/doctor_working_hours_screen.dart';

class DoctorProfileSettingsScreen extends StatelessWidget {
  const DoctorProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doctor = DoctorMockData.currentDoctor;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const HeaderBackground(),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: AppColors.surface,
                                child: const Icon(Icons.person,
                                    size: 60, color: AppColors.primary),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.background, width: 3),
                                ),
                                child: const Icon(Icons.camera_alt_rounded,
                                    color: Colors.white, size: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            doctor.name,
                            style: GoogleFonts.leagueSpartan(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            doctor.title,
                            style: GoogleFonts.leagueSpartan(
                                fontSize: 14, color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.star_rounded,
                                  color: Color(0xFFFFB347), size: 18),
                              const SizedBox(width: 4),
                              Text(
                                '${doctor.rating}',
                                style: GoogleFonts.leagueSpartan(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${doctor.reviews} reviews)',
                                style: GoogleFonts.leagueSpartan(
                                    fontSize: 13, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          Container(
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
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildStatItem(
                                    '${DoctorMockData.patientList.length}',
                                    'Patients',
                                  ),
                                ),
                                Container(
                                    width: 1,
                                    height: 40,
                                    color: AppColors.border),
                                Expanded(
                                  child: _buildStatItem(
                                    '10+',
                                    'Years Exp.',
                                  ),
                                ),
                                Container(
                                    width: 1,
                                    height: 40,
                                    color: AppColors.border),
                                Expanded(
                                  child: _buildStatItem(
                                    '${doctor.reviews}',
                                    'Reviews',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Settings',
                              style: GoogleFonts.leagueSpartan(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildSettingsOption(
                            icon: Icons.schedule_outlined,
                            title: 'Working Hours',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const DoctorWorkingHoursScreen(),
                                ),
                              );
                            },
                          ),
                          _buildSettingsOption(
                            icon: Icons.notifications_outlined,
                            title: 'Notifications',
                            onTap: () {},
                          ),
                          _buildSettingsOption(
                            icon: Icons.lock_outline,
                            title: 'Account & Security',
                            onTap: () {},
                          ),
                          _buildSettingsOption(
                            icon: Icons.language_outlined,
                            title: 'Language (English)',
                            onTap: () {},
                          ),
                          _buildSettingsOption(
                            icon: Icons.help_outline,
                            title: 'Help & Support',
                            onTap: () {},
                          ),
                          const SizedBox(height: 32),

                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () async {
                                await context.read<AuthProvider>().logout();
                                if (!context.mounted) return;
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const WelcomeScreen()),
                                  (route) => false,
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.sos,
                                side: const BorderSide(
                                    color: AppColors.sos, width: 2),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(16)),
                              ),
                              child: Text(
                                'Log Out',
                                style: GoogleFonts.leagueSpartan(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1),
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

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.leagueSpartan(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.leagueSpartan(
              fontSize: 12, color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.leagueSpartan(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary),
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                color: AppColors.textMuted, size: 16),
          ],
        ),
      ),
    );
  }
}
