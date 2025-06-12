<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class InfoController extends Controller
{
    public function getUserProfile(Request $request)
{
    $userId = $request->input('user_id');

    $user = DB::table('user')
        ->select('Hoten', 'Sodienthoai', 'Email', 'Gioitinh')
        ->where('UserID', $userId)
        ->first();

    if (!$user) {
        return response()->json(['message' => 'Không tìm thấy người dùng'], 404);
    }

    $userinfo = DB::table('user_thongtinnguoidung')
        ->select('Chieucao', 'Cannang')
        ->where('UserID', $userId)
        ->first();

    // Chuyển đổi giới tính từ số sang chữ
    $gioitinhMapping = [
        0 => 'Nữ',
        1 => 'Nam',
        2 => 'Khác'
    ];
    $gioitinhText = $gioitinhMapping[$user->Gioitinh] ?? 'Không xác định';

    return response()->json([
        'Hoten' => $user->Hoten,
        'Sodienthoai' => $user->Sodienthoai,
        'Email' => $user->Email,
        'Gioitinh' => $gioitinhText,
        'Chieucao' => optional($userinfo)->Chieucao,
        'Cannang' => optional($userinfo)->Cannang
    ]);
}

public function updateUserProfile(Request $request)
{
    $userId = $request->input('user_id');

    if (!$userId) {
        return response()->json(['message' => 'Thiếu user_id'], 400);
    }

    // Cập nhật bảng user
    DB::table('user')->where('UserID', $userId)->update([
        'Hoten' => $request->input('hoten'),
        'Sodienthoai' => $request->input('sodienthoai'),
        'Email' => $request->input('email'),
        'Gioitinh' => $this->mapGenderToInt($request->input('gioitinh'))
    ]);

    // Kiểm tra xem đã có dữ liệu user_thongtinnguoidung chưa
    $exists = DB::table('user_thongtinnguoidung')->where('UserID', $userId)->exists();

    if ($exists) {
        DB::table('user_thongtinnguoidung')->where('UserID', $userId)->update([
            'Chieucao' => $request->input('chieucao'),
            'Cannang' => $request->input('cannang')
        ]);
    } else {
        DB::table('user_thongtinnguoidung')->insert([
            'UserID' => $userId,
            'Chieucao' => $request->input('chieucao'),
            'Cannang' => $request->input('cannang')
        ]);
    }

    return response()->json(['message' => 'Cập nhật thông tin thành công']);
}

// Hàm hỗ trợ để chuyển đổi giới tính từ chữ sang số
private function mapGenderToInt($gender)
{
    return match ($gender) {
        'Nam' => 1,
        'Nữ' => 0,
        'Khác' => 2,
        default => null
    };
}

}
