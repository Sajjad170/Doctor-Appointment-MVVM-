import 'package:get/get.dart';
import '../../../data/AuthRepository.dart';
import '../../../data/appointments_repository.dart';
import '../../../model/Doctor.dart';

class DoctorDetailsViewModel extends GetxController {
  final Doctor doctor;
  final AuthRepository _authRepository = Get.find();
  final AppointmentsRepository _appointmentsRepository = Get.find();

  DoctorDetailsViewModel({required this.doctor});

  // You can add methods here that might involve the doctor object
  // or interact with the repositories. For example:

  // void favoriteDoctor() {
  //   // Logic to favorite the doctor using _authRepository or another service
  //   update(); // Notify listeners if anything in the UI needs to change
  // }

  // Future<void> checkIfDoctorIsAvailable() async {
  //   // Logic to check doctor availability using _appointmentsRepository
  //   // Update an RxBool to reflect availability in the UI
  // }

  // Example of a computed property if needed
  // bool get hasContactNumber => doctor.contactNumber.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    // Perform any initial setup here, e.g., fetching more details if needed
    // print("DoctorDetailsViewModel initialized for doctor: ${doctor.name}");
  }

  @override
  void onClose() {
    // Clean up resources if necessary
    // print("DoctorDetailsViewModel closed");
    super.onClose();
  }
}