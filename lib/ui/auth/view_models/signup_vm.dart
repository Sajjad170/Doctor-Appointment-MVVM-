import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../data/AuthRepository.dart';
import '../../Patient/patient.dart';

class SignUpViewModel extends GetxController {
  AuthRepository authRepository = Get.find();
  var isLoading = false.obs;

  Future<void> signup(String email, String password, String confirmPassword) async {
    // Prevent signup with doctor email
    if (email == 'sajjad@gmail.com') {
      Get.snackbar("Error", "This email is reserved for doctor access");
      return;
    }

    // Validate email format
    if (!email.contains("@")) {
      Get.snackbar("Error", "Enter a valid email");
      return;
    }
    // Validate password length
    if (password.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters");
      return;
    }
    // Validate confirm password
    if (password != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    isLoading.value = true;
    try {
      // Create user
      await authRepository.signup(email, password);
      final user = authRepository.getLoggedInUser();
      if (user == null) {
        Get.snackbar("Error", "User not found after signup");
        return;
      }

      // Set patient role and name in Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': email,
        'role': 'patient',
        'name': email.split('@')[0], // Use email prefix as name, or prompt for name
      });

      // Update Firebase Auth display name
      await user.updateDisplayName(email.split('@')[0]);

      print('Signed up user: ${user.email}, UID: ${user.uid}, Role: patient, Name: ${email.split('@')[0]}');

      // Navigate to PatientPage
      Get.offAll(() => PatientPage());
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Signup failed");
    } catch (e) {
      Get.snackbar("Error", "Unexpected error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}