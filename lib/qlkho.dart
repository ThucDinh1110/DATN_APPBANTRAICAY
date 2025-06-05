import 'package:flutter/material.dart';

class InventoryEntry {
  final String productName;
  final int quantity;
  final DateTime date;

  InventoryEntry(this.productName, this.quantity, this.date);
}

class RevenueEntry {
  final String productName;
  final double revenue;
  final DateTime date;

  RevenueEntry(this.productName, this.revenue, this.date);
}

class qlkhoAdmin extends StatefulWidget {
  const qlkhoAdmin({super.key});

  @override
  State<qlkhoAdmin> createState() => _qlkhoAdminState();
}

class _qlkhoAdminState extends State<qlkhoAdmin> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Dữ liệu nhập hàng
  List<InventoryEntry> _inventoryEntries = [];

  // Dữ liệu doanh thu
  List<RevenueEntry> _revenueEntries = [];

  // Controller form nhập hàng
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  // Controller form doanh thu
  final TextEditingController _revenueProductController = TextEditingController();
  final TextEditingController _revenueAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Demo dữ liệu
    _inventoryEntries = [
      InventoryEntry("Táo Mỹ", 100, DateTime.now().subtract(const Duration(days: 3))),
      InventoryEntry("Chuối tiêu", 200, DateTime.now().subtract(const Duration(days: 1))),
    ];

    _revenueEntries = [
      RevenueEntry("Táo Mỹ", 4500000, DateTime.now().subtract(const Duration(days: 2))),
      RevenueEntry("Chuối tiêu", 6000000, DateTime.now().subtract(const Duration(days: 1))),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    _productNameController.dispose();
    _quantityController.dispose();
    _revenueProductController.dispose();
    _revenueAmountController.dispose();
    super.dispose();
  }

  void _addInventoryEntry() {
    final product = _productNameController.text.trim();
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;

    if (product.isEmpty || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vui lòng nhập đúng tên và số lượng")));
      return;
    }

    setState(() {
      _inventoryEntries.add(InventoryEntry(product, quantity, DateTime.now()));
      _productNameController.clear();
      _quantityController.clear();
    });
  }

  void _addRevenueEntry() {
    final product = _revenueProductController.text.trim();
    final revenue = double.tryParse(_revenueAmountController.text.trim()) ?? 0;

    if (product.isEmpty || revenue <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vui lòng nhập đúng tên và doanh thu")));
      return;
    }

    setState(() {
      _revenueEntries.add(RevenueEntry(product, revenue, DateTime.now()));
      _revenueProductController.clear();
      _revenueAmountController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý kho"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Nhập hàng", icon: Icon(Icons.add_shopping_cart)),
            Tab(text: "Doanh thu", icon: Icon(Icons.attach_money)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInventoryTab(),
          _buildRevenueTab(),
        ],
      ),
    );
  }

  Widget _buildInventoryTab() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(
            controller: _productNameController,
            decoration: const InputDecoration(labelText: "Tên sản phẩm"),
          ),
          TextField(
            controller: _quantityController,
            decoration: const InputDecoration(labelText: "Số lượng"),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _addInventoryEntry,
            child: const Text("Thêm nhập hàng"),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _inventoryEntries.isEmpty
                ? const Center(child: Text("Chưa có dữ liệu nhập hàng"))
                : ListView.builder(
                    itemCount: _inventoryEntries.length,
                    itemBuilder: (context, index) {
                      final item = _inventoryEntries[index];
                      return ListTile(
                        title: Text(item.productName),
                        subtitle: Text("Số lượng: ${item.quantity}"),
                        trailing: Text("${item.date.day}/${item.date.month}/${item.date.year}"),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueTab() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(
            controller: _revenueProductController,
            decoration: const InputDecoration(labelText: "Tên sản phẩm"),
          ),
          TextField(
            controller: _revenueAmountController,
            decoration: const InputDecoration(labelText: "Doanh thu"),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _addRevenueEntry,
            child: const Text("Thêm doanh thu"),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _revenueEntries.isEmpty
                ? const Center(child: Text("Chưa có dữ liệu doanh thu"))
                : ListView.builder(
                    itemCount: _revenueEntries.length,
                    itemBuilder: (context, index) {
                      final item = _revenueEntries[index];
                      return ListTile(
                        title: Text(item.productName),
                        subtitle: Text("Doanh thu: ${item.revenue.toStringAsFixed(0)}đ"),
                        trailing: Text("${item.date.day}/${item.date.month}/${item.date.year}"),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
