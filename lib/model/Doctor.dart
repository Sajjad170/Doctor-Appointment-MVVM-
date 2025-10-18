class Doctor {
  final String id;
  final String userId;
  final String name;
  final String category;
  final String? image;
  final String hospitalName;
  final String address;
  final String contactNumber;
  final String about; // New field

  Doctor({
    required this.id,
    required this.userId,
    required this.name,
    required this.category,
    this.image,
    required this.hospitalName,
    required this.address,
    required this.contactNumber,
    required this.about,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'category': category,
      'image': image,
      'hospitalName': hospitalName,
      'address': address,
      'contactNumber': contactNumber,
      'about': about,
    };
  }

  factory Doctor.fromMap(Map<String, dynamic> map, String id) {
    return Doctor(
      id: id,
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      image: map['image'],
      hospitalName: map['hospitalName'] ?? '',
      address: map['address'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      about: map['about'] ?? '',
    );
  }
}