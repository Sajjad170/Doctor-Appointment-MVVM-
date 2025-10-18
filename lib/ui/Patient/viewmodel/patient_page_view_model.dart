import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../data/AuthRepository.dart';
import '../../../data/appointments_repository.dart';
import '../../../model/Doctor.dart';
import '../doctor_details.dart';
import '../patient_appointments_page.dart';

class PatientPageViewModel extends GetxController {
  final AuthRepository authRepository = Get.find();
  final AppointmentsRepository appointmentsRepository = Get.find();

  // Reactive variables
  final RxString searchQuery = ''.obs;
  final RxList<Doctor> doctors = <Doctor>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to search query changes and update doctors list
    ever(searchQuery, (_) => fetchDoctors());
    fetchDoctors();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query.trim();
  }

  void fetchDoctors() {
    isLoading.value = true;
    errorMessage.value = '';

    Stream<QuerySnapshot> stream = searchQuery.value.isEmpty
        ? FirebaseFirestore.instance.collection('doctors').snapshots()
        : FirebaseFirestore.instance
        .collection('doctors')
        .where('name', isGreaterThanOrEqualTo: searchQuery.value)
        .where('name', isLessThanOrEqualTo: searchQuery.value + '\uf8ff')
        .snapshots();

    stream.listen(
          (QuerySnapshot snapshot) {
        final doctorList = snapshot.docs
            .map((doc) => Doctor.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
        doctors.assignAll(doctorList);
        isLoading.value = false;
        if (doctorList.isEmpty) {
          errorMessage.value = "No doctors found";
        }
      },
      onError: (error) {
        errorMessage.value = "Error: $error";
        isLoading.value = false;
      },
    );
  }

  void navigateToDoctorDetails(Doctor doctor) {
    Get.to(() => DoctorDetailsPage(doctor: doctor));
  }

  void navigateToAppointments() {
    Get.off(() => PatientAppointmentsPage());
  }
}