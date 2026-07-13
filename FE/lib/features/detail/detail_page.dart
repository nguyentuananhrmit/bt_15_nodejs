import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:printest_flutter/features/detail/provider/detail_provider.dart';
import 'package:printest_flutter/features/home/models/image_model.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  final int imageId;

  const DetailPage({super.key, required this.imageId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // Chiều cao hiện tại của DraggableScrollableSheet
  double sheetExtent = 0.60;

  // Mốc bắt đầu hiệu ứng
  static const double effectStart = 0.60;

  // Mốc kết thúc hiệu ứng
  static const double effectEnd = 0.90;

  // Tính hiệu ứng đã chạy từ 0.0 đến 1.0
  double get effectProgress {
    final double progress =
        (sheetExtent - effectStart) / (effectEnd - effectStart);

    return progress.clamp(0.0, 1.0);
  }

  // Carousel mờ dần
  double get carouselOpacity {
    return 1 - effectProgress;
  }

  // Header hiện dần
  double get headerProgress {
    return effectProgress;
  }

  @override
  void initState() {
    super.initState();

    // Gọi API lấy chi tiết image theo id
    Future.microtask(() {
      context.read<DetailProvider>().fetchImageById(widget.imageId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    final DetailProvider detailProvider = context.watch<DetailProvider>();

    // Đang tải dữ liệu
    if (detailProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Có lỗi
    if (detailProvider.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Center(child: Text(detailProvider.errorMessage!)),
      );
    }

    final ImageModel? image = detailProvider.image;

    // Không có dữ liệu
    if (image == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: const Center(child: Text("Không có dữ liệu image")),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // ==============================
          // CAROUSEL
          // ==============================
          AnimatedOpacity(
            opacity: carouselOpacity,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            child: CarouselSlider(
              options: CarouselOptions(
                height: 330,
                viewportFraction: 1,
                enableInfiniteScroll: false,
              ),
              items: [
                Image.network(
                  image.imageUrl,
                  width: double.infinity,
                  height: 330,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 330,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),

                // Hai ảnh này chỉ đang dùng để test carousel
                Image.network(
                  "https://a0.muscache.com/im/pictures/hosting/Hosting-1392762478552757642/original/98755745-2b62-42ae-a37d-d664b4f9a2ee.jpeg?im_w=1200",
                  width: double.infinity,
                  height: 330,
                  fit: BoxFit.cover,
                ),

                Image.network(
                  "https://a0.muscache.com/im/pictures/hosting/Hosting-1392762478552757642/original/a5df0d60-d614-4538-aee5-f2cdb6aebca8.jpeg?im_w=720",
                  width: double.infinity,
                  height: 330,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),

          // ==============================
          // NỘI DUNG KÉO LÊN
          // ==============================
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              setState(() {
                sheetExtent = notification.extent;
              });

              debugPrint(
                "sheetExtent hiện tại: "
                "${sheetExtent.toStringAsFixed(2)}",
              );

              return false;
            },
            child: DraggableScrollableSheet(
              initialChildSize: 0.60,
              minChildSize: 0.60,
              maxChildSize: 0.96,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
                    children: [
                      const Center(
                        child: SizedBox(
                          width: 45,
                          child: Divider(thickness: 4, height: 8),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Title lấy từ API
                      Text(
                        image.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Description lấy từ API
                      Text(
                        image.description?.isNotEmpty == true
                            ? image.description!
                            : "Không có mô tả",
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),

                      // Để có khoảng trống kéo thử
                      const SizedBox(height: 500),
                    ],
                  ),
                );
              },
            ),
          ),

          // ==============================
          // HEADER CỐ ĐỊNH
          // ==============================
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: statusBarHeight + 60,
              padding: EdgeInsets.only(top: statusBarHeight),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: headerProgress),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withValues(alpha: 0.25 * headerProgress),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: 1 - headerProgress,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: headerProgress < 1
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: 0.18 * (1 - headerProgress),
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: IconButton(
                        onPressed: () {
                          context.pop();
                        },
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Opacity(
                      opacity: headerProgress,
                      child: Text(
                        image.title,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  // Giúp title nằm chính giữa
                  const SizedBox(width: 52),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
