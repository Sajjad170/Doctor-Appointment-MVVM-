import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next/ui/Patient/viewmodel/doctor_details_vm.dart';
import '../../model/Doctor.dart';
import 'book_appointment.dart';

class DoctorDetailsPage extends StatelessWidget {
  final Doctor doctor;

  // Inject the ViewModel
  // You can use Get.put for a new instance, or Get.find if it's already registered
  // and you want to retrieve the existing instance.
  // For this scenario, since each DoctorDetailsPage will have a unique doctor,
  // Get.put with a tag or constructor injection is suitable.
  DoctorDetailsPage({super.key, required this.doctor}) {
    Get.put(DoctorDetailsViewModel(doctor: doctor));
  }

  @override
  Widget build(BuildContext context) {
    // Use GetBuilder or Obx if you have observable properties in your ViewModel
    // For this example, since doctor is final and its properties are not changing reactivity,
    // we can directly access it via the ViewModel.
    final DoctorDetailsViewModel viewModel = Get.find<DoctorDetailsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Details"),
        backgroundColor: const Color(0xFF2A7A6A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipOval(
                  child: viewModel.doctor.image != null && viewModel.doctor.image!.isNotEmpty
                      ? Image.network(
                    viewModel.doctor.image!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildImagePlaceholder(),
                  )
                      : _buildImagePlaceholder(),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  viewModel.doctor.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  viewModel.doctor.category,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "About",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                viewModel.doctor.about.isNotEmpty
                    ? viewModel.doctor.about
                    : "No details available about this doctor.",
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Color(0xFF2A7A6A)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "${viewModel.doctor.hospitalName}, ${viewModel.doctor.address}",
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.phone, color: Color(0xFF2A7A6A)),
                  const SizedBox(width: 8),
                  Text(
                    viewModel.doctor.contactNumber,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => BookAppointmentPage(doctor: viewModel.doctor));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A7A6A),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Book Appointment",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.grey[200],
      child: const Icon(
        Icons.person_outline,
        color: Colors.grey,
        size: 60,
      ),
    );
  }
}