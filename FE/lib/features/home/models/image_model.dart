class ImageModel {
  final int id;
  final String title;
  final String description;
  final String imageUrl;

  const ImageModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json["id"] as int,
      title: json["title"]?.toString() ?? "",
      description: json["description"]?.toString() ?? "",
      imageUrl: json["image_url"]?.toString() ?? "",
    );
  }
}
