import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'api_config.dart';

class ThongKengay extends StatefulWidget {
  @override
  _ThongKengayState createState() => _ThongKengayState();
}

class _ThongKengayState extends State<ThongKengay> {
  int duTinh = 0;
  int thucTe = 0;
  int huy = 0;
  int choDuyet = 0;
  int daDuyet = 0;
  int dangGiao = 0;

  DateTime? fromDate;
  DateTime? toDate;
  final formatter = DateFormat('dd/MM/yyyy');
  bool isLoading = false;
  String errorMessage = '';
  Timer? _autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    fetchDoanhThu();
    _autoRefreshTimer = Timer.periodic(Duration(minutes: 1), (_) => fetchDoanhThu());
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchDoanhThu() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    String baseUrl = '${ApiConfig.baseUrl}/api/admin/doanhthu';
    String query = '';
    if (fromDate != null && toDate != null) {
      query =
          '?from_date=${DateFormat('yyyy-MM-dd').format(fromDate!)}&to_date=${DateFormat('yyyy-MM-dd').format(toDate!)}';
    }

    try {
      final res = await http.get(Uri.parse('$baseUrl$query'));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          duTinh = int.parse(data['doanhThuDuTinh'].replaceAll('.', ''));
          thucTe = int.parse(data['doanhThuThucTe'].replaceAll('.', ''));
          huy = int.parse(data['donhanghuy'].replaceAll('.', ''));
          choDuyet = int.parse(data['choduyet'].replaceAll('.', ''));
          daDuyet = int.parse(data['daduyet'].replaceAll('.', ''));
          dangGiao = int.parse(data['danggiao'].replaceAll('.', ''));
          isLoading = false;
        });
      } else {
        throw Exception('Lỗi khi tải dữ liệu từ server');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Không thể kết nối đến server. Vui lòng thử lại.';
        isLoading = false;
      });
    }
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: fromDate != null && toDate != null
          ? DateTimeRange(start: fromDate!, end: toDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        fromDate = picked.start;
        toDate = picked.end;
      });
      fetchDoanhThu();
    }
  }

  String formatCurrency(int value) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ', decimalDigits: 0)
        .format(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxValue =
        [duTinh, thucTe, huy, choDuyet, daDuyet, dangGiao].reduce((a, b) => a > b ? a : b);
    final maxY = (maxValue * 1.2).ceilToDouble();

    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red)))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Text('Chọn thời gian:',
                                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                              SizedBox(width: 10),
                              ElevatedButton.icon(
                                onPressed: _pickDateRange,
                                icon: Icon(Icons.calendar_today, size: 18),
                                label: Text(fromDate != null && toDate != null
                                    ? '${formatter.format(fromDate!)} - ${formatter.format(toDate!)}'
                                    : 'Chọn ngày'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent.withOpacity(0.1),
                                  foregroundColor: Colors.blueAccent,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'BIỂU ĐỒ DOANH THU',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              SizedBox(height: 16),
                              SizedBox(
                                height: 300,
                                child: BarChart(
                                  BarChartData(
                                    maxY: maxY,
                                    barGroups: [
                                      _buildBarGroup(0, duTinh.toDouble(), Colors.orange),
                                      _buildBarGroup(1, thucTe.toDouble(), Colors.green),
                                      _buildBarGroup(2, huy.toDouble(), Colors.red),
                                      _buildBarGroup(3, choDuyet.toDouble(), Colors.blueGrey),
                                      _buildBarGroup(4, daDuyet.toDouble(), Colors.blue),
                                      _buildBarGroup(5, dangGiao.toDouble(), Colors.purple),
                                    ],
                                    titlesData: FlTitlesData(
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: (value, meta) {
                                            final titles = [
                                              'Dự tính',
                                              'Thực tế',
                                              'Đơn hủy',
                                              'Chờ duyệt',
                                              'Đã duyệt',
                                              'Đang giao'
                                            ];
                                            return Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(titles[value.toInt()], style: theme.textTheme.bodySmall),
                                            );
                                          },
                                        ),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 60,
                                          getTitlesWidget: (value, meta) => Padding(
                                            padding: const EdgeInsets.only(right: 8),
                                            child: Text(
                                              formatCurrency(value.toInt()),
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ),
                                        ),
                                      ),
                                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    ),
                                    barTouchData: BarTouchData(
                                      enabled: true,
                                      touchTooltipData: BarTouchTooltipData(
                                        tooltipBgColor: Colors.black87,
                                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                          final value = rod.toY.toInt();
                                          return BarTooltipItem(
                                            formatCurrency(value),
                                            TextStyle(color: Colors.white),
                                          );
                                        },
                                      ),
                                    ),
                                    gridData: FlGridData(show: true),
                                    borderData: FlBorderData(show: false),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('CHI TIẾT DOANH THU',
                                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                              SizedBox(height: 16),
                              _buildInfoTile('Doanh thu dự tính:', formatCurrency(duTinh), Icons.trending_up, Colors.orange),
                              _buildInfoTile('Doanh thu thực tế:', formatCurrency(thucTe), Icons.assessment, Colors.green),
                              _buildInfoTile('Đơn đã hủy:', formatCurrency(huy), Icons.cancel, Colors.red),
                              _buildInfoTile('Chờ duyệt:', formatCurrency(choDuyet), Icons.schedule, Colors.blueGrey),
                              _buildInfoTile('Đã duyệt:', formatCurrency(daDuyet), Icons.verified, Colors.blue),
                              _buildInfoTile('Đang giao:', formatCurrency(dangGiao), Icons.local_shipping, Colors.purple),
                              Divider(),
                              _buildInfoTile(
                                'Chênh lệch:',
                                formatCurrency(thucTe - duTinh),
                                thucTe >= duTinh ? Icons.arrow_upward : Icons.arrow_downward,
                                thucTe >= duTinh ? Colors.green : Colors.red,
                              ),
                              _buildInfoTile(
                                'Tỷ lệ đạt được:',
                                duTinh == 0 ? '0%' : '${(thucTe / duTinh * 100).toStringAsFixed(2)}%',
                                Icons.percent,
                                Colors.teal,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 24,
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color),
          SizedBox(width: 8),
          Expanded(child: Text(title)),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
