import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/group_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _navigating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();

    _checkAuthAndNavigate();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    _navigateOrWait();
  }

  void _navigateOrWait() {
    final authProvider = context.read<AuthProvider>();
    
    if (authProvider.currentUser != null && authProvider.userModel == null) {
      authProvider.addListener(_authListener);
    } else {
      _navigate(authProvider);
    }
  }

  void _authListener() {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.currentUser == null || authProvider.userModel != null) {
      authProvider.removeListener(_authListener);
      _navigate(authProvider);
    }
  }

  Future<void> _navigate(AuthProvider authProvider) async {
    if (_navigating || !mounted) return;
    _navigating = true;

    if (authProvider.currentUser == null) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      final userModel = authProvider.userModel;
      if (userModel != null && userModel.groupId.isNotEmpty) {
        final groupProvider = context.read<GroupProvider>();
        await groupProvider.loadGroup(userModel.groupId);
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
      } else {
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.group);
        }
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
                FadeTransition(
                  opacity: _animation,
                  child: CustomPaint(
                    size: const Size(120, 120),
                    painter: ConnectionPainter(),
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Laço',
                  style: TextStyle(
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

    canvas.drawLine(Offset(size.width * 0.2, size.height * 0.3), Offset(size.width * 0.8, size.height * 0.2), paint);
    canvas.drawLine(Offset(size.width * 0.2, size.height * 0.3), Offset(size.width * 0.5, size.height * 0.7), paint);
    canvas.drawLine(Offset(size.width * 0.8, size.height * 0.2), Offset(size.width * 0.5, size.height * 0.7), paint);

    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.3), 8.0, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), 8.0, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.7), 10.0, Paint()..color = AppColors.verdeSalvia);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
