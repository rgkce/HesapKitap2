import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendPasswordReset() {
    FocusScope.of(context).unfocus();

    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Email alanı boş olamaz')));
      return;
    }

    setState(() => _isLoading = true);

    // Basit simülasyon: 1 saniye sonra başarılı mesaj
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Şifre sıfırlama linki email adresinize gönderildi'),
        ),
      );

      Navigator.pop(context); // İşlem sonrası login sayfasına dön
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
                    "Şifremi Unuttum",
                    style: AppStyles.heading1.copyWith(
                      color: isDark ? AppColors.secondary : AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Email Input
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
                  const SizedBox(height: 30),
                  // Gönder Butonu
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _sendPasswordReset,
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
                                    "Şifre Sıfırlama Linki Gönder",
                                    textAlign: TextAlign.center,
                                    style: AppStyles.buttonText.copyWith(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Geri Dön",
                      style: AppStyles.bodyTextBold.copyWith(
                        color:
                            isDark ? AppColors.secondary : AppColors.textLight,
                      ),
                    ),
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
