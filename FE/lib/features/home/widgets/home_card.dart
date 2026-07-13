import 'package:flutter/material.dart';

class HomeCard extends StatefulWidget {
  const HomeCard({super.key});

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 350,
        height: 400,
        // color: Colors.redAccent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(16),
              child: Image.network(
                "https://a0.muscache.com/im/pictures/hosting/Hosting-1470103827296390049/original/d3cfbb53-b415-4203-af23-0309d4591d82.jpeg?im_w=1200",
              ),
            ),
            SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.only(left: 8, top: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nhà tại Thành phố Hồ Chí Minh",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    width:
                        300, // giới hạn chiều ngang để nó biết khi nào cần cắt
                    child: Text(
                      "Large studio with kitchen, Landmark81 view, near Metro station",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: 3),
                  Row(
                    children: const [
                      Icon(Icons.star, size: 14, color: Color(0xFFFFB400)),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "5.0 (4) · 1 phòng ngủ · 1 giường · 1 phòng tắm",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6F6F6F),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3),
                  Row(
                    children: [
                      SizedBox(width: 4),
                      Text(
                        "49.286.584 đ",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "cho 5 đêm",
                        style: TextStyle(
                          color: Color(0xFF6F6F6F),
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
