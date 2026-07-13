import 'package:flutter/material.dart';
import 'package:printest_flutter/features/home/models/image_model.dart';

class CreatedImageCard extends StatelessWidget {
  final ImageModel image;
  final VoidCallback onDelete;

  const CreatedImageCard({
    super.key,
    required this.image,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.network(
                  image.imageUrl,
                  width: double.infinity,
                  height: 260,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 260,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.broken_image_outlined,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),

              // Nút xoá nằm trên góc phải của hình
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: IconButton(
                    onPressed: onDelete,
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            image.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
