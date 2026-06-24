import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_routes.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/feed/create_post_screen.dart';
import 'screens/group/group_screen.dart';
import 'screens/profile/profile_screen.dart';

class LacoApp extends StatelessWidget {
  const LacoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laço',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.creme,
        colorScheme: const ColorScheme.light(
          primary: AppColors.azulSuave,
          secondary: AppColors.coralSuave,
          surface: AppColors.brancoPuro,
          error: Colors.redAccent,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, color: AppColors.carvao),
          titleLarge: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, color: AppColors.carvao),
          bodyLarge: TextStyle(fontFamily: 'Inter', color: AppColors.carvao),
          bodyMedium: TextStyle(fontFamily: 'Inter', color: AppColors.carvao),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.carvao,
          ),
          iconTheme: IconThemeData(color: AppColors.carvao),
        ),
      ),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) => const RegisterScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.createPost: (context) => const CreatePostScreen(),
        AppRoutes.group: (context) => const GroupScreen(),
        AppRoutes.profile: (context) => const ProfileScreen(),
      },
    );
  }
}
