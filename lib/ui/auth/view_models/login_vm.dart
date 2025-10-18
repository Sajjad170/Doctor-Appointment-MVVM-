import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../data/AuthRepository.dart';
import '../../Doctor/DoctorPage.dart';
import '../../Patient/patient.dart';

class LoginViewModel extends GetxController {
  AuthRepository authRepository = Get.find();
  var isLoading = false.obs;

  Future<void> login(String email, String password, {String? role}) async {
    if (!email.contains("@")) {
      Get.snackbar("Error", "Enter proper email");
      return;
    }
    if (password.length < 6) {
      Get.snackbar("Error", "Password must be 6 characters at least");
      return;
    }

    isLoading.value = true;
    try {
      await authRepository.login(email, password);
      final user = authRepository.getLoggedInUser();
      if (user == null) {
        Get.snackbar("Error", "User not found after login");
        return;
      }

      print('User logged in: ${user.email}');

      // Check for specific doctor credentials
      if (email == 'sajjad@gmail.com' && password == '123456') {
        Get.offAll(() => DoctorPage(), binding: DoctorPageBinding());
      } else {
        Get.offAll(() => PatientPage());
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Login failed");
    } catch (e) {
      Get.snackbar("Error", "Unexpected error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  bool isUserLoggedIn() {
    return authRepository.getLoggedInUser() != null;
  }
}