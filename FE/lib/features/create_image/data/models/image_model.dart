class ImageModel {
  final int id;
  final String title;
  final String? description;
  final String imageUrl;
  final bool isActive;

  const ImageModel({
    required this.id,
    required this.title,
    this.description,
    required this.imageUrl,
    required this.isActive,
  });

  // Chuyển JSON từ Backend thành ImageModel
  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json["id"] as int,
      title: json["title"]?.toString() ?? "",
      description: json["description"]?.toString(),
      imageUrl: json["image_url"]?.toString() ?? "",
      isActive: json["is_active"] as bool? ?? false,
    );
  }

  // Chuyển ImageModel thành Map để gửi lên Backend khi cần
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "image_url": imageUrl,
      "is_active": isActive,
    };
  }
}
