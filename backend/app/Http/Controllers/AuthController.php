<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use App\Models\User;

class AuthController extends Controller
{
   public function register(Request $request)
{
    try {
        // Thêm user mới
        $id = DB::table('user')->insertGetId([
            'AccountPhone' => $request->phone,
            'Sodienthoai' => $request->phone,
            'Matkhau' => bcrypt($request->password),
            'Hoten' => $request->name,
            'Email' => $request->email,
            'Phanquyen' => 'Customer'
        ]);

        // Lấy thông tin user vừa thêm
        $user = DB::table('user')->where('UserID', $id)->first();

        if (!$user) {
            return response()->json(['message' => 'Không tìm thấy người dùng sau khi đăng ký'], 500);
        }

        // Tạo giỏ hàng luôn
        DB::table('giohang')->insert([
            'IDuser' => $id,
            'Trangthai' => 1
        ]);

        return response()->json([
            'message' => 'Đăng ký thành công',
            'user' => $user
        ]);
    } catch (\Exception $e) {
        return response()->json(['message' => 'Lỗi: ' . $e->getMessage()], 500);
    }
}

  public function login(Request $request)
{
    // Tìm người dùng theo số điện thoại
    $user = DB::table('user')->where('AccountPhone', $request->phone)->first();

    // Không tìm thấy tài khoản
    if (!$user) {
        return response()->json(['message' => 'Không tìm thấy tài khoản'], 404);
    }

    // Nếu mật khẩu không tồn tại (null) thì báo lỗi
    if (empty($user->Matkhau)) {
        return response()->json(['message' => 'Tài khoản không có mật khẩu'], 500);
    }

    // Kiểm tra mật khẩu có khớp không
    if (!Hash::check($request->password, $user->Matkhau)) {
        return response()->json(['message' => 'Sai mật khẩu'], 401);
    }

    // Thành công
    return response()->json([
        'message' => 'Đăng nhập thành công',
        'user' => $user
    ]);
}
}
