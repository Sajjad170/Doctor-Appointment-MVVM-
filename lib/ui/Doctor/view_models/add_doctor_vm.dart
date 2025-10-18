import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/AuthRepository.dart';
import '../../../data/doctors_repository.dart';
import '../../../data/media_repo.dart';
import '../../../model/Doctor.dart';

class AddDoctorViewModel extends GetxController {
  final AuthRepository authRepository = Get.find();
  final DoctorsRepository doctorsRepository = Get.find();
  final MediaRepository mediaRepository = Get.find();
  var isSaving = false.obs;
  var image = Rxn<XFile>();

  Future<void> addDoctor(String name, String category, String hospitalName, String address, String contactNumber, String about) async {
    if (name.isEmpty) {
      Get.snackbar("Error", "Enter a valid name");
      return;
    }
    if (category.isEmpty) {
      Get.snackbar("Error", "Enter a valid category");
      return;
    }
    if (hospitalName.isEmpty) {
      Get.snackbar("Error", "Enter a valid hospital name");
      return;
    }
    if (address.isEmpty) {
      Get.snackbar("Error", "Enter a valid address");
      return;
    }
    if (contactNumber.isEmpty) {
      Get.snackbar("Error", "Enter a valid contact number");
      return;
    }
    if (about.isEmpty) {
      Get.snackbar("Error", "Enter details about the doctor");
      return;
    }
    isSaving.value = true;
    String? imageUrl;
    if (image.value != null) {
      try {
        final imageResult = await mediaRepository.uploadImage(image.value!.path);
        if (imageResult.isSuccessful) {
          imageUrl = imageResult.secureUrl;
        } else {
          Get.snackbar("Error", imageResult.error ?? "Could not upload image");
          isSaving.value = false;
          return;
        }
      } catch (e) {
        Get.snackbar("Error", "Image upload failed: ${e.toString()}");
        isSaving.value = false;
        return;
      }
    }
    final doctor = Doctor(
      id: '',
      userId: authRepository.getLoggedInUser()?.uid ?? '',
      name: name,
      category: category,
      image: imageUrl,
      hospitalName: hospitalName,
      address: address,
      contactNumber: contactNumber,
      about: about,
    );
    try {
      await doctorsRepository.addDoctor(doctor);
      Get.snackbar("Success", "Doctor saved successfully");
      Get.back();
    } catch (e) {
      Get.snackbar("Error", "An error occurred: ${e.toString()}");
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> updateDoctor(String id, String name, String category, String hospitalName, String address, String contactNumber, String about) async {
    if (name.isEmpty) {
      Get.snackbar("Error", "Enter a valid name");
      return;
    }
    if (category.isEmpty) {
      Get.snackbar("Error", "Enter a valid category");
      return;
    }
    if (hospitalName.isEmpty) {
      Get.snackbar("Error", "Enter a valid hospital name");
      return;
    }
    if (address.isEmpty) {
      Get.snackbar("Error", "Enter a valid address");
      return;
    }
    if (contactNumber.isEmpty) {
      Get.snackbar("Error", "Enter a valid contact number");
      return;
    }
    if (about.isEmpty) {
      Get.snackbar("Error", "Enter details about the doctor");
      return;
    }
    isSaving.value = true;
    String? imageUrl;
    if (image.value != null) {
      try {
        final imageResult = await mediaRepository.uploadImage(image.value!.path);
        if (imageResult.isSuccessful) {
          imageUrl = imageResult.secureUrl;
        } else {
          Get.snackbar("Error", imageResult.error ?? "Could not upload image");
          isSaving.value = false;
          return;
        }
      } catch (e) {
        Get.snackbar("Error", "Image upload failed: ${e.toString()}");
        isSaving.value = false;
        return;
      }
    }
    String? existingImageUrl;
    if (id.isNotEmpty) {
      final existingDoctor = await doctorsRepository.getDoctorById(id);
      if (existingDoctor != null) {
        existingImageUrl = existingDoctor.image;
      }
    }
    final doctor = Doctor(
      id: id,
      userId: authRepository.getLoggedInUser()?.uid ?? '',
      name: name,
      category: category,
      image: imageUrl ?? existingImageUrl,
      hospitalName: hospitalName,
      address: address,
      contactNumber: contactNumber,
      about: about,
    );
    try {
      await doctorsRepository.updateDoctor(doctor);
      Get.snackbar("Success", "Doctor updated successfully");
      Get.back();
    } catch (e) {
      Get.snackbar("Error", "An error occurred: ${e.toString()}");
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteDoctor(String id) async {
    isSaving.value = true;
    try {
      await doctorsRepository.deleteDoctor(id);
      Get.snackbar("Success", "Doctor deleted successfully");
    } catch (e) {
      Get.snackbar("Error", "An error occurred: ${e.toString()}");
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    image.value = await picker.pickImage(source: ImageSource.gallery);
  }
}