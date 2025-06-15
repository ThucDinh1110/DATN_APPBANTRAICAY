class SanPham {
  final int id;
  final String ten;
  final double gia;
  final String donvi;
  final String? hinhanh;
  final String? mota;
  final double? vitamina;
  final double? vitaminb;
  final double? chatxo;
  final double? duong;
  final double? tinhbot;
  final int soluongton;
   final List<String> danhmuc;
 

  SanPham({
    required this.id,
    required this.ten,
    required this.gia,
    required this.donvi,
    required this.hinhanh,
    required this.mota, 
    required this.vitamina,
    required this.vitaminb, 
    required this.chatxo,
    required this.duong,
    required this.tinhbot,
    required this.soluongton,
    required this.danhmuc,
   
  });

  factory SanPham.fromJson(Map<String, dynamic> json) {
    return SanPham(
      id: json['Idsp'],
      ten: json['Tensp'],
      gia: double.tryParse(json['Gia'].toString()) ?? 0.0,
      donvi: json['Donvi'] ?? '',
      hinhanh: json['Hinhanh'],
      mota: json['Mota'],
      vitamina: json['Vitamina'] != null ? double.tryParse(json['Vitamina'].toString()) : null,
      vitaminb: json['Vitaminb'] != null ? double.tryParse(json['Vitaminb'].toString()) : null,
      chatxo: json['Chatxo'] != null ? double.tryParse(json['Chatxo'].toString()) : null,
      duong: json['Duong'] != null ? double.tryParse(json['Duong'].toString()) : null,
      tinhbot: json['Tinhbot'] != null ? double.tryParse(json['Tinhbot'].toString()) : null,
      soluongton: json['Soluongton'] ?? 0,
       danhmuc: (json['Danhmuc'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
