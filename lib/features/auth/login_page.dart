import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email ve şifre alanları boş olamaz')),
      );
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _isLoading = false);

      // Basit doğrulama
      if (_emailController.text.trim() == "test@example.com" &&
          _passwordController.text.trim() == "123456") {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email veya şifre yanlış')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient Arka Plan
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    isDark
                        ? [
                          AppColors.grey800,
                          AppColors.primary.withOpacity(0.8),
                        ]
                        : [
                          AppColors.primary.withOpacity(0.8),
                          AppColors.accent.withOpacity(0.8),
                        ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  Container(
                    width: 200,
                    height: 200,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: Image.asset('assets/hk-logo.png', fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "HesapKitap",
                    style: AppStyles.heading1.copyWith(
                      color: isDark ? AppColors.secondary : AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Email
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    style: AppStyles.buttonText.copyWith(
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                    ),
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: AppStyles.buttonText.copyWith(
                        color: isDark ? AppColors.grey400 : AppColors.grey800,
                      ),
                      filled: true,
                      fillColor:
                          isDark
                              ? AppColors.grey800.withOpacity(0.3)
                              : AppColors.textLight.withOpacity(0.8),
                      prefixIcon: Icon(
                        Icons.email,
                        color: isDark ? AppColors.textLight : AppColors.primary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Password
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    autocorrect: false,
                    style: AppStyles.buttonText.copyWith(
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                    ),
                    decoration: InputDecoration(
                      hintText: "Şifre",
                      hintStyle: AppStyles.buttonText.copyWith(
                        color: isDark ? AppColors.grey400 : AppColors.grey800,
                      ),
                      filled: true,
                      fillColor:
                          isDark
                              ? AppColors.grey800.withOpacity(0.3)
                              : Colors.white.withOpacity(0.8),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: isDark ? AppColors.textLight : AppColors.primary,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color:
                              isDark ? AppColors.textLight : AppColors.primary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Login Butonu
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : Ink(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primary,
                                      AppColors.accent,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Giriş Yap",
                                    style: AppStyles.buttonText.copyWith(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text(
                          "Kayıt Ol",
                          style: AppStyles.bodyText.copyWith(
                            color:
                                isDark
                                    ? AppColors.secondary
                                    : AppColors.textLight,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgot_password');
                        },
                        child: Text(
                          "Şifremi Unuttum",
                          style: AppStyles.bodyText.copyWith(
                            color:
                                isDark
                                    ? AppColors.secondary
                                    : AppColors.textLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
