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
    $selectedItems = is_string($request->items) ? json_decode($request->items, true) : $request->items;

    if (!is_array($selectedItems) || count($selectedItems) === 0) {
    return response()->json(['message' => 'Không có sản phẩm nào được chọn'], 400);
    }

    // Tìm giỏ hàng hiện tại
    $giohang = DB::table('giohang')
        ->where('IDuser', $userId)
        ->where('Trangthai', 1)
        ->first();

    if (!$giohang) {
        return response()->json(['message' => 'Không tìm thấy giỏ hàng'], 404);
    }

    // Tính tổng tiền theo các sản phẩm được chọn
    $tongtien = 0;
    foreach ($selectedItems as $item) {
        $gia = DB::table('chitietsanpham')
            ->where('Idsp', $item['sanpham_id'])
            ->value('Gia');
        $tongtien += $gia * $item['soluong'];
    }

    // Sinh mã đơn hàng
    $randomCode = 'OV' . now()->format('ymdHis') . rand(100, 999);

    // Tạo đơn hàng
    $donhangId = DB::table('donhang')->insertGetId([
        'IDuser'       => $userId,
        'DiachigiaoID' => $request->diachi_id,
        'ThanhtoanID'  => $request->thanhtoan_id,
        'KhuyenmaiID'  => $request->khuyenmai_id,
        'Ngaydat'      => now(),
        'Tongtien'     => $tongtien,
        'Trangthai'    => 'Chờ duyệt',
        'Ghichu'       => $request->ghichu,
        'MaDonHang'    => $randomCode
    ]);

    // Thêm chi tiết đơn hàng và xóa sản phẩm khỏi giỏ hàng
    foreach ($selectedItems as $item) {
        DB::table('chitietdonhang')->insert([
            'DonhangID' => $donhangId,
            'SanphamID' => $item['sanpham_id'],
            'Soluong'   => $item['soluong']
        ]);

        // Xóa từng sản phẩm khỏi chi tiết giỏ hàng
        DB::table('chitietgiohang')
            ->where('IDgiohang', $giohang->IDgiohang)
            ->where('SanphamID', $item['sanpham_id'])
            ->delete();
    }

    return response()->json([
        'message'    => 'Đặt hàng thành công',
        'DonhangID'  => $donhangId,
        'MaDonHang'  => $randomCode,
        'TongTien'   => $tongtien
    ]);
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
