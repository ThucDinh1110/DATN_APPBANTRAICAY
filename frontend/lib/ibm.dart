import 'package:flutter/material.dart';

class ibm extends StatefulWidget {
  final String chieucao;
  final String cannang;
  final Function(String chieucao, String cannang) onSave;

  const ibm({
    Key? key,
    required this.chieucao,
    required this.cannang,
    required this.onSave,
  }) : super(key: key);

  @override
  State<ibm> createState() => _ibmState();
}

class _ibmState extends State<ibm> with SingleTickerProviderStateMixin {
  late TextEditingController _chieucaoController;
  late TextEditingController _cannangController;
  double? _bmi;
  String _bmiCategory = "";
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _chieucaoController = TextEditingController(text: widget.chieucao);
    _cannangController = TextEditingController(text: widget.cannang);

    _chieucaoController.addListener(_calculateBMI);
    _cannangController.addListener(_calculateBMI);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateBMI(); // Tính lần đầu nếu có sẵn dữ liệu
    });
  }

  @override
  void dispose() {
    _chieucaoController.dispose();
    _cannangController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _calculateBMI() {
    final double? chieucao = double.tryParse(_chieucaoController.text.trim());
    final double? cannang = double.tryParse(_cannangController.text.trim());

    if (chieucao == null || cannang == null || chieucao <= 0 || cannang <= 0) {
      setState(() {
        _bmi = null;
        _bmiCategory = "";
      });
      return;
    }

    final chieucaoM = chieucao / 100;
    final bmi = cannang / (chieucaoM * chieucaoM);
    final newBmi = double.parse(bmi.toStringAsFixed(1));

    if (newBmi != _bmi) {
      setState(() {
        _bmi = newBmi;
        if (_bmi! < 18.5) {
          _bmiCategory = "Gầy";
        } else if (_bmi! < 24.9) {
          _bmiCategory = "Bình thường";
        } else if (_bmi! < 29.9) {
          _bmiCategory = "Thừa cân";
        } else {
          _bmiCategory = "Béo phì";
        }
      });

      widget.onSave(_chieucaoController.text.trim(), _cannangController.text.trim());
      _animationController.reset();
      _animationController.forward();
    }
  }

  Color _getBMIColor() {
    if (_bmi == null) return Colors.grey;
    if (_bmi! < 18.5) return const Color(0xFF2196F3);
    if (_bmi! < 24.9) return const Color(0xFF4CAF50);
    if (_bmi! < 29.9) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }

  Expanded _buildScaleSegment(Color color, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Container(
        height: 24,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ),
    );
  }

  Widget _buildBMIScale(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double markerPos = _bmi != null
            ? ((_bmi!.clamp(10, 40) - 10) / 30) * constraints.maxWidth
            : 0;

        return Column(
          children: [
            Stack(
              children: [
                Row(
                  children: [
                    _buildScaleSegment(const Color(0xFF2196F3), flex: 5),
                    _buildScaleSegment(const Color(0xFF4CAF50), flex: 6),
                    _buildScaleSegment(const Color(0xFFFF9800), flex: 5),
                    _buildScaleSegment(const Color(0xFFF44336), flex: 4),
                  ],
                ),
                if (_bmi != null)
                  Positioned(
                    left: markerPos - 15,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _bmi!.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down, color: Colors.black, size: 30),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("<18.5", style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text("18.5-24.9", style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text("25-29.9", style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text("≥30", style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildResultCard() {
    return ScaleTransition(
      scale: _animation,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "KẾT QUẢ BMI",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: _getBMIColor().withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: _getBMIColor(), width: 4),
                ),
                child: Center(
                  child: Text(
                    _bmi!.toString(),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: _getBMIColor(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _bmiCategory,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _getBMIColor(),
                ),
              ),
              const SizedBox(height: 16),
              _buildBMIScale(context),
              const SizedBox(height: 16),
              const Text(
                "Chỉ số BMI từ 18.5 đến 24.9 là lý tưởng cho sức khỏe",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("TÍNH CHỈ SỐ BMI", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF4A90E2),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      "NHẬP THÔNG TIN CỦA BẠN",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A90E2),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _chieucaoController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Chiều cao (cm)",
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.height, color: Colors.blueGrey),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _cannangController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Cân nặng (kg)",
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.scale, color: Colors.blueGrey),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_bmi != null) _buildResultCard(),
            const SizedBox(height: 20),
            const Card(
              elevation: 4,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Giải thích về BMI",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A90E2),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "• Dưới 18.5: Gầy - Bạn nên tăng cân để đạt mức BMI lý tưởng\n"
                      "• 18.5-24.9: Bình thường - Duy trì chế độ ăn và tập luyện hiện tại\n"
                      "• 25-29.9: Thừa cân - Bạn nên giảm cân để cải thiện sức khỏe\n"
                      "• Trên 30: Béo phì - Nên tham khảo ý kiến bác sĩ về kế hoạch giảm cân",
                      style: TextStyle(fontSize: 14),
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
}
