import 'dart:ffi';

class SanPham {
  final int id;
  final String ten;
  final double gia;
  final String donvi;
  final bool trangthai;
  final String? hinhanh;
  final String? mota;
  final double? vitamina;
  final double? vitaminc;
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
    required this.trangthai,
    required this.hinhanh,
    required this.mota, 
    required this.vitamina,
    required this.vitaminc, 
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
       trangthai: json['Trangthai'] == 1,
      hinhanh: json['Hinhanh'],
      mota: json['Mota'],
      vitamina: json['VitaminA'] != null ? double.tryParse(json['VitaminA'].toString()) : null,
      vitaminc: json['VitaminA'] != null ? double.tryParse(json['VitaminC'].toString()) : null,
      chatxo: json['Chatxo'] != null ? double.tryParse(json['Chatxo'].toString()) : null,
      duong: json['Duong'] != null ? double.tryParse(json['Duong'].toString()) : null,
      tinhbot: json['Tinhbot'] != null ? double.tryParse(json['Tinhbot'].toString()) : null,
      soluongton: json['Soluongton'] ?? 0,
       danhmuc: (json['Danhmuc'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
