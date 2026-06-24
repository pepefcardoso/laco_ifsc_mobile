import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    });
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
                Text(
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
