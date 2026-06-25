import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../providers/auth_provider.dart';

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
    // Wait for at least 2 seconds for the splash screen animation
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authProvider = context.read<AuthProvider>();
    
    // AuthProvider initializes and listens to authStateChanges.
    // If we have a user, it might take a split second to fetch the userModel.
    // We can wait a tiny bit to see if userModel is populated if user is not null.
    if (authProvider.currentUser != null && authProvider.userModel == null) {
      // Small delay to allow the Firestore fetch to complete in AuthProvider constructor
      await Future.delayed(const Duration(milliseconds: 500));
    }

    if (!mounted) return;

    if (authProvider.currentUser == null) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      // User is logged in
      final userModel = authProvider.userModel;
      if (userModel != null && userModel.groupId.isNotEmpty) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.group);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creme,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Connected points illustration simulation
                CustomPaint(
                  size: const Size(120, 120),
                  painter: ConnectionPainter(),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Laço',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.coralSuave,
                    letterSpacing: -1.0,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Quem está longe ainda pode fazer parte do seu dia.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: AppColors.carvao.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
                const Spacer(),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.azulSuave),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConnectionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.azulSuave.withOpacity(0.4)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()..color = AppColors.coralSuave;

    // Draw connection lines
    canvas.drawLine(Offset(size.width * 0.2, size.height * 0.3), Offset(size.width * 0.8, size.height * 0.2), paint);
    canvas.drawLine(Offset(size.width * 0.2, size.height * 0.3), Offset(size.width * 0.5, size.height * 0.7), paint);
    canvas.drawLine(Offset(size.width * 0.8, size.height * 0.2), Offset(size.width * 0.5, size.height * 0.7), paint);

    // Draw dots representing people
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.3), 8.0, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), 8.0, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.7), 10.0, Paint()..color = AppColors.verdeSalvia);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
