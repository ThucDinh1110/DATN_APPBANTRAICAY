import 'package:flutter/material.dart';

class FruitProduct {
  String name;
  String unit;
  double price;
  String imageUrl;
  String category;
  String description;
  double vitaminA;
  double vitaminC;
  double fiber;
  double sugar;
  double starch;
  String status;
  int quantity;

  FruitProduct({
    required this.name,
    required this.unit,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.description,
    required this.vitaminA,
    required this.vitaminC,
    required this.fiber,
    required this.sugar,
    required this.starch,
    required this.status,
    required this.quantity,
  });
}

class qlsanphamAdmin extends StatefulWidget {
  const qlsanphamAdmin({super.key});

  @override
  State<qlsanphamAdmin> createState() => _qlsanphamAdminState();
}

class _qlsanphamAdminState extends State<qlsanphamAdmin> {
  final List<FruitProduct> products = [
     FruitProduct(
      name: "Táo Mỹ",
      unit: "kg",
      price: 45000,
      imageUrl: "https://upload.wikimedia.org/wikipedia/commons/1/15/Red_Apple.jpg",
      category: "Trái cây nhập khẩu",
      description: "Táo đỏ giòn, ngọt thanh, giàu vitamin C và chất xơ.",
      vitaminA: 54.0,
      vitaminC: 8.4,
      fiber: 2.4,
      sugar: 13.0,
      starch: 5.0,
      status: "Còn hàng",
      quantity: 100,
    ),
    FruitProduct(
      name: "Chuối tiêu",
      unit: "nải",
      price: 30000,
      imageUrl: "https://upload.wikimedia.org/wikipedia/commons/8/8a/Banana-Single.jpg",
      category: "Trái cây trong nước",
      description: "Chuối tiêu chín vàng, ngọt mềm, nhiều vitamin và khoáng chất.",
      vitaminA: 64.0,
      vitaminC: 8.7,
      fiber: 2.6,
      sugar: 12.0,
      starch: 7.0,
      status: "Còn hàng",
      quantity: 200,
    ),
    FruitProduct(
      name: "Xoài cát Hòa Lộc",
      unit: "quả",
      price: 60000,
      imageUrl: "https://upload.wikimedia.org/wikipedia/commons/9/90/Mango_Manila.jpg",
      category: "Trái cây đặc sản",
      description: "Xoài cát chín mọng, thơm ngon đặc trưng miền Tây.",
      vitaminA: 54.0,
      vitaminC: 60.1,
      fiber: 1.6,
      sugar: 14.0,
      starch: 6.0,
      status: "Còn hàng",
      quantity: 150,
    ),
  ];

  

  void _showProductDialog({FruitProduct? product, int? index}) {
    final nameController = TextEditingController(text: product?.name ?? "");
    final unitController = TextEditingController(text: product?.unit ?? "");
    final priceController =
        TextEditingController(text: product?.price.toString() ?? "");
    final imageUrlController =
        TextEditingController(text: product?.imageUrl ?? "");
    final categoryController =
        TextEditingController(text: product?.category ?? "");
    final descriptionController =
        TextEditingController(text: product?.description ?? "");
    final vitaminAController =
        TextEditingController(text: product?.vitaminA.toString() ?? "");
    final vitaminCController =
        TextEditingController(text: product?.vitaminC.toString() ?? "");
    final fiberController =
        TextEditingController(text: product?.fiber.toString() ?? "");
    final sugarController =
        TextEditingController(text: product?.sugar.toString() ?? "");
    final starchController =
        TextEditingController(text: product?.starch.toString() ?? "");
    final statusController =
        TextEditingController(text: product?.status ?? "");
    final quantityController =
        TextEditingController(text: product?.quantity.toString() ?? "");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(product == null ? 'Thêm sản phẩm' : 'Sửa sản phẩm'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Tên")),
              TextField(controller: unitController, decoration: const InputDecoration(labelText: "Đơn vị tính")),
              TextField(controller: priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Giá")),
              TextField(controller: imageUrlController, decoration: const InputDecoration(labelText: "URL hình ảnh")),
              TextField(controller: categoryController, decoration: const InputDecoration(labelText: "Danh mục")),
              TextField(controller: descriptionController, decoration: const InputDecoration(labelText: "Mô tả")),
              TextField(controller: vitaminAController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Vitamin A")),
              TextField(controller: vitaminCController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Vitamin C")),
              TextField(controller: fiberController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Chất xơ")),
              TextField(controller: sugarController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Đường")),
              TextField(controller: starchController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Tinh bột")),
              TextField(controller: statusController, decoration: const InputDecoration(labelText: "Trạng thái")),
              TextField(controller: quantityController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Số lượng")),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () {
              final newProduct = FruitProduct(
                name: nameController.text.trim(),
                unit: unitController.text.trim(),
                price: double.tryParse(priceController.text) ?? 0,
                imageUrl: imageUrlController.text.trim(),
                category: categoryController.text.trim(),
                description: descriptionController.text.trim(),
                vitaminA: double.tryParse(vitaminAController.text) ?? 0,
                vitaminC: double.tryParse(vitaminCController.text) ?? 0,
                fiber: double.tryParse(fiberController.text) ?? 0,
                sugar: double.tryParse(sugarController.text) ?? 0,
                starch: double.tryParse(starchController.text) ?? 0,
                status: statusController.text.trim(),
                quantity: int.tryParse(quantityController.text) ?? 0,
              );

              setState(() {
                if (product != null && index != null) {
                  products[index] = newProduct;
                } else {
                  products.add(newProduct);
                }
              });
              Navigator.pop(context);
            },
            child: Text(product == null ? 'Thêm' : 'Lưu'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(FruitProduct product, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Ảnh trái cây
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: product.imageUrl.isNotEmpty
                  ? Image.network(
                      product.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                    )
                  : const Icon(Icons.image, size: 80, color: Colors.grey),
            ),
            const SizedBox(width: 12),
            // Thông tin sản phẩm
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Đơn vị: ${product.unit} | Giá: ${product.price.toStringAsFixed(0)}đ | SL: ${product.quantity}",
                    style: const TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Danh mục: ${product.category} | Trạng thái: ${product.status}",
                    style: const TextStyle(color: Colors.black54, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 4,
                    children: [
                      _buildInfoChip("Vitamin A", product.vitaminA.toString()),
                      _buildInfoChip("Vitamin C", product.vitaminC.toString()),
                      _buildInfoChip("Chất xơ", product.fiber.toString()),
                      _buildInfoChip("Đường", product.sugar.toString()),
                      _buildInfoChip("Tinh bột", product.starch.toString()),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),
            // Nút sửa xóa
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  tooltip: "Sửa sản phẩm",
                  onPressed: () => _showProductDialog(product: product, index: index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: "Xóa sản phẩm",
                  onPressed: () {
                    setState(() {
                      products.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Chip(
      label: Text("$label: $value"),
      backgroundColor: Colors.green[50],
      labelStyle: const TextStyle(color: Colors.green),
      visualDensity: VisualDensity.compact,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý sản phẩm trái cây"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Thêm sản phẩm mới",
            onPressed: () => _showProductDialog(),
          ),
        ],
      ),
      body: products.isEmpty
          ? const Center(
              child: Text(
                "Chưa có sản phẩm nào",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 6),
              itemCount: products.length,
              itemBuilder: (_, index) => _buildProductCard(products[index], index),
            ),
    );
  }
}
