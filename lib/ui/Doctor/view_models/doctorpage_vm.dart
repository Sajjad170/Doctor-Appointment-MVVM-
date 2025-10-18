import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/Doctor.dart';
import '../add_doctor.dart';
import '../doctor_appointments_page.dart';
import 'add_doctor_vm.dart';

class DoctorPageViewModel extends GetxController {
  final AddDoctorViewModel _addDoctorViewModel = Get.find();
  Rx<List<Doctor>> doctors = Rx<List<Doctor>>([]);
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _listenToDoctors();
  }

  void _listenToDoctors() {
    isLoading.value = true;
    FirebaseFirestore.instance.collection('doctors').snapshots().listen(
          (snapshot) {
        final fetchedDoctors = <Doctor>[];
        for (var doc in snapshot.docs) {
          final doctorData = doc.data();
          final doctor = Doctor.fromMap(doctorData, doc.id);
          fetchedDoctors.add(doctor);
        }
        doctors.value = fetchedDoctors;
        isLoading.value = false;
        errorMessage.value = '';
      },
      onError: (e) {
        errorMessage.value = "Error fetching doctors: $e";
        isLoading.value = false;
      },
    );
  }

  void navigateToAddDoctor({Doctor? doctor}) {
    Get.to(() => AddDoctor(doctor: doctor), binding: AddDoctorBinding());
  }

  void navigateToDoctorAppointments() {
    Get.toNamed('/doctorAppointments'); // Updated to use named route
  }

  Future<void> deleteDoctor(String doctorId) async {
    await _addDoctorViewModel.deleteDoctor(doctorId);
  }

  void showDoctorOptions(BuildContext context, Doctor doctor) {
    Get.dialog(
      AlertDialog(
        title: Text(doctor.name),
        content: const Text("Choose an action:"),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              navigateToAddDoctor(doctor: doctor);
            },
            child: const Text("Edit"),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await deleteDoctor(doctor.id);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
}