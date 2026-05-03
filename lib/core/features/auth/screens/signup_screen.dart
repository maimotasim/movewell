import 'package:flutter/material.dart';
import 'package:movewell/core/theme/colors.dart';
import 'package:movewell/core/features/dashboard/screens/dashboard_screen.dart';
import 'package:movewell/core/features/doctor_dashboard/screens/doctor_dashboard_screen.dart';
import 'package:movewell/core/widgets/input_field.dart';
import 'package:movewell/core/widgets/primary_button.dart';
import 'package:provider/provider.dart';
import 'package:movewell/core/features/auth/providers/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.day.toString().padLeft(2, '0')} / ${picked.month.toString().padLeft(2, '0')} / ${picked.year}";
      });
    }
  }

  void _handleRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final phone = _phoneController.text.trim();
    final dob = _dobController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
      return;
    }

    final data = {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'dob': dob,
    };

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(data);

    if (success && mounted) {
      final role = context.read<AuthProvider>().userRole;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => role == 'doctor'
              ? const DoctorDashboardScreen()
              : const DashboardScreen(),
        ),
      );
    } else if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Registration failed.'),
          backgroundColor: AppColors.sos,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 18, color: AppColors.primary),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Center(
                    child: Text('New Account',
                      style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w600,
                        color: AppColors.primary)),
                  ),
                ),
                const SizedBox(width: 40),
              ]),
              const SizedBox(height: 28),
              _label('Full name'),
              const SizedBox(height: 8),
              InputField(hint: 'Full name', controller: _nameController),
              const SizedBox(height: 18),
              _label('Password'),
              const SizedBox(height: 8),
              InputField(
                hint: '••••••••••••', isPassword: true, controller: _passwordController),
              const SizedBox(height: 18),
              _label('Email'),
              const SizedBox(height: 8),
              InputField(
                hint: 'example@example.com',
                keyboardType: TextInputType.emailAddress,
                controller: _emailController),
              const SizedBox(height: 18),
              _label('Mobile Number'),
              const SizedBox(height: 8),
              InputField(
                hint: 'Mobile number',
                prefixText: '+20 ',
                keyboardType: TextInputType.phone,
                controller: _phoneController),
              const SizedBox(height: 18),
              _label('Date Of Birth'),
              const SizedBox(height: 8),
              InputField(
                hint: 'DD / MM / YYYY',
                keyboardType: TextInputType.datetime,
                controller: _dobController,
                readOnly: true,
                onTap: _selectDateOfBirth,
              ),
              const SizedBox(height: 24),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 11, color: AppColors.textMuted),
                    children: [
                      TextSpan(text: 'By continuing, you agree to our\n'),
                      TextSpan(text: 'Terms of Use',
                        style: TextStyle(color: AppColors.primary)),
                      TextSpan(text: ' and '),
                      TextSpan(text: 'Privacy Policy',
                        style: TextStyle(color: AppColors.primary)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'Sign Up',
                isLoading: isLoading,
                onPressed: _handleRegister,
              ),
              const SizedBox(height: 24),
              _buildDivider(),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _socialButton('G', Colors.red),
                const SizedBox(width: 16),
                _socialButton('', Colors.black, isApple: true),
              ]),
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 13, color: AppColors.textMuted),
                      children: [
                        TextSpan(text: 'Already have an account? '),
                        TextSpan(text: 'Log in',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) =>
    Text(text, style: const TextStyle(
      fontSize: 13, fontWeight: FontWeight.w500));

  Widget _buildDivider() {
    return Row(children: const [
      Expanded(child: Divider(color: AppColors.border)),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text('or sign up with',
          style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
      ),
      Expanded(child: Divider(color: AppColors.border)),
    ]);
  }

  Widget _socialButton(String label, Color color,
      {bool isApple = false}) {
    return Container(
      width: 52, height: 52,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: isApple
            ? const Icon(Icons.apple, size: 24, color: Colors.black)
            : Text(label,
                style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold,
                  color: color)),
      ),
    );
  }
}
