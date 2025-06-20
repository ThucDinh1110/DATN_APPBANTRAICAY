<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;

class DiachiController extends Controller{
    public function getDanhSachDiaChiGiaoID(Request $request)
{
    try {
        $userId = $request->query('user_id');

        if (!$userId) {
            return response()->json(['message' => 'Thiếu user_id'], 400);
        }

        $diachis = DB::table('diachigiaohang')
            ->where('UserID', $userId)
            ->orderByDesc('DiachigiaoID')
            ->get();

        if ($diachis->isEmpty()) {
            return response()->json([], 200); // Trả về mảng rỗng nếu không có địa chỉ
        }

        // Format lại dữ liệu (nếu cần)
        $result = $diachis->map(function ($item) {
            return [
                'diachi_id' => $item->DiachigiaoID,
                'hoten' => $item->Hoten,
                'sdt' => $item->Sodienthoai,
                'diachi' => $item->Diachi,
                //'quan' => '', // hoặc tách từ diachi nếu bạn muốn
                //'thanhpho' => '',
                'is_default' => $item->is_default ?? 0
            ];
        });

        return response()->json($result);
    } catch (\Exception $e) {
        return response()->json([
            'message' => 'Server Error',
            'error' => $e->getMessage()
        ], 500);
    }
}

public function getDiaChiMacDinh(Request $request)
{
    $userId = $request->query('user_id');

    if (!$userId) {
        return response()->json(['message' => 'Thiếu user_id'], 400);
    }

    $diachi = DB::table('diachigiaohang')
        ->where('UserID', $userId)
        ->where('is_default', 1)
        ->first();

    if (!$diachi) {
        return response()->json(['message' => 'Không có địa chỉ mặc định'], 404);
    }

    return response()->json([
        'hoten' => $diachi->Hoten,
        'sdt' => $diachi->Sodienthoai,
        'diachi' => $diachi->Diachi,
        'diachi_id' => $diachi->DiachigiaoID,
    ]);
}

   public function setDefaultAddress(Request $request)
{
    $userId = $request->input('user_id');
    $diaChiId = $request->input('dia_chi_id');

    DB::table('diachigiaohang')
        ->where('UserID', $userId)
        ->update(['is_default' => 0]);

    DB::table('diachigiaohang')
        ->where('DiachigiaoID', $diaChiId)
        ->update(['is_default' => 1]);

    return response()->json(['status' => 'success']);
}

public function getDiaChiGiaoID(Request $request)
    {
        try {
            $userId = $request->query('user_id');

            if (!$userId) {
                return response()->json(['message' => 'Thiếu user_id'], 400);
            }

            $diachi = DB::table('diachigiaohang')
                ->where('UserID', $userId) // sửa đúng tên cột
                ->orderByDesc('DiachigiaoID')
                ->first();

            if (!$diachi) {
                return response()->json(['message' => 'Không tìm thấy địa chỉ'], 404);
            }

            return response()->json(['diachi_id' => $diachi->DiachigiaoID]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Server Error',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function updateOrInsert(Request $request)
{
    $userId = $request->input('user_id');
    $hoten = $request->input('hoten');
    $sodienthoai = $request->input('sodienthoai');
    $diachi = $request->input('diachi');
    $id = $request->input('id'); // null nếu là tạo mới

    if (!$userId || !$hoten || !$sodienthoai || !$diachi) {
        return response()->json(['message' => 'Thiếu thông tin'], 400);
    }

    $data = [
        'UserID' => $userId,
        'Hoten' => $hoten,
        'Sodienthoai' => $sodienthoai,
        'Diachi' => $diachi,
    ];

    if ($id) {
        // cập nhật
        DB::table('diachigiaohang')->where('DiachigiaoID', $id)->update($data);
    } else {
        // thêm mới với is_default = 0
        $data['is_default'] = 0;
        DB::table('diachigiaohang')->insert($data);
    }

    return response()->json(['message' => 'Lưu địa chỉ thành công']);
}

}