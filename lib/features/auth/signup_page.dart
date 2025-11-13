import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signUp() {
    FocusScope.of(context).unfocus();

    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Tüm alanları doldurun')));
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _isLoading = false);

      // Basit doğrulama: örnek email ve şifre
      if (_emailController.text.trim() == "test@example.com") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email zaten kullanılıyor')),
        );
      } else {
        Navigator.pushReplacementNamed(context, '/roleSelection');
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
                    width: 150,
                    height: 150,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: Image.asset('assets/hk-logo.png', fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "HesapKitap Kayıt",
                    style: AppStyles.heading1.copyWith(
                      color: isDark ? AppColors.secondary : AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // İsim
                  TextField(
                    controller: _nameController,
                    style: AppStyles.buttonText.copyWith(
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                    ),
                    decoration: InputDecoration(
                      hintText: "İsim",
                      hintStyle: AppStyles.buttonText.copyWith(
                        color: isDark ? AppColors.grey400 : AppColors.grey800,
                      ),
                      filled: true,
                      fillColor:
                          isDark
                              ? AppColors.grey800.withOpacity(0.3)
                              : AppColors.textLight.withOpacity(0.8),
                      prefixIcon: Icon(
                        Icons.person,
                        color: isDark ? AppColors.textLight : AppColors.primary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Email
                  TextField(
                    controller: _emailController,
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
                  // Şifre
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
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
                  // Kayıt Butonu
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signUp,
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
                                color: AppColors.textLight,
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
                                    "Kayıt Ol",
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Zaten hesabın var mı? ",
                        style: AppStyles.bodyText.copyWith(
                          color:
                              isDark ? AppColors.grey400 : AppColors.textDark,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Text(
                          "Giriş Yap",
                          style: AppStyles.bodyTextBold.copyWith(
                            color:
                                isDark
                                    ? AppColors.secondary
                                    : AppColors.grey100,
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
