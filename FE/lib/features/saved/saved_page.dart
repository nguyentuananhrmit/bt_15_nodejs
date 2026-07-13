import 'package:flutter/material.dart';
import 'package:printest_flutter/features/saved/created_image_list_page.dart';
import 'package:printest_flutter/features/saved/saved_list_page.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // Có 2 tab: Đã lưu và Đã tạo
      length: 2,

      child: Scaffold(
        backgroundColor: Colors.white,

        body: SafeArea(
          child: Column(
            children: [
              // TAB BAR
              const TabBar(
                tabs: [
                  Tab(text: "Đã lưu"),
                  Tab(text: "Đã tạo"),
                ],
              ),

              // NỘI DUNG CỦA TAB
              Expanded(
                child: TabBarView(
                  children: [SavedListPage(), CreatedImageListPage()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
