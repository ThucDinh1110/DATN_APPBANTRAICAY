<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class NhapHangController extends Controller
{
    public function nhapHang(Request $request)
    {
        $data = $request->all();

        DB::beginTransaction();
        try {
            // 1. Tạo phiếu nhập
            $phieuNhapID = DB::table('phieunhap')->insertGetId([
                'Ngaynhap' => Carbon::now(),
                'Nhacungcap' => $data['Nhacungcap'],
                'Nguoinhap' => $data['Nguoinhap'],
                'Tongtiennhap' => 0,
                'Ghichu' => $data['Ghichu'] ?? null,
            ]);

            $tongTien = 0;

            foreach ($data['chitiet'] as $ct) {
                // 2. Kiểm tra danh mục, thêm nếu chưa có
                $danhmuc = DB::table('danhmuc')->where('DanhmucID', $ct['DanhmucID'])->first();
                if (!$danhmuc) {
                    DB::table('danhmuc')->insert([
                        'DanhmucID' => $ct['DanhmucID'],
                        'Tendanhmuc' => $ct['Tendanhmuc'] ?? 'Danh mục chưa đặt tên'
                    ]);
                }

                // 3. Kiểm tra sản phẩm, thêm nếu chưa có
                $sanpham = DB::table('sanpham')->where('Idsp', $ct['SanphamID'])->first();
                if (!$sanpham) {
                    DB::table('sanpham')->insert([
                        'Idsp' => $ct['SanphamID'],
                        'Tensp' => $ct['Tensp'],
                        'Trangthai' => 1
                    ]);

                    DB::table('chitietsanpham')->insert([
                        'Idsp' => $ct['SanphamID'],
                        'Hinhanh' => $ct['Hinhanh'] ?? null,
                        'Gia' => $ct['Dongianhap'],
                        'Donvi' => $ct['Donvi'],
                        'Mota' => $ct['Mota'] ?? null,
                        'VitaminA' => $ct['VitaminA'] ?? null,
                        'VitaminC' => $ct['VitaminC'] ?? null,
                        'Chatxo' => $ct['Chatxo'] ?? null,
                        'Duong' => $ct['Duong'] ?? null,
                        'Tinhbot' => $ct['Tinhbot'] ?? null,
                    ]);

                    // 4. Liên kết sản phẩm với danh mục
                    DB::table('sanpham_danhmuc')->insert([
                        'Idsp' => $ct['SanphamID'],
                        'DanhmucID' => $ct['DanhmucID']
                    ]);
                }

                // 5. Chi tiết phiếu nhập
                DB::table('chitietphieunhap')->insert([
                    'PhieunhapID' => $phieuNhapID,
                    'SanphamID' => $ct['SanphamID'],
                    'Soluongnhap' => $ct['Soluongnhap'],
                    'Dongianhap' => $ct['Dongianhap'],
                    'Donvi' => $ct['Donvi'],
                ]);

                // 6. Cập nhật kho
                $kho = DB::table('kho')->where('SanphamID', $ct['SanphamID'])->first();
                if ($kho) {
                    DB::table('kho')->where('SanphamID', $ct['SanphamID'])->update([
                        'Soluongton' => $kho->Soluongton + $ct['Soluongnhap'],
                        'Ngaycapnhat' => Carbon::now(),
                    ]);
                } else {
                    DB::table('kho')->insert([
                        'SanphamID' => $ct['SanphamID'],
                        'Soluongton' => $ct['Soluongnhap'],
                        'Donvi' => $ct['Donvi'],
                        'Ngaycapnhat' => Carbon::now(),
                    ]);
                }

                $tongTien += $ct['Soluongnhap'] * $ct['Dongianhap'];
            }

            // 7. Cập nhật tổng tiền phiếu nhập
            DB::table('phieunhap')->where('PhieunhapID', $phieuNhapID)->update([
                'Tongtiennhap' => $tongTien
            ]);

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Nhập hàng thành công!',
                'PhieunhapID' => $phieuNhapID
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Lỗi khi nhập hàng: ' . $e->getMessage()
            ], 500);
        }
    }
}
