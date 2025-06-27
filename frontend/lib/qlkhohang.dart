import 'package:flutter/material.dart';
import 'qlkho.dart';
import 'danhsach_phieunhap_page.dart';
import 'api_config.dart';
class NhapHangTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('QUẢN LÝ NHẬP HÀNG', style: TextStyle(color: Colors.white)),
          centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color.fromARGB(255, 171, 161, 73),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black54,
            tabs: [
              Tab(icon: Icon(Icons.upload_file), text: 'Nhập hàng Excel'),
              Tab(icon: Icon(Icons.list_alt), text: 'Danh sách phiếu nhập'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            NhapHangExcelPage(),
            DanhSachPhieuNhapPage(),
          ],
        ),
      ),
    );
  }
}
