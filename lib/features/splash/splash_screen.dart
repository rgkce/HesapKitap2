import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/core/services/user_service.dart';
import 'package:hesapkitap/core/models/user_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward();

    // 3 saniye sonra yönlendirme
    Future.delayed(const Duration(seconds: 3), () {
      _navigateToNextScreen();
    });
  }

  void _navigateToNextScreen() {
    final user = UserService().currentUser;

    if (user == null) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      // Redirect based on user role
      switch (user.role) {
        case UserRole.admin:
          Navigator.pushReplacementNamed(context, '/admin_home');
          break;
        case UserRole.manager:
          Navigator.pushReplacementNamed(context, '/manager_home');
          break;
        case UserRole.procurement:
          Navigator.pushReplacementNamed(context, '/procurement_home');
          break;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 2),
        decoration: BoxDecoration(
          color:
              isDark
                  ? AppColors.surfaceDark.withOpacity(0.8)
                  : AppColors.surfaceLight.withOpacity(0.8),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  Container(
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: Image.asset('assets/hk-logo.png', fit: BoxFit.cover),
                  ),
                  SizedBox(height: 20),
                  // App İsmi
                  Text(
                    "HesapKitap",
                    style: AppStyles.heading1.copyWith(
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Slogan
                  Text(
                    "Finansını kolay yönet",
                    style: AppStyles.heading3.copyWith(
                      color: isDark ? AppColors.grey100 : AppColors.grey600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
