<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;


class HomeController extends Controller
{
    //
    public function getDanhSachDonHang(Request $request)
{
    $userId = $request->query('user_id');
    $trangThai = $request->query('trangthai'); // tuỳ chọn

    if (!$userId) {
        return response()->json(['message' => 'Thiếu user_id'], 400);
    }

    $query = DB::table('donhang')
        ->join('chitietdonhang', 'donhang.DonhangID', '=', 'chitietdonhang.DonhangID')
        ->join('sanpham', 'chitietdonhang.SanphamID', '=', 'sanpham.Idsp')
        ->join('chitietsanpham', 'sanpham.Idsp', '=', 'chitietsanpham.Idsp')
        ->select(
            'donhang.DonhangID',
            'donhang.Ngaydat',
            'donhang.Tongtien',
            'donhang.Trangthai',
            'sanpham.Tensp',
            'chitietdonhang.Soluong',
            'chitietsanpham.Gia'
        )
        ->where('donhang.IDuser', $userId);

    if ($trangThai) {
        $query->where('donhang.Trangthai', $trangThai);
    }

    $donHangs = $query->get();

    if ($donHangs->isEmpty()) {
        return response()->json(['message' => 'Không có đơn hàng'], 404);
    }

    // Gom theo đơn hàng
    $grouped = $donHangs->groupBy('DonhangID')->map(function ($items) {
        return [
            'Ngaydat' => $items[0]->Ngaydat,
            'Tongtien' => $items[0]->Tongtien,
            'Trangthai' => $items[0]->Trangthai,
            'Sanphams' => $items->map(function ($item) {
                return [
                    'Tensp' => $item->Tensp,
                    'Soluong' => $item->Soluong,
                    'Gia' => $item->Gia,
                ];
            })->toArray()
        ];
    });

    return response()->json($grouped->values());
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
        'Trangthai' => 'Chờ duyệt'
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

public function huyDonHang(Request $request)
{
    $userId = $request->user_id;
    $donhangId = $request->donhang_id;

    $donhang = DB::table('donhang')
        ->where('DonhangID', $donhangId)
        ->where('IDuser', $userId)
        ->first();

    if (!$donhang) {
        return response()->json(['message' => 'Không tìm thấy đơn hàng'], 404);
    }

    if ($donhang->Trangthai !== 'Chờ duyệt') {
        return response()->json(['message' => 'Đơn hàng không thể hủy khi đã xử lý'], 403);
    }

    $ngaydat = \Carbon\Carbon::parse($donhang->Ngaydat);
    $now = \Carbon\Carbon::now();

    $phutKhacBiet = $ngaydat->diffInMinutes($now);

    if ($phutKhacBiet <= 30) {
        // Cho phép hủy luôn
        DB::table('donhang')->where('DonhangID', $donhangId)->update([
            'Trangthai' => 'Đã hủy'
        ]);
        return response()->json(['message' => 'Đơn hàng đã được hủy thành công']);
    } else {
        return response()->json([
            'message' => 'Đơn hàng đã quá 30 phút. Cần xác nhận từ admin để hủy.'
        ], 403);
    }
}


public function capNhatTrangThaiDonHang(Request $request)
{
    $request->validate([
        'donhang_id' => 'required|integer',
        'trangthai' => 'required|string'
    ]);

    $donhangId = $request->input('donhang_id');
    $trangthai = $request->input('trangthai');

    $exists = DB::table('donhang')->where('DonhangID', $donhangId)->exists();

    if (!$exists) {
        return response()->json(['message' => 'Không tìm thấy đơn hàng'], 404);
    }

    DB::table('donhang')->where('DonhangID', $donhangId)->update([
        'Trangthai' => $trangthai
    ]);

    return response()->json(['message' => 'Cập nhật trạng thái thành công']);
}


}
