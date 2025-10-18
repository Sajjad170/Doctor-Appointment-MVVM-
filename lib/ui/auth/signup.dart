import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next/ui/auth/view_models/signup_vm.dart';
import '../../data/AuthRepository.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpViewModel());
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreeTerms = false;

  static const Color _darkGreen = Color(0xFF2C4B44);
  static const Color _lightGray = Color(0xFFD9D9D9);
  static const double _borderRadius = 50.0;
  static const double _dotSize = 8.0;

  @override
  void initState() {
    super.initState();
    Get.find<SignUpViewModel>();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: _darkGreen,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(40),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: List.generate(
                            3,
                                (index) => Container(
                              width: _dotSize,
                              height: _dotSize,
                              margin: const EdgeInsets.only(right: 6),
                              decoration: const BoxDecoration(
                                color: _lightGray,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const Icon(Icons.close, color: _lightGray, size: 24),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                          fontSize: 32,
                          height: 1.25,
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(text: "Let’s\n"),
                          TextSpan(text: "Create\n", style: TextStyle(fontWeight: FontWeight.w800)),
                          TextSpan(text: "Your\n", style: TextStyle(fontWeight: FontWeight.w800)),
                          TextSpan(text: "Account", style: TextStyle(fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: _darkGreen),
                      decoration: InputDecoration(
                        hintText: "Email Address",
                        hintStyle: TextStyle(color: _darkGreen.withOpacity(0.5)),
                        prefixIcon: const Icon(Icons.email_outlined, color: _darkGreen),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(_borderRadius),
                          borderSide: const BorderSide(color: _darkGreen),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(_borderRadius),
                          borderSide: const BorderSide(color: _darkGreen, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: !_isPasswordVisible,
                      style: const TextStyle(color: _darkGreen),
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(color: _darkGreen.withOpacity(0.5)),
                        prefixIcon: const Icon(Icons.lock_outline, color: _darkGreen),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(_borderRadius),
                          borderSide: const BorderSide(color: _darkGreen),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(_borderRadius),
                          borderSide: const BorderSide(color: _darkGreen, width: 2),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility_off : Icons.remove_red_eye,
                            color: _darkGreen,
                          ),
                          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      style: const TextStyle(color: _darkGreen),
                      decoration: InputDecoration(
                        hintText: "Retype Password",
                        hintStyle: TextStyle(color: _darkGreen.withOpacity(0.5)),
                        prefixIcon: const Icon(Icons.lock_outline, color: _darkGreen),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(_borderRadius),
                          borderSide: const BorderSide(color: _darkGreen),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(_borderRadius),
                          borderSide: const BorderSide(color: _darkGreen, width: 2),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible ? Icons.visibility_off : Icons.remove_red_eye,
                            color: _darkGreen,
                          ),
                          onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: _agreeTerms,
                          activeColor: _darkGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          onChanged: (val) => setState(() => _agreeTerms = val ?? false),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(color: _darkGreen, fontSize: 12, fontWeight: FontWeight.w400),
                              children: [
                                const TextSpan(text: "I agree to the "),
                                TextSpan(
                                  text: "Terms & Privacy",
                                  style: const TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Obx(
                          () => Get.find<SignUpViewModel>().isLoading.value
                          ? const CircularProgressIndicator()
                          : SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _darkGreen,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius)),
                            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                          onPressed: _agreeTerms
                              ? () async {
                            await Get.find<SignUpViewModel>().signup(
                              emailController.text,
                              passwordController.text,
                              confirmPasswordController.text,
                            );
                          }
                              : null,
                          child: const Text("Sign Up"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: _darkGreen, fontSize: 12, fontWeight: FontWeight.w400),
                        children: [
                          const TextSpan(text: "Have an account? "),
                          TextSpan(
                            text: "Sign In",
                            style: const TextStyle(fontWeight: FontWeight.w700),
                            recognizer: TapGestureRecognizer()..onTap = () => Get.back(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}