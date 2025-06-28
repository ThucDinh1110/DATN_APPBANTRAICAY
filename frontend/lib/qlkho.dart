import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart'; // Bổ sung để dùng Clipboard
import 'api_config.dart';

class NhapHangExcelPage extends StatefulWidget {
  @override
  _NhapHangExcelPageState createState() => _NhapHangExcelPageState();
}

class _NhapHangExcelPageState extends State<NhapHangExcelPage>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> danhSachSanPham = [];
  TextEditingController nhaCungCapController = TextEditingController();
  TextEditingController nguoiNhapController = TextEditingController();
  TextEditingController ghiChuController = TextEditingController();
  bool _isLoading = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    nhaCungCapController.dispose();
    nguoiNhapController.dispose();
    ghiChuController.dispose();
    super.dispose();
  }

  Future<void> chonFileExcel() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        final bytes = result.files.single.bytes!;
        final excel = Excel.decodeBytes(bytes);
        final sheet = excel.tables[excel.tables.keys.first]!;

        final columns = sheet.rows[0]
            .map((e) => e?.value?.toString().trim())
            .toList();

        List<Map<String, dynamic>> data = [];

        for (var row in sheet.rows.skip(1)) {
          final rowData = <String, dynamic>{};
          for (int i = 0; i < columns.length; i++) {
            final key = columns[i];
            final value = row[i]?.value;
            if (key != null) {
              rowData[key] = value?.toString();
            }
          }
          data.add(rowData);
        }

        setState(() {
          danhSachSanPham = data;
        });

        _controller.forward();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã đọc ${data.length} sản phẩm từ Excel'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không chọn file nào'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi đọc file: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> guiApiNhapHang() async {
    if (!_formKey.currentState!.validate()) return;

    if (danhSachSanPham.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng chọn file Excel chứa danh sách sản phẩm'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final body = {
      "Nhacungcap": nhaCungCapController.text,
      "Nguoinhap": nguoiNhapController.text,
      "Ghichu": ghiChuController.text,
      "chitiet": danhSachSanPham,
    };

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/nhaphang'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Thành công", style: TextStyle(color: Colors.green)),
            content: Text(json['message'] ?? 'Nhập hàng thành công'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _formKey.currentState!.reset();
                  setState(() {
                    danhSachSanPham = [];
                    _controller.reset();
                  });
                },
                child: Text('Đóng', style: TextStyle(color: Colors.black)),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Thất bại", style: TextStyle(color: Colors.red)),
            content: Text("Lỗi: ${response.body}"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Đóng', style: TextStyle(color: Colors.black)),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi gửi dữ liệu: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void saoChepDuLieuMau() {
    const sample = '''
SanphamID\tTensp\tDanhmucID\tTendanhmuc\tSoluongnhap\tDongianhap\tDonvi\tHinhanh\tMota\tVitaminA\tVitaminC\tChatxo\tDuong\tTinhbot\tHướng dẫn
11\tDâu Hàn\t1\tTrái Cây Nhập Khẩu\t300\t90000\thộp\tdauhan.jpg\ttaone\t0.015\t58\t2.0\t5.0\t1.2\tNếu là trái cây mới và danh mục mới thì chọn id mới và tên mới
12\tTáo Fuji\t2\tTrái Cây Nội Địa\t150\t70000\tkg\ttao.jpg\tngot mat\t0.012\t60\t2.5\t10.0\t1.0\tNếu nhập trái cây cũ thì chọn đúng id và số lượng muốn nhập
''';
    Clipboard.setData(ClipboardData(text: sample));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Đã sao chép dữ liệu mẫu vào clipboard!"),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: nhaCungCapController,
                      decoration: InputDecoration(
                        labelText: 'Nhà cung cấp',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(Icons.business),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập nhà cung cấp';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: nguoiNhapController,
                      decoration: InputDecoration(
                        labelText: 'Người nhập',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập người nhập';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: ghiChuController,
                      decoration: InputDecoration(
                        labelText: 'Ghi chú',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(Icons.note),
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            //  Nút tạo dữ liệu mẫu
            ElevatedButton.icon(
              onPressed: saoChepDuLieuMau,
              icon: Icon(Icons.copy, color: Colors.white),
              label: Text('Tạo dữ liệu mẫu', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 12),

            // Nút chọn file
            ElevatedButton.icon(
              onPressed: chonFileExcel,
              icon: Icon(Icons.upload_file, color: Colors.white),
              label: Text('Chọn file Excel', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            SizedBox(height: 16),

            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: danhSachSanPham.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.insert_drive_file, size: 64, color: Colors.grey[400]),
                            SizedBox(height: 16),
                            Text("Chưa có dữ liệu", style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                            Text("Vui lòng chọn file Excel để tải dữ liệu", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : FadeTransition(
                        opacity: _fadeAnimation,
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Icon(Icons.list, color: Colors.black),
                                    SizedBox(width: 8),
                                    Text("Danh sách sản phẩm", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    Spacer(),
                                    Chip(
                                      label: Text("${danhSachSanPham.length} sản phẩm", style: TextStyle(color: Colors.white)),
                                      backgroundColor: Colors.blueGrey,
                                    ),
                                  ],
                                ),
                              ),
                              Divider(height: 1),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: danhSachSanPham.length,
                                  itemBuilder: (context, index) {
                                    final sp = danhSachSanPham[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Card(
                                        margin: EdgeInsets.symmetric(vertical: 4),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            child: Text(
                                              '${sp["SanphamID"] ?? "-"}',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          title: Text(
                                            sp["Tensp"] ?? "Không tên",
                                            style: TextStyle(fontWeight: FontWeight.w500),
                                          ),
                                          subtitle: Text("SL: ${sp["Soluongnhap"] ?? "0"} | Giá: ${sp["Dongianhap"] ?? "0"}"),
                                          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
            if (danhSachSanPham.isNotEmpty) ...[
              SizedBox(height: 16),
              ElevatedButton.icon(
                icon: _isLoading
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Icon(Icons.cloud_upload),
                label: Text(_isLoading ? "Đang gửi..." : "Gửi dữ liệu", style: TextStyle(color: Colors.white)),
                onPressed: _isLoading ? null : guiApiNhapHang,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  minimumSize: Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
