<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class GiohangController extends Controller
{
    //
    public function getCart(Request $request)
{
    // Tìm giỏ hàng của user đang đăng nhập (hoặc truyền vào)
    $userId = $request->user_id;

    $giohang = DB::table('giohang')
        ->where('IDuser', $userId)
        ->where('Trangthai', 1) // 1: đang dùng
        ->first();

    if (!$giohang) {
        return response()->json(['message' => 'Không tìm thấy giỏ hàng'], 404);
    }

    // Lấy chi tiết sản phẩm trong giỏ hàng
    $items = DB::table('chitietgiohang')
        ->join('sanpham', 'chitietgiohang.SanphamID', '=', 'sanpham.Idsp')
        ->join('chitietsanpham', 'chitietgiohang.SanphamID', '=', 'chitietsanpham.Idsp')
        ->where('chitietgiohang.IDgiohang', $giohang->IDgiohang)
        ->select(
            'sanpham.Tensp as ten_sanpham',
            'chitietgiohang.Soluong',
            'chitietsanpham.Gia',
            DB::raw('chitietgiohang.Soluong * chitietsanpham.Gia as thanhtien')
        )
        ->get();

    $tongtien = $items->sum('thanhtien');

    return response()->json([
        'giohang_id' => $giohang->IDgiohang,
        'items' => $items,
        'tongtien' => $tongtien
    ]);
}

public function countCartItems(Request $request)
{
    $userId = $request->input('user_id');

    $giohang = DB::table('giohang')
        ->where('IDuser', $userId)
        ->where('Trangthai', 1) // giỏ hàng đang hoạt động
        ->first();

    if (!$giohang) {
        return response()->json(['count' => 0]);
    }

    $totalQuantity = DB::table('chitietgiohang')
        ->where('IDgiohang', $giohang->IDgiohang)
        ->count(); //đếm số sản phẩm

    return response()->json(['count' => $totalQuantity]);
}

}
