<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;


class Admincontroller extends Controller{
    public function getDanhSachDonHangTatCa(Request $request)
{
    $trangThai = $request->query('trangthai'); // lọc theo trạng thái nếu cần

    $query = DB::table('donhang')
        ->join('chitietdonhang', 'donhang.DonhangID', '=', 'chitietdonhang.DonhangID')
        ->join('sanpham', 'chitietdonhang.SanphamID', '=', 'sanpham.Idsp')
        ->join('chitietsanpham', 'sanpham.Idsp', '=', 'chitietsanpham.Idsp')
        ->leftJoin('diachigiaohang', 'donhang.DiachigiaoID', '=', 'diachigiaohang.DiachigiaoID')
        ->leftJoin('user', 'donhang.IDuser', '=', 'user.UserID')
        ->select(
            'donhang.DonhangID',
            'donhang.Ngaydat',
            'donhang.Tongtien',
            'donhang.Trangthai',
            'donhang.Ghichu',
            'diachigiaohang.Diachi as Diachi',
            'sanpham.Tensp',
            'chitietdonhang.Soluong',
            'chitietsanpham.Gia',
            'user.Hoten as TenNguoiDung',
            'user.Email as EmailNguoiDung'
        );

    if ($trangThai) {
        $query->where('donhang.Trangthai', $trangThai);
    }

    $donHangs = $query->get();

    if ($donHangs->isEmpty()) {
        //return response()->json(['message' => 'Không có đơn hàng'], 404);
         return response()->json([], 200);
    }

    // Gom đơn hàng theo DonhangID
    $grouped = $donHangs->groupBy('DonhangID')->map(function ($items) {
        return [
            'DonhangID' => $items[0]->DonhangID,
            'Ngaydat' => $items[0]->Ngaydat,
            'Tongtien' => $items[0]->Tongtien,
            'Trangthai' => $items[0]->Trangthai,
            'Diachi' => $items[0]->Diachi ?? '',
            'Ghichu' => $items[0]->Ghichu ?? '',
            'NguoiDung' => [
                'Hoten' => $items[0]->TenNguoiDung ?? '',
                'Email' => $items[0]->EmailNguoiDung ?? '',
            ],
            'Sanphams' => $items->map(function ($item) {
                return [
                    'Tensp' => $item->Tensp,
                    'Soluong' => $item->Soluong,
                    'Gia' => $item->Gia,
                ];
            })->toArray()
        ];
    });

    return response()->json(array_values($grouped->values()->toArray()));
}

public function capNhatTrangThaiDon(Request $request){
    $donhangId = $request->input('donhang_id');
    $trangthai = $request->input('trangthai');

    $affected = DB::table('donhang')
        ->where('DonhangID', $donhangId)
        ->update(['Trangthai' => $trangthai]);

    if ($affected) {
        return response()->json(['message' => 'Cập nhật thành công']);
    } else {
        return response()->json(['message' => 'Không tìm thấy đơn hàng'], 404);
    }
}
}