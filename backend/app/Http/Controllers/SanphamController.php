<?php

namespace App\Http\Controllers;

use App\Models\Sanpham;
use Illuminate\Http\Request;

class SanphamController extends Controller
{
    // ✅ API: Lấy sản phẩm đang hoạt động và còn tồn kho
    public function getAll()
    {
        $data = Sanpham::with(['chitiet', 'danhmucs', 'kho'])
            ->where('Trangthai', 1)
            ->get()
            ->filter(function ($sp) {
                return $sp->kho && $sp->kho->Soluongton > 0;
            });

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

        return response()->json($result->values());
    }

    // ✅ API: Lấy tất cả sản phẩm (admin)
    public function getFullData()
    {
        $sanphams = Sanpham::with(['chitiet', 'danhmucs', 'kho'])->get();

        $result = $sanphams->map(function ($sp) {
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

        return response()->json($result->values());
    }

    // ✅ API: Cập nhật sản phẩm
    public function update(Request $request, $id)
    {  \Log::info('REQUEST UPDATE SP', $request->all());
        $sp = Sanpham::with(['chitiet', 'kho'])->findOrFail($id);

        // Cập nhật bảng sanpham
        $sp->Tensp = $request->Tensp;
        $sp->Trangthai = $request->Trangthai;
        $sp->save();

        // Cập nhật chi tiết sản phẩm
        if ($sp->chitiet) {
            $sp->chitiet->update([
                'Gia' => $request->Gia,
                'Donvi' => $request->Donvi,
                'Hinhanh' => $request->Hinhanh,
                'Mota' => $request->Mota,
                'VitaminA' => $request->VitaminA,
                'VitaminC' => $request->VitaminC,
                'Chatxo' => $request->Chatxo,
                'Duong' => $request->Duong,
                'Tinhbot' => $request->Tinhbot,
            ]);
        }

        // Cập nhật kho
        if ($sp->kho) {
            $sp->kho->update([
                'Soluongton' => $request->Soluongton,
            ]);
        }

        // Cập nhật danh mục
        if ($request->has('Danhmuc') && is_array($request->Danhmuc)) {
            $sp->danhmucs()->sync($request->Danhmuc);
        }

        return response()->json(['message' => 'Cập nhật sản phẩm thành công']);
    }
}
