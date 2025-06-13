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
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: spList.length,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemBuilder: (context, index) {
                        final sp = spList[index];
                        return Container(
                          width: 160,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => chitietsppage(sanPham: sp),
                                ),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.shopping_bag,
                                        size: 50, color: Colors.orange),
                                    const SizedBox(height: 10),
                                    Text(
                                      sp.ten,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '${sp.gia.toStringAsFixed(0)} đ / ${sp.donvi}',
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
