import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'api_config.dart';

class ThongKeTheoThangTab extends StatefulWidget {
  @override
  State<ThongKeTheoThangTab> createState() => _ThongKeTheoThangTabState();
}

class _ThongKeTheoThangTabState extends State<ThongKeTheoThangTab> {
  Map<int, int> doanhThuThucTe = {};
  Map<int, int> doanhThuDuTinh = {};
  int selectedYear = DateTime.now().year;
  bool isLoading = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchDoanhThuThang();
    _timer = Timer.periodic(Duration(minutes: 1), (_) => fetchDoanhThuThang());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchDoanhThuThang() async {
    setState(() => isLoading = true);
    try {
      final res = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/admin/doanhthu-theo-thang?year=$selectedYear'),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['data'];
        Map<int, int> thucTe = {};
        Map<int, int> duTinh = {};

        for (int i = 1; i <= 12; i++) {
          final dt = data['$i'];
          if (dt != null) {
            thucTe[i] = int.parse(dt['thuc_te'].toString().split('.')[0]);
            duTinh[i] = int.parse(dt['du_tinh'].toString().split('.')[0]);
          } else {
            thucTe[i] = 0;
            duTinh[i] = 0;
          }
        }

        setState(() {
          doanhThuThucTe = thucTe;
          doanhThuDuTinh = duTinh;
          isLoading = false;
        });
      }
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthsWithData = List.generate(12, (i) => i + 1)
        .where((m) => (doanhThuThucTe[m] ?? 0) > 0 || (doanhThuDuTinh[m] ?? 0) > 0)
        .toList();

    final maxY = [
      ...monthsWithData.map((m) => doanhThuDuTinh[m] ?? 0),
      ...monthsWithData.map((m) => doanhThuThucTe[m] ?? 0)
    ].fold(0, (a, b) => a > b ? a : b) * 1.2;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Text('Năm: ', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButton<int>(
                value: selectedYear,
                items: List.generate(5, (i) {
                  final y = DateTime.now().year - i;
                  return DropdownMenuItem(value: y, child: Text('$y'));
                }),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedYear = value);
                    fetchDoanhThuThang();
                  }
                },
              ),
            ],
          ),
        ),
        isLoading
            ? CircularProgressIndicator()
            : monthsWithData.isEmpty
                ? Text("Không có dữ liệu doanh thu")
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Biểu đồ doanh thu theo tháng',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                              ),
                              SizedBox(height: 16),
                              SizedBox(
                                height: 250,
                                child: BarChart(
                                  BarChartData(
                                    maxY: maxY.toDouble(),
                                    groupsSpace: 16, // khoảng cách giữa các tháng
                                    barGroups: monthsWithData.map((month) {
                                      return BarChartGroupData(
                                        x: month,
                                        barsSpace: 6, // khoảng cách giữa 2 cột trong 1 tháng
                                        barRods: [
                                          BarChartRodData(
                                            toY: doanhThuDuTinh[month]?.toDouble() ?? 0,
                                            width: 10,
                                            color: Colors.orange,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          BarChartRodData(
                                            toY: doanhThuThucTe[month]?.toDouble() ?? 0,
                                            width: 10,
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                    titlesData: FlTitlesData(
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: (value, _) =>
                                              Text('T${value.toInt()}'),
                                        ),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 60,
                                          getTitlesWidget: (value, _) => Padding(
                                            padding: EdgeInsets.only(right: 8),
                                            child: Text(
                                              NumberFormat.compact(locale: 'vi_VN')
                                                  .format(value),
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ),
                                        ),
                                      ),
                                      topTitles:
                                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      rightTitles:
                                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    ),
                                    barTouchData: BarTouchData(enabled: true),
                                    gridData: FlGridData(show: true),
                                    borderData: FlBorderData(show: false),
                                  ),
                                ),
                              ),
                              Divider(height: 32),
                              Text(
                                'Chi tiết doanh thu theo tháng',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: monthsWithData.length,
                                  itemBuilder: (context, index) {
                                    final month = monthsWithData[index];
                                    final duTinh = doanhThuDuTinh[month] ?? 0;
                                    final thucTe = doanhThuThucTe[month] ?? 0;
                                    return ListTile(
                                      leading: Text('Tháng $month'),
                                      title: Text(
                                        'Dự tính: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ', decimalDigits: 0).format(duTinh)}',
                                        style: TextStyle(color: Colors.orange),
                                      ),
                                      subtitle: Text(
                                        'Thực tế: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ', decimalDigits: 0).format(thucTe)}',
                                        style: TextStyle(color: Colors.green),
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
      ],
    );
  }
}
