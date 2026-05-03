import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movewell/core/theme/colors.dart';

class VideoSessionScreen extends StatelessWidget {
  const VideoSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Doctor Video Feed
          Positioned.fill(
            child: Container(
              color: const Color(0xFF1A1A1A),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, size: 50, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Waiting for Dr. Sara Medhat...',
                    style: GoogleFonts.leagueSpartan(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Patient PIP Backend
          Positioned(
            top: MediaQuery.paddingOf(context).top + 20,
            right: 20,
            child: Container(
              width: 100,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 2),
              ),
              child: const Center(
                child: Icon(Icons.person_outline, size: 40, color: Colors.grey),
              ),
            ),
          ),
          
          // Header / Back Button
          Positioned(
            top: MediaQuery.paddingOf(context).top + 20,
            left: 20,
            child: GestureDetector(
              onTap: () {
                if (Navigator.canPop(context)) Navigator.pop(context);
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 20),
              ),
            ),
          ),
          
          // Bottom Controls
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildControlButton(Icons.mic_off_rounded, Colors.black.withValues(alpha: 0.5)),
                const SizedBox(width: 24),
                _buildControlButton(
                  Icons.call_end_rounded, 
                  AppColors.sos, 
                  padding: 20, 
                  iconSize: 32, 
                  onTap: () {
                    if (Navigator.canPop(context)) Navigator.pop(context);
                  }
                ),
                const SizedBox(width: 24),
                _buildControlButton(Icons.videocam_off_rounded, Colors.black.withValues(alpha: 0.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, Color bgColor, {double padding = 16, double iconSize = 24, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: iconSize),
      ),
    );
  }
}
