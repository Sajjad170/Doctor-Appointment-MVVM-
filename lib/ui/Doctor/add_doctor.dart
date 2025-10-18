import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next/data/doctors_repository.dart';
import 'package:next/data/media_repo.dart';
import 'package:next/ui/Doctor/view_models/add_doctor_vm.dart';
import '../../data/AuthRepository.dart';
import '../../model/Doctor.dart';

class AddDoctorBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MediaRepository());
    Get.put(AddDoctorViewModel());
  }
}

class AddDoctor extends StatefulWidget {
  final Doctor? doctor;

  const AddDoctor({super.key, this.doctor});

  @override
  State<AddDoctor> createState() => _AddDoctorPageState();
}

class _AddDoctorPageState extends State<AddDoctor> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController hospitalNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController aboutController = TextEditingController(); // New controller
  late AddDoctorViewModel addDoctorVM;

  @override
  void initState() {
    super.initState();
    addDoctorVM = Get.find();
    if (widget.doctor != null) {
      nameController.text = widget.doctor!.name;
      categoryController.text = widget.doctor!.category;
      hospitalNameController.text = widget.doctor!.hospitalName;
      addressController.text = widget.doctor!.address;
      contactNumberController.text = widget.doctor!.contactNumber;
      aboutController.text = widget.doctor!.about; // Set initial value
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    hospitalNameController.dispose();
    addressController.dispose();
    contactNumberController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doctor == null ? "Add Doctor" : "Edit Doctor"),
        backgroundColor: const Color(0xFF2A7A6A),
      ),
      body: Obx(
            () => addDoctorVM.isSaving.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.doctor == null ? "Add Doctor" : "Edit Doctor",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2A7A6A),
                ),
              ),
              const SizedBox(height: 20),
              addDoctorVM.image.value == null
                  ? const Icon(Icons.image, size: 80)
                  : Image.file(
                File(addDoctorVM.image.value!.path),
                width: 100,
                height: 100,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.error,
                  size: 80,
                  color: Colors.red,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  addDoctorVM.pickImage();
                },
                child: const Text("Pick Image"),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Doctor Name",
                  hintText: "Enter doctor name",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: categoryController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Doctor Category",
                  hintText: "Enter doctor category",
                  prefixIcon: const Icon(Icons.category_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: hospitalNameController,
                decoration: InputDecoration(
                  labelText: "Hospital Name",
                  hintText: "Enter hospital name",
                  prefixIcon: const Icon(Icons.local_hospital),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: "Address",
                  hintText: "Enter hospital address",
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: contactNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Contact Number",
                  hintText: "Enter contact number",
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: aboutController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "About",
                  hintText: "Enter details about the doctor",
                  prefixIcon: const Icon(Icons.info),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.trim().isEmpty) {
                    Get.snackbar("Error", "Please enter a valid doctor name");
                    return;
                  }
                  if (categoryController.text.trim().isEmpty) {
                    Get.snackbar("Error", "Please enter a valid category");
                    return;
                  }
                  if (hospitalNameController.text.trim().isEmpty) {
                    Get.snackbar("Error", "Please enter a hospital name");
                    return;
                  }
                  if (addressController.text.trim().isEmpty) {
                    Get.snackbar("Error", "Please enter an address");
                    return;
                  }
                  if (contactNumberController.text.trim().isEmpty) {
                    Get.snackbar("Error", "Please enter a contact number");
                    return;
                  }
                  if (aboutController.text.trim().isEmpty) {
                    Get.snackbar("Error", "Please enter details about the doctor");
                    return;
                  }
                  if (widget.doctor == null) {
                    addDoctorVM.addDoctor(
                      nameController.text,
                      categoryController.text,
                      hospitalNameController.text,
                      addressController.text,
                      contactNumberController.text,
                      aboutController.text,
                    );
                  } else {
                    addDoctorVM.updateDoctor(
                      widget.doctor!.id,
                      nameController.text,
                      categoryController.text,
                      hospitalNameController.text,
                      addressController.text,
                      contactNumberController.text,
                      aboutController.text,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A7A6A),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  widget.doctor == null ? "Save" : "Update",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}