import 'dart:ui';
import 'package:flutter/material.dart';
import 'sanpham.dart';
import 'sanpham_service.dart';
import 'chitietsanpham.dart';

class HomeTabContent extends StatefulWidget {
  final String keyword;
  final Function(bool isScrollingDown)? onScrollDirectionChange;
  

  const HomeTabContent({super.key, required this.keyword, this.onScrollDirectionChange});

  @override
  State<HomeTabContent> createState() => _HomeTabContentState();
}

class _HomeTabContentState extends State<HomeTabContent> {
  late Future<List<SanPham>> _futureSanPhams;
  final ScrollController _scrollController = ScrollController();
  double _lastOffset = 0;
  

  List<String> selectedDanhMucs = [];
  double? minGia;
  double? maxGia;
  Map<String, List<SanPham>> danhMucMap = {};
  final List<String> imageList = [
  'qc1.jpg',
  'qc2.jpg',
  'qc3.jpg',
  'qc4.jpg',
];


  final TextEditingController _minGiaController = TextEditingController();
  final TextEditingController _maxGiaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureSanPhams = SanPhamService.fetchSanPhams();
    _scrollController.addListener(() {
      double current = _scrollController.offset;
      if (current > _lastOffset + 10) {
        widget.onScrollDirectionChange?.call(true);
      } else if (current < _lastOffset - 10) {
        widget.onScrollDirectionChange?.call(false);
      }
      _lastOffset = current;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _minGiaController.dispose();
    _maxGiaController.dispose();
    super.dispose();
  }

  void _showFilterDialog(BuildContext context) {
    final allDanhMucs = danhMucMap.keys.toList();
    final tempSelected = Set<String>.from(selectedDanhMucs);
    double? tempMin = minGia;
    double? tempMax = maxGia;

    _minGiaController.text = tempMin?.toString() ?? '';
    _maxGiaController.text = tempMax?.toString() ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return  AlertDialog(
              backgroundColor: Colors.white.withOpacity(0.95),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text(
                '🔍 Lọc sản phẩm',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Danh mục:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: allDanhMucs.map((dm) {
                        final isSelected = tempSelected.contains(dm);
                        return FilterChip(
                          label: Text(
                            dm,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: Colors.green.shade600,
                          backgroundColor: Colors.grey.shade200,
                          checkmarkColor: Colors.white,
                          onSelected: (selected) {
                            setStateDialog(() {
                              if (selected) {
                                tempSelected.add(dm);
                              } else {
                                tempSelected.remove(dm);
                              }
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: isSelected ? Colors.green.shade700 : Colors.grey.shade400,
                              width: 1.2,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Khoảng giá (VNĐ):',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _minGiaController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Từ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onChanged: (val) => tempMin = double.tryParse(val),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _maxGiaController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Đến',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onChanged: (val) => tempMax = double.tryParse(val),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('❌ Hủy'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedDanhMucs = tempSelected.toList();
                      minGia = tempMin;
                      maxGia = tempMax;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('✅ Lọc'),
                ),
              ],
            );
          },
        );
      },
    );
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

          // Filter by keyword
          if (widget.keyword.isNotEmpty) {
            sanPhams = sanPhams
                .where((sp) => sp.ten.toLowerCase().contains(widget.keyword.toLowerCase()))
                .toList();
          }

          // Filter by selected categories
          if (selectedDanhMucs.isNotEmpty) {
            sanPhams = sanPhams.where((sp) {
              return sp.danhmuc.any((dm) => selectedDanhMucs.contains(dm));
            }).toList();
          }

          // Filter by price range
          if (minGia != null) {
            sanPhams = sanPhams.where((sp) => sp.gia >= minGia!).toList();
          }
          if (maxGia != null) {
            sanPhams = sanPhams.where((sp) => sp.gia <= maxGia!).toList();
          }

          // Show empty state if no products match filters
          if (sanPhams.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               
                const SizedBox(height: 80),
                const Icon(Icons.search_off, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'Không tìm thấy sản phẩm nào.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                if (selectedDanhMucs.isNotEmpty || minGia != null || maxGia != null)
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedDanhMucs.clear();
                        minGia = null;
                        maxGia = null;
                        _minGiaController.clear();
                        _maxGiaController.clear();
                      });
                    },
                    icon: const Icon(Icons.clear),
                    label: const Text('Xóa lọc'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  
              ],
            );
          }

          // Calculate min quantity for "hot" indicator
          int minSoLuong = sanPhams.map((sp) => sp.soluongton).reduce((a, b) => a < b ? a : b);
          
          // Build category map
          danhMucMap.clear();
          for (var sp in sanPhams) {
            for (var dm in sp.danhmuc) {
              danhMucMap.putIfAbsent(dm, () => []).add(sp);
            }
          }

          return ListView(
            controller: _scrollController,
            children: [
              SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: imageList.length,
        itemBuilder: (context, index) {
          return TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 500),
            tween: Tween(begin: 0.8, end: 1),
            curve: Curves.easeOutBack,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: child,
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: Container(
    width: 200,
    height: 140, // Cố định chiều cao
    color: Colors.grey.shade200, // Màu nền khi ảnh đang tải
    child: Image.network(
      'http://127.0.0.1:8000/storage/images/${imageList[index]}',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.broken_image, color: Colors.red),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
    ),
  ),
),


            ),
          );
        },
      ),
    ),
  

              // Filter button
             Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      InkWell(
          onTap: () => _showFilterDialog(context),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6), // trong suốt
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300, width: 1.2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.filter_list, color: Colors.black87, size: 20),
                SizedBox(width: 6),
                Text(
                  "Lọc",
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      
      const SizedBox(width: 12),
     
    ],
  ),

              ),

              // Active filters chips
              if (selectedDanhMucs.isNotEmpty || minGia != null || maxGia != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      ...selectedDanhMucs.map((dm) => Chip(
                        label: Text(dm),
                        backgroundColor: Colors.green.shade100,
                      )),
                      if (minGia != null) Chip(
                        label: Text('Từ ${minGia!.toInt()} VNĐ'),
                        backgroundColor: Colors.blue.shade100,
                      ),
                      if (maxGia != null) Chip(
                        label: Text('Đến ${maxGia!.toInt()} VNĐ'),
                        backgroundColor: Colors.blue.shade100,
                      ),
                      ActionChip(
                        label: const Text('Xóa lọc'),
                        backgroundColor: Colors.red.shade100,
                        onPressed: () {
                          setState(() {
                            selectedDanhMucs.clear();
                            minGia = null;
                            maxGia = null;
                            _minGiaController.clear();
                            _maxGiaController.clear();
                          });
                        },
                      ),
                    ],
                  ),
                ),

              // Products by category
              ...danhMucMap.entries.map((entry) {
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
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromRGBO(95, 179, 249, 1),
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
                                         Image.network(
  'http://127.0.0.1:8000/storage/images/${sp.hinhanh}',
  height: 120,
  width: double.infinity,
  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, color: Colors.red),
),

                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        child: Text(
                                          sp.soluongton == minSoLuong ? '🔥🔥🔥Cháy Hàng' : '🔥Cháy hàng',
                                          style: const TextStyle(
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
              }),
            ],
          );
        }
      },
    );
  }
}