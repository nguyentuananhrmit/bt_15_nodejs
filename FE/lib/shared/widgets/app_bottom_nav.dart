import 'package:flutter/material.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.pink,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Home'),

        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'đã lưu',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.image_aspect_ratio_outlined),
          label: 'tạo hình',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_2_outlined),
          label: 'Hồ sơ',
        ),
      ],
    );
  }
}
