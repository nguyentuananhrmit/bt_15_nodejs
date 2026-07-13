import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:printest_flutter/features/home/models/image_model.dart';
import 'package:printest_flutter/features/home/providers/images_provider.dart';
import 'package:printest_flutter/features/home/widgets/image_card.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showSearch = true;

  @override
  void initState() {
    super.initState();

    // Khi HomePage vừa mở thì gọi Provider
    // để lấy danh sách image từ Backend
    Future.microtask(() {
      if (!mounted) {
        return;
      }

      context.read<ImagesProvider>().fetchImages();
    });
  }

  void handleScroll(UserScrollNotification notification) {
    // Kéo lên thì ẩn thanh search
    if (notification.direction == ScrollDirection.reverse && showSearch) {
      setState(() {
        showSearch = false;
      });
    }

    // Kéo xuống thì hiện lại thanh search
    if (notification.direction == ScrollDirection.forward && !showSearch) {
      setState(() {
        showSearch = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Theo dõi ImagesProvider
    //
    // Khi fetchImages(), searchImages() hoặc toggleWishlist()
    // gọi notifyListeners(), HomePage sẽ rebuild.
    final ImagesProvider imagesProvider = context.watch<ImagesProvider>();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // =================================================
            // DANH SÁCH IMAGE
            // =================================================
            NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                handleScroll(notification);

                return false;
              },
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(
                  // Có thanh search thì danh sách nằm thấp hơn
                  // Ẩn search thì danh sách kéo lên
                  top: showSearch ? 125 : 50,
                  bottom: 0,
                ),
                child: buildImageList(imagesProvider),
              ),
            ),

            // =================================================
            // THANH SEARCH
            // =================================================
            Positioned(
              top: 44,
              left: 0,
              right: 0,
              child: ClipRect(
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  offset: showSearch ? Offset.zero : const Offset(0, -1),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 80),
                    opacity: showSearch ? 1 : 0,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: TextField(
                        onChanged: (value) {
                          context.read<ImagesProvider>().searchImages(value);
                        },
                        decoration: InputDecoration(
                          hintText: "Tìm kiếm",
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // =================================================
            // NÚT TẤT CẢ HÌNH
            // =================================================
            Positioned(
              top: 3,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  height: 34,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.black, width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      context.read<ImagesProvider>().fetchImages();
                    },
                    child: const Text(
                      "Tất cả hình",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImageList(ImagesProvider imagesProvider) {
    // Đang gọi API lấy danh sách
    if (imagesProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Gọi API thất bại
    if (imagesProvider.errorMessage != null) {
      return Center(
        child: Text(
          imagesProvider.errorMessage!,
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    // Không có image
    if (imagesProvider.images.isEmpty) {
      return const Center(child: Text("Không tìm thấy hình nào"));
    }

    // Render danh sách image
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        for (final ImageModel image in imagesProvider.images) ...[
          // ImageCard sẽ tự:
          // - lấy accessToken từ AuthProvider
          // - gọi toggleWishlist()
          // - đổi icon bookmark
          Center(child: ImageCard(image: image)),

          const SizedBox(height: 20),
        ],
      ],
    );
  }
}
