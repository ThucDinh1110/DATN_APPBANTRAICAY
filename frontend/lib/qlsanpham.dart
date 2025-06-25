import 'package:flutter/material.dart';
import 'sanpham.dart';
import 'sanpham_service.dart';
import 'sanphamedit.dart';

class AdminSanPhamPage extends StatefulWidget {
  @override
  _AdminSanPhamPageState createState() => _AdminSanPhamPageState();
}

class _AdminSanPhamPageState extends State<AdminSanPhamPage> {
  late Future<List<SanPham>> _sanPhamFuture;

  @override
  void initState() {
    super.initState();
    _fetchSanPham();
  }

  void _fetchSanPham() {
    _sanPhamFuture = SanPhamService.fetchAllSanPhams();
  }

  Future<void> _editSanPham(SanPham sp) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditSanPhamPage(sanPham: sp)),
    );

    if (result == true) {
      setState(() {
        _fetchSanPham();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý sản phẩm (Admin)', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<SanPham>>(
        future: _sanPhamFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (snapshot.hasError)
            return Center(child: Text('Lỗi: ${snapshot.error}'));

          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return Center(child: Text('Không có sản phẩm.'));

          final sanphams = snapshot.data!;
          return ListView.builder(
            itemCount: sanphams.length,
            itemBuilder: (context, index) {
              final sp = sanphams[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: sp.hinhanh != null && sp.hinhanh!.isNotEmpty
                                ? Image.network(
                                    'http://127.0.0.1:8000/storage/images/${sp.hinhanh}',
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, _, __) => Icon(Icons.broken_image, size: 60),
                                  )
                                : Icon(Icons.image, size: 60),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(sp.ten,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                Text('Giá: ${sp.gia.toStringAsFixed(0)} ${sp.donvi}'),
                                Row(
                                  children: [
                                    Text('Tồn kho: ${sp.soluongton}'),
                                    if (sp.soluongton < 20)
                                      Container(
                                        margin: EdgeInsets.only(left: 8),
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.red[100],
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.warning,
                                                size: 16, color: Colors.red[800]),
                                            SizedBox(width: 4),
                                            Text(
                                              'Cảnh báo: gần hết',
                                              style: TextStyle(
                                                color: Colors.red[800],
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                if (sp.danhmuc.isNotEmpty)
                                  Text('Danh mục: ${sp.danhmuc.join(', ')}'),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editSanPham(sp),
                          ),
                        ],
                      ),
                      if (sp.mota != null && sp.mota!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Mô tả: ${sp.mota}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
