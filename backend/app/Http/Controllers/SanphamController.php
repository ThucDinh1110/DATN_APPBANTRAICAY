<?php

namespace App\Http\Controllers;

use App\Models\Sanpham;

class SanphamController extends Controller
{
    public function getAll()
    {
        // Lấy sản phẩm + chi tiết + danh mục, chỉ sản phẩm có trạng thái = 1
        $data = Sanpham::with(['chitiet', 'danhmucs'])
            ->where('Trangthai', 1)
            ->get();

        // Gộp dữ liệu chi tiết và danh mục
        $result = $data->map(function ($sp) {
            return [
                'Idsp' => $sp->Idsp,
                'Tensp' => $sp->Tensp,
                'Trangthai' => $sp->Trangthai,
                'Gia' => $sp->chitiet->Gia ?? null,
                'Donvi' => $sp->chitiet->Donvi ?? null,
                'Hinhanh' => $sp->chitiet->Hinhanh ?? null,
                'Mota' => $sp->chitiet->Mota ?? null,
                'VitaminA' => $sp->chitiet->VitaminA ?? null,
                'VitaminC' => $sp->chitiet->VitaminC ?? null,
                'Chatxo' => $sp->chitiet->Chatxo ?? null,
                'Duong' => $sp->chitiet->Duong ?? null,
                'Tinhbot' => $sp->chitiet->Tinhbot ?? null,

                // Danh sách tên danh mục
                'Danhmuc' => $sp->danhmucs->pluck('Tendanhmuc')->toArray(),
            ];
        });

        return response()->json($result);
    }
}
