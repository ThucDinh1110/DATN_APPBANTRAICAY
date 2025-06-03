import 'package:flutter/material.dart';

class ProductItemModel {
  final String productName;
  final int id;
  final double price;
  int quantity;

  ProductItemModel({
    required this.id,
    required this.productName,
    required this.price,
    this.quantity = 1,
  });
}

class Giohang extends StatefulWidget {
  const Giohang({super.key});

  @override
  _GiohangState createState() => _GiohangState();
}

class _GiohangState extends State<Giohang> {
  final TextEditingController tk_sp = TextEditingController();
  List<ProductItemModel> productsInCart = [
    ProductItemModel(id: 1, productName: "Táo", price: 10000, quantity: 2),
    ProductItemModel(id: 2, productName: "Chuối", price: 8000, quantity: 3),
    ProductItemModel(id: 3, productName: "Xoài", price: 15000, quantity: 1),
    ProductItemModel(id: 4, productName: "Mận", price: 12000, quantity: 4),
  ];

  void _removeProduct(int index) {
    setState(() {
      productsInCart.removeAt(index);
    });
  }

  void _updateProductQuantity(int index, int newQuantity) {
    setState(() {
      productsInCart[index].quantity = newQuantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          title: const Text("Giỏ hàng"),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Tìm kiếm + giỏ hàng
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.lightGreen),
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Icon(Icons.search, color: Colors.lightGreen),
                          ),
                          Expanded(
                            child: TextField(
                              controller: tk_sp,
                              decoration: const InputDecoration(
                                hintText: 'Tìm sản phẩm',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart_outlined,
                            color: Colors.lightGreen),
                        onPressed: () {},
                      ),
                      Positioned(
                        right: 0,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${productsInCart.fold(0, (sum, item) => sum + item.quantity)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                color: Colors.white,
                child: const TabBar(
                  isScrollable: true,
                  labelColor: Colors.orange,
                  unselectedLabelColor: Colors.black,
                  indicatorColor: Colors.orange,
                  tabs: [
                    Tab(text: 'Chờ thanh toán'),
                    Tab(text: 'Chờ duyệt'),
                    Tab(text: 'Đã duyệt'),
                    Tab(text: 'Đang giao'),
                    Tab(text: 'Đã mua'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Tab 1: Giỏ hàng
                    Column(
                      children: [
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView.builder(
                            itemCount: productsInCart.length,
                            itemBuilder: (context, index) {
                              final product = productsInCart[index];
                              final backgroundColor = index.isEven
                                  ? Colors.tealAccent
                                  : Colors.lightGreen.shade50;

                              return Dismissible(
                                key: Key(product.productName),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                  _removeProduct(index);
                                },
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: const Icon(Icons.delete,
                                      color: Colors.white),
                                ),
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ListTile(
                                    title: Text(product.productName),
                                    subtitle: Text(
                                        'Giá: ${product.price}đ x ${product.quantity}'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () {
                                            if (product.quantity > 1) {
                                              _updateProductQuantity(index,
                                                  product.quantity - 1);
                                            }
                                          },
                                        ),
                                        Text('${product.quantity}'),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () {
                                            _updateProductQuantity(index,
                                                product.quantity + 1);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text(
                              'Tổng cộng:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${productsInCart.fold<double>(0.0, (sum, item) => sum + item.price * item.quantity)}đ',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.red),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text("Mua tiếp"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (productsInCart.isNotEmpty) {
                                    showDialog(
                                      context: context,
                                      builder: (_) => const AlertDialog(
                                        title: Text("Thanh toán"),
                                        content:
                                            Text("Đã thanh toán thành công!"),
                                      ),
                                    );
                                  }
                                },
                                child: const Text("Thanh toán"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Các tab còn lại
                    const Center(child: Text("Chờ duyệt")),
                    const Center(child: Text("Đã duyệt")),
                    const Center(child: Text("Đang giao")),
                    const Center(child: Text("Đã mua")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
