import 'package:flutter/material.dart';
import 'sanpham.dart';
import 'sanpham_service.dart';
import 'danhmuc_service.dart';

class EditSanPhamPage extends StatefulWidget {
  final SanPham sanPham;

  EditSanPhamPage({required this.sanPham});

  @override
  _EditSanPhamPageState createState() => _EditSanPhamPageState();
}

class _EditSanPhamPageState extends State<EditSanPhamPage> {
  late TextEditingController _idController;
  late TextEditingController _tenController;
  late TextEditingController _giaController;
  late TextEditingController _donviController;
  late TextEditingController _motaController;
  late TextEditingController _vitaminaController;
  late TextEditingController _vitamincController;
  late TextEditingController _chatxoController;
  late TextEditingController _duongController;
  late TextEditingController _tinhbotController;
  late TextEditingController _soluongtonController;
  late TextEditingController _trangthaiController;

  List<Map<String, dynamic>> allDanhmucs = [];
  List<int> selectedDanhmucIds = [];

  @override
  void initState() {
    super.initState();
    final sp = widget.sanPham;
    _idController = TextEditingController(text: sp.id.toString());
    _tenController = TextEditingController(text: sp.ten);
    _giaController = TextEditingController(text: sp.gia.toString());
    _donviController = TextEditingController(text: sp.donvi);
    _motaController = TextEditingController(text: sp.mota ?? '');
    _vitaminaController = TextEditingController(text: sp.vitamina?.toString() ?? '');
    _vitamincController = TextEditingController(text: sp.vitaminc?.toString() ?? '');
    _chatxoController = TextEditingController(text: sp.chatxo?.toString() ?? '');
    _duongController = TextEditingController(text: sp.duong?.toString() ?? '');
    _tinhbotController = TextEditingController(text: sp.tinhbot?.toString() ?? '');
    _soluongtonController = TextEditingController(text: sp.soluongton.toString());
    _trangthaiController = TextEditingController(text: sp.trangthai ? '1' : '0');

    selectedDanhmucIds = sp.danhmuc.map((e) => int.tryParse(e) ?? 0).where((e) => e > 0).toList();
    _fetchDanhmucs();
  }

  Future<void> _fetchDanhmucs() async {
    try {
      final danhMucs = await DanhmucService.fetchDanhmucs();
      setState(() {
        allDanhmucs = danhMucs;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi danh mục: $e')),
      );
    }
  }

  void _toggleDanhmuc(int id) {
    setState(() {
      if (selectedDanhmucIds.contains(id)) {
        selectedDanhmucIds.remove(id);
      } else {
        selectedDanhmucIds.add(id);
      }
    });
  }

  Future<void> _saveChanges() async {
    if (_tenController.text.trim().isEmpty ||
        _giaController.text.trim().isEmpty ||
        _donviController.text.trim().isEmpty ||
        _soluongtonController.text.trim().isEmpty ||
        _trangthaiController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng điền đầy đủ thông tin bắt buộc')),
      );
      return;
    }

    final data = {
      'Tensp': _tenController.text,
      'Gia': double.tryParse(_giaController.text) ?? 0,
      'Donvi': _donviController.text,
      'Trangthai': int.tryParse(_trangthaiController.text) ?? 1,
      'Hinhanh': widget.sanPham.hinhanh,
      'Mota': _motaController.text,
      'VitaminA': double.tryParse(_vitaminaController.text) ?? 0,
      'VitaminC': double.tryParse(_vitamincController.text) ?? 0,
      'Chatxo': double.tryParse(_chatxoController.text) ?? 0,
      'Duong': double.tryParse(_duongController.text) ?? 0,
      'Tinhbot': double.tryParse(_tinhbotController.text) ?? 0,
      'Soluongton': int.tryParse(_soluongtonController.text) ?? 0,
      'Danhmuc': selectedDanhmucIds,
    };

    try {
      await SanPhamService.updateSanPham(widget.sanPham.id, data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã cập nhật thành công')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi cập nhật: $e')),
      );
    }
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800]),
            ),
            SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text, String? hint, bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
    );
  }

  Widget _buildMultiSelectChips() {
    if (allDanhmucs.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: allDanhmucs.map((dm) {
        final id = dm['DanhmucID'];
        final name = dm['Tendanhmuc'];
        final isSelected = selectedDanhmucIds.contains(id);
        return ChoiceChip(
          label: Text(name),
          selected: isSelected,
          selectedColor: Colors.green[300],
          onSelected: (_) => _toggleDanhmuc(id),
          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _tenController.dispose();
    _giaController.dispose();
    _donviController.dispose();
    _motaController.dispose();
    _vitaminaController.dispose();
    _vitamincController.dispose();
    _chatxoController.dispose();
    _duongController.dispose();
    _tinhbotController.dispose();
    _soluongtonController.dispose();
    _trangthaiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa sản phẩm'),
        backgroundColor: Colors.green,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSection('Thông tin cơ bản', [
              _buildTextField('ID', _idController, readOnly: true),
              _buildTextField('Tên sản phẩm', _tenController),
              _buildTextField('Giá', _giaController, type: TextInputType.numberWithOptions(decimal: true), hint: 'VND'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Đường dẫn hình ảnh:', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SelectableText(
                        widget.sanPham.hinhanh ?? 'Không có dữ liệu',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
              _buildTextField('Đơn vị', _donviController, hint: 'kg, gói, hộp...'),
              _buildTextField('Số lượng tồn', _soluongtonController, type: TextInputType.number),
              _buildTextField('Trạng thái', _trangthaiController, type: TextInputType.number, hint: '1: Hiển thị, 0: Ẩn'),
            ]),
            _buildSection('Mô tả sản phẩm', [
              _buildTextField('Mô tả', _motaController, hint: 'Mô tả chi tiết sản phẩm'),
            ]),
            _buildSection('Thông tin dinh dưỡng', [
              _buildTextField('Vitamin A', _vitaminaController, type: TextInputType.number, hint: 'mg/100g'),
              _buildTextField('Vitamin C', _vitamincController, type: TextInputType.number, hint: 'mg/100g'),
              _buildTextField('Chất xơ', _chatxoController, type: TextInputType.number, hint: 'g/100g'),
              _buildTextField('Đường', _duongController, type: TextInputType.number, hint: 'g/100g'),
              _buildTextField('Tinh bột', _tinhbotController, type: TextInputType.number, hint: 'g/100g'),
            ]),
            _buildSection('Danh mục sản phẩm', [
              Text('Chọn danh mục phù hợp:', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              SizedBox(height: 8),
              _buildMultiSelectChips(),
            ]),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveChanges,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('LƯU THAY ĐỔI', style: TextStyle(fontSize: 16)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 2,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
