<?php

namespace App\Http\Controllers;

use App\Models\Sanpham;

class SanphamController extends Controller
{
    public function getAll()
    {
        // Lấy sản phẩm + chi tiết + danh mục + kho
        $data = Sanpham::with(['chitiet', 'danhmucs', 'kho'])
            ->where('Trangthai', 1)
            ->get();

        // Chỉ giữ sản phẩm có tồn kho > 0
        $data = $data->filter(function ($sp) {
            return $sp->kho && $sp->kho->Soluongton > 0;
        });

        // Gộp dữ liệu chi tiết + danh mục + tồn kho
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
                'Soluongton' => $sp->kho->Soluongton ?? 0,
                'Danhmuc' => $sp->danhmucs->pluck('Tendanhmuc')->toArray(),
            ];
        });

        return response()->json($result->values()); // Đảm bảo trả về mảng chỉ số lại từ 0
    }
}
