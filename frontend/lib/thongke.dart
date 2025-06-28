import 'package:apptraicay/thongkethang.dart';
import 'package:apptraicay/thongkengay.dart'; // Import thống kê theo ngày
import 'package:flutter/material.dart';

class ThongKeDoanhThuPage extends StatefulWidget {
  @override
  _ThongKeDoanhThuPageState createState() => _ThongKeDoanhThuPageState();
}

class _ThongKeDoanhThuPageState extends State<ThongKeDoanhThuPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'THỐNG KÊ DOANH THU',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blueAccent,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.white, // Màu chữ khi được chọn
            unselectedLabelColor: Colors.black, // Màu chữ khi không được chọn
            indicatorColor: Colors.white, // Gạch dưới tab
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'Theo Ngày Tháng'),
              Tab(text: 'Theo Năm'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            ThongKengay(),           // Tab thống kê theo ngày
            ThongKeTheoThangTab(),  // Tab thống kê theo tháng/năm
          ],
        ),
      ),
    );
  }
}
