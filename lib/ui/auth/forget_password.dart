import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next/ui/auth/view_models/reset_password_vm.dart';
import '../../data/AuthRepository.dart';

class ResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthRepository());
    Get.lazyPut(() => ResetPasswordViewModel());
  }
}

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  static const Color _darkTeal = Color(0xFF2F4F4F);
  static const Color _gradientStart = Color(0xFF3B6B67);
  static const Color _gradientEnd = Color(0xFF2F4F4F);
  static const Color _buttonBg = Color(0xFFA9C6C2);
  static const double _borderRadius = 50.0;
  static const double _dotSize = 9.0;

  @override
  void initState() {
    super.initState();
    Get.find<ResetPasswordViewModel>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              _buildHeader(),
              _buildForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 40),
      child: Column(
        children: [
          _buildHeaderIcons(),
          const SizedBox(height: 24),
          const Icon(Icons.lock, color: _darkTeal, size: 48),
          const SizedBox(height: 24),
          _buildTitleText(),
          const SizedBox(height: 12),
          _buildSubtitleText(),
        ],
      ),
    );
  }

  Widget _buildHeaderIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: List.generate(
            3,
                (index) => Container(
              margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
              width: _dotSize,
              height: _dotSize,
              decoration: const BoxDecoration(
                color: _darkTeal,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.close, color: _darkTeal, size: 28),
        ),
      ],
    );
  }

  Widget _buildTitleText() {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        style: TextStyle(
          color: _darkTeal,
          fontFamily: 'Montserrat',
        ),
        children: [
          TextSpan(
            text: 'Forgot\n',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 28,
              height: 1.1,
            ),
          ),
          TextSpan(
            text: 'Password?',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 24,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitleText() {
    return const Text(
      "No worries, we’ll send you\nreset instructions",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: _darkTeal,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
    );
  }

  Widget _buildForm() {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_gradientStart, _gradientEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmailField(),
            const SizedBox(height: 24),
            _buildResetButton(),
            const SizedBox(height: 24),
            _buildBackToLoginLink(),
            const SizedBox(height: 24),
            _buildBackArrowButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Email",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              icon: const Icon(Icons.email_outlined, color: Colors.white, size: 20),
              hintText: "Enter your Email",
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResetButton() {
    final viewModel = Get.find<ResetPasswordViewModel>();
    return Obx(
          () => viewModel.isLoading.value
          ? const Center(child: CircularProgressIndicator(color: _darkTeal))
          : SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            try {
              await viewModel.reset(_emailController.text);
              if (mounted) {
                Get.snackbar(
                  'Success',
                  'Reset instructions sent to ${_emailController.text}',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: _darkTeal,
                  colorText: Colors.white,
                );
              }
            } catch (e) {
              if (mounted) {
                Get.snackbar(
                  'Error',
                  'Failed to send reset instructions: $e',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _buttonBg,
            foregroundColor: _darkTeal,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius)),
            padding: const EdgeInsets.symmetric(vertical: 14),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          child: const Text("Reset Password"),
        ),
      ),
    );
  }

  Widget _buildBackToLoginLink() {
    return Center(
      child: GestureDetector(
        onTap: () => Get.back(),
        child: const Text(
          "Back to Login",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildBackArrowButton() {
    return Center(
      child: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}