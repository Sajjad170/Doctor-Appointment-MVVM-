import 'package:cloudinary_sdk/cloudinary_sdk.dart';

class MediaRepository {
  late Cloudinary cloudinary;

  MediaRepository() {
    cloudinary = Cloudinary.full(
      apiKey: '234283582753374',
      apiSecret: 'g2nI2R_Ai4CVg25drkHoaCXFlWQ',
      cloudName: 'dfbyxmk6f',
    );
  }

  Future<CloudinaryResponse> uploadImage(String path) async {
    return cloudinary.uploadResource(CloudinaryUploadResource(
      filePath: path,
      resourceType: CloudinaryResourceType.image,
    ));
  }
}
