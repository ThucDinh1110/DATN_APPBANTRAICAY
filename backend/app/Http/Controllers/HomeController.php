<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;


class HomeController extends Controller
{
    //
    public function getDonHangTheoUser($userId)
{
    $donhangs = DB::table('donhang')
        ->where('IDuser', $userId)
        ->orderByDesc('Ngaydat')
        ->get();

    $ketqua = [];

    foreach ($donhangs as $don) {
        $chitiet = DB::table('chitietdonhang')
            ->join('sanpham', 'chitietdonhang.SanphamID', '=', 'sanpham.Idsp')
            ->join('chitietsanpham', 'sanpham.Idsp', '=', 'chitietsanpham.Idsp')
            ->where('chitietdonhang.DonhangID', $don->DonhangID)
            ->select('sanpham.Tensp', 'chitietsanpham.Gia', 'chitietdonhang.Soluong')
            ->get();

        $ketqua[] = [
            'DonhangID' => $don->DonhangID,
            'Ngaydat' => $don->Ngaydat,
            'Tongtien' => $don->Tongtien,
            'Trangthai' => $don->Trangthai,
            'Sanpham' => $chitiet
        ];
    }

    return response()->json($ketqua);
}

public function taoDonHang(Request $request)
{
    $userId = $request->user_id;
    $giohang = DB::table('giohang')->where('IDuser', $userId)->first();

    if (!$giohang) {
        return response()->json(['message' => 'Giỏ hàng không tồn tại'], 404);
    }

    $items = DB::table('chitietgiohang')
        ->where('IDgiohang', $giohang->IDgiohang)
        ->get();

    if ($items->isEmpty()) {
        return response()->json(['message' => 'Giỏ hàng trống'], 400);
    }

    $tongtien = 0;
    foreach ($items as $item) {
        $gia = DB::table('chitietsanpham')
            ->where('Idsp', $item->SanphamID)
            ->value('Gia');
        $tongtien += $gia * $item->Soluong;
    }

    $donhangId = DB::table('donhang')->insertGetId([
        'IDuser' => $userId,
        'DiachigiaoID' => $request->diachi_id,
        'ThanhtoanID' => $request->thanhtoan_id,
        'KhuyenmaiID' => $request->khuyenmai_id,
        'Ngaydat' => now(),
        'Tongtien' => $tongtien,
        'Trangthai' => 'Đã đặt'
    ]);

    foreach ($items as $item) {
        DB::table('chitietdonhang')->insert([
            'DonhangID' => $donhangId,
            'SanphamID' => $item->SanphamID,
            'Soluong' => $item->Soluong
        ]);
    }

    // Xóa giỏ hàng sau khi đặt đơn
    DB::table('chitietgiohang')->where('IDgiohang', $giohang->IDgiohang)->delete();

    return response()->json(['message' => 'Đặt hàng thành công', 'DonhangID' => $donhangId]);
}



}
