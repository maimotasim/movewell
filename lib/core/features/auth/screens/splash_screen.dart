import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movewell/core/theme/colors.dart';
import 'package:movewell/core/features/auth/screens/welcome_screen.dart';
import 'package:movewell/core/features/auth/providers/auth_provider.dart';
import 'package:movewell/core/features/dashboard/screens/dashboard_screen.dart';
import 'package:movewell/core/features/doctor_dashboard/screens/doctor_dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // splash logo for at least 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null && token.isNotEmpty) {
      // Load the saved role
      final role = await context.read<AuthProvider>().getSavedRole();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => role == 'doctor'
              ? const DoctorDashboardScreen()
              : const DashboardScreen(),
        ),
      );
    } else {
      // lw mafeesh token proceed to onboarding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/movewell_logo.png',
              height: 120,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            const Text(
              'Recover Better. Move Smarter.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
