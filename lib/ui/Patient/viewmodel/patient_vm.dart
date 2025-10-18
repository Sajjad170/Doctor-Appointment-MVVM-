import 'package:get/get.dart';
import '../../../data/doctors_repository.dart';
import '../../../model/Doctor.dart';
// import '../../model/Doctor.dart'; // Duplicate import, can be removed
import '../doctor_details.dart';
import '../patient_appointments_page.dart';

class PatientPageViewModel extends GetxController {
  // Change DoctorRepository to DoctorsRepository here
  final DoctorsRepository _doctorRepository = Get.find<DoctorsRepository>();

  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var allDoctors = <Doctor>[].obs;
  var doctors = <Doctor>[].obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDoctors();
    ever(searchQuery, (_) => filterDoctors());
  }

  Future<void> fetchDoctors() async {
    try {
      isLoading(true);
      errorMessage('');
      // Also, the method in your DoctorsRepository is getDoctors(), not getAllDoctors()
      final fetchedDoctorsStream = _doctorRepository.getDoctors();
      // To get a Future<List<Doctor>> from a Stream<QuerySnapshot>, you'll need to process it.
      // A common way is to listen to the first emission and map it.
      final querySnapshot = await fetchedDoctorsStream.first;
      final fetchedDoctors = querySnapshot.docs
          .map((doc) => Doctor.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      allDoctors.assignAll(fetchedDoctors);
      doctors.assignAll(fetchedDoctors);
    } catch (e) {
      errorMessage('Failed to load doctors: $e');
      print('Error fetching doctors: $e');
    } finally {
      isLoading(false);
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void filterDoctors() {
    if (searchQuery.isEmpty) {
      doctors.assignAll(allDoctors);
    } else {
      doctors.assignAll(allDoctors.where((doctor) {
        final nameLower = doctor.name.toLowerCase();
        final categoryLower = doctor.category.toLowerCase();
        final searchLower = searchQuery.value.toLowerCase();
        return nameLower.contains(searchLower) ||
            categoryLower.contains(searchLower);
      }).toList());
    }
  }

  void navigateToDoctorDetails(Doctor doctor) {
    Get.to(() => DoctorDetailsPage(doctor: doctor));
  }

  void navigateToAppointments() {
    Get.to(() => PatientAppointmentsPage());
  }
}