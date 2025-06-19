<?php

namespace App\Http\Controllers;
use Illuminate\Support\Facades\Log;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Models\GioHang;
use App\Models\ChiTietGioHang;
class GiohangController extends Controller

{
    

public function them(Request $request)
{
    Log::info('==> Nhận dữ liệu: ', $request->all());

    $request->validate([
        'user_id' => 'required|integer',
        'product_id' => 'required|integer',
        'soluong' => 'required|integer',
    ]);

    $userId = $request->user_id;
    $productId = $request->product_id;
    $soluong = $request->soluong;

    $giohang = DB::table('giohang')
        ->where('IDuser', $userId)
        ->where('Trangthai', 1)
        ->first();

    if (!$giohang) {
        $giohangId = DB::table('giohang')->insertGetId([
            'IDuser' => $userId,
            'Trangthai' => 1,
        ]);
        Log::info('==> Tạo giỏ hàng mới với ID: ' . $giohangId);
    } else {
        $giohangId = $giohang->IDgiohang;
        Log::info('==> Đã có giỏ hàng ID: ' . $giohangId);
    }

    $item = DB::table('chitietgiohang')
        ->where('IDgiohang', $giohangId)
        ->where('SanphamID', $productId)
        ->first();

    if ($item) {
        DB::table('chitietgiohang')
            ->where('IDgiohang', $giohangId)
            ->where('SanphamID', $productId)
            ->update([
                'Soluong' => $item->Soluong + $soluong,
            ]);
        Log::info("==> Cập nhật số lượng sản phẩm ID $productId, số lượng mới: " . ($item->Soluong + $soluong));
    } else {
        DB::table('chitietgiohang')->insert([
            'IDgiohang' => $giohangId,
            'SanphamID' => $productId,
            'Soluong' => $soluong,
        ]);
        Log::info("==> Thêm mới sản phẩm ID $productId vào giỏ hàng ID $giohangId");
    }

    return response()->json([
        'success' => true,
        'message' => 'Thêm sản phẩm vào giỏ hàng thành công',
    ]);
}

    //
  public function getCart(Request $request)
{
    $userId = $request->user_id;

    $giohang = DB::table('giohang')
        ->where('IDuser', $userId)
        ->where('Trangthai', 1) // 1: đang dùng
        ->first();

    if (!$giohang) {
        return response()->json(['message' => 'Không tìm thấy giỏ hàng'], 404);
    }

    $items = DB::table('chitietgiohang')
        ->join('sanpham', 'chitietgiohang.SanphamID', '=', 'sanpham.Idsp')
        ->join('chitietsanpham', 'chitietgiohang.SanphamID', '=', 'chitietsanpham.Idsp')
        ->where('chitietgiohang.IDgiohang', $giohang->IDgiohang)
        ->where('chitietgiohang.Soluong', '>', 0) // 👉 chỉ lấy sản phẩm có số lượng > 0
        ->select(
            'sanpham.Idsp as SanphamID', 
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
        ->where('chitietgiohang.Soluong', '>', 0) // 👉 chỉ lấy sản phẩm có số lượng > 0
        ->count(); //đếm số sản phẩm

    return response()->json(['count' => $totalQuantity]);
}

}
