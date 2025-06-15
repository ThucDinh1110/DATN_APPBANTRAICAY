import 'package:flutter/material.dart';
import 'sanpham.dart';
import 'sanpham_service.dart';
import 'chitietsanpham.dart';

class HomeTabContent extends StatefulWidget {
  final String keyword;

  const HomeTabContent({super.key, required this.keyword});

  @override
  State<HomeTabContent> createState() => _HomeTabContentState();
}

class _HomeTabContentState extends State<HomeTabContent> {
  late Future<List<SanPham>> _futureSanPhams;

  @override
  void initState() {
    super.initState();
    _futureSanPhams = SanPhamService.fetchSanPhams();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SanPham>>(
      future: _futureSanPhams,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có sản phẩm nào.'));
        } else {
          List<SanPham> sanPhams = snapshot.data!;

          // ✅ Lọc theo keyword nếu có
          if (widget.keyword.isNotEmpty) {
            sanPhams = sanPhams
                .where((sp) => sp.ten.toLowerCase().contains(widget.keyword.toLowerCase()))
                .toList();
          }

          // ✅ Tìm số lượng tồn nhỏ nhất
          if (sanPhams.isEmpty) {
  return const Center(child: Text('Không tìm thấy sản phẩm nào.'));
}

int minSoLuong = sanPhams.map((sp) => sp.soluongton).reduce((a, b) => a < b ? a : b);


          // ✅ Nhóm sản phẩm theo danh mục
          final Map<String, List<SanPham>> danhMucMap = {};
          for (var sp in sanPhams) {
            for (var dm in sp.danhmuc) {
              danhMucMap.putIfAbsent(dm, () => []).add(sp);
            }
          }

          return ListView(
            children: danhMucMap.entries.map((entry) {
              final tenDanhMuc = entry.key;
              final spList = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text(
                      tenDanhMuc,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: spList.length,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemBuilder: (context, index) {
                        final sp = spList[index];
                        return Container(
                          width: 180,
                          margin: const EdgeInsets.only(right: 12),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => chitietsppage(sanPham: sp),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                Card(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: const BorderSide(color: Colors.grey, width: 0.5),
                                  ),
                                  elevation: 6,
                                  shadowColor: Colors.black12,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Ảnh sản phẩm
                                        Image.asset(
                                          'assets/${sp.hinhanh}',
                                          height: 120,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                        Expanded( // Bọc nội dung trong Expanded
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Đẩy tên lên, giá xuống
                                              children: [
                                                Text(
                                                  sp.ten,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${sp.gia.toStringAsFixed(0)} VNĐ / ${sp.donvi}',
                                                  style: const TextStyle(
                                                    color: Colors.redAccent,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Hiển thị badge nếu số lượng tồn nhỏ hơn 400     
                                if (sp.soluongton < 400)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child:  Text(
                                        sp.soluongton == minSoLuong ? '🔥🔥🔥Cháy Hàng' : '🔥Cháy hàng',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        }
      },
    );
  }
}
