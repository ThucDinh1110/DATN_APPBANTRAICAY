<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;


class Admincontroller extends Controller{
    public function getDanhSachUser(Request $request)
{
    $phanquyen = $request->query('phanquyen', 'Customer'); // mặc định lọc Customer nếu không truyền

    $users = DB::table('user')
        ->join('user_thongtinnguoidung', 'user.UserID', '=', 'user_thongtinnguoidung.UserID')
        ->select(
            'user.UserID',
            'user.Hoten',
            'user.Email',
            'user.Ngaytao',
            'user.Trangthai',
            'user_thongtinnguoidung.Chieucao',
            'user_thongtinnguoidung.Cannang',
            'user_thongtinnguoidung.Diachi'
        )
        ->where('user.Phanquyen', '=', $phanquyen)
        ->get();

    return response()->json($users);
}

public function khoa_moTaiKhoan(Request $request)
{
    $userId = $request->input('user_id');

    $user = DB::table('user')->where('UserID', $userId)->first();

    if (!$user) {
        return response()->json(['message' => 'Không tìm thấy người dùng'], 404);
    }

    $newStatus = $user->Trangthai == 1 ? 0 : 1;

    DB::table('user')
        ->where('UserID', $userId)
        ->update(['Trangthai' => $newStatus]);

    return response()->json(['message' => 'Cập nhật trạng thái tài khoản thành công']);
}

   public function getDanhSachDonHangTatCa(Request $request)
{
    $trangThai = $request->query('trangthai');

    $query = DB::table('donhang')
        ->join('chitietdonhang', 'donhang.DonhangID', '=', 'chitietdonhang.DonhangID')
        ->join('sanpham', 'chitietdonhang.SanphamID', '=', 'sanpham.Idsp')
        ->join('chitietsanpham', 'sanpham.Idsp', '=', 'chitietsanpham.Idsp')
        ->leftJoin('diachigiaohang', 'donhang.DiachigiaoID', '=', 'diachigiaohang.DiachigiaoID')
        ->leftJoin('user', 'donhang.IDuser', '=', 'user.UserID')
        ->leftJoin('thanhtoan', 'donhang.ThanhtoanID', '=', 'thanhtoan.ThanhtoanID') // ✅ join thêm bảng thanh toán
        ->select(
            'donhang.DonhangID',
            'donhang.MaDonHang',
            'donhang.Ngaydat',
            'donhang.Tongtien',
            'donhang.Trangthai',
            'donhang.Ghichu',
            'diachigiaohang.Diachi as Diachi',
            'sanpham.Tensp',
            'chitietdonhang.Soluong',
            'chitietsanpham.Gia',
            'user.Hoten as TenNguoiDung',
            'user.Email as EmailNguoiDung',
            'thanhtoan.Phuongthuc as PhuongthucThanhToan' // ✅ tên phương thức thanh toán
        );

    if ($trangThai) {
        $query->where('donhang.Trangthai', $trangThai);
    }

    $donHangs = $query->get();

    if ($donHangs->isEmpty()) {
        return response()->json([], 200);
    }

    $grouped = $donHangs->groupBy('DonhangID')->map(function ($items) {
        return [
            'DonhangID' => $items[0]->DonhangID,
            'MaDonHang' => $items[0]->MaDonHang ?? '',
            'Ngaydat' => $items[0]->Ngaydat,
            'Tongtien' => $items[0]->Tongtien,
            'Trangthai' => $items[0]->Trangthai,
            'Diachi' => $items[0]->Diachi ?? '',
            'Ghichu' => $items[0]->Ghichu ?? '',
            'PhuongthucThanhToan' => $items[0]->PhuongthucThanhToan ?? '', // ✅ thêm vào JSON trả về
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
public function thongKeDoanhThu(Request $request)
{
    $fromDate = $request->query('from_date');
    $toDate = $request->query('to_date');

    $query = DB::table('donhang');
    if ($fromDate && $toDate) {
        $query->whereBetween('Ngaydat', [$fromDate . ' 00:00:00', $toDate . ' 23:59:59']);
    }
    $doanhThuDuTinhRaw = (clone $query)->sum('Tongtien');

    $donhanghuyRaw = (clone $query)
        ->whereIn('Trangthai', ['Đã hủy', 'Đơn hàng đã hủy', 'Hủy tạm thời'])
        ->sum('Tongtien');

    $choduyetRaw = (clone $query)
        ->where('Trangthai', 'Chờ duyệt')
        ->sum('Tongtien');

    $daduyetRaw = (clone $query)
        ->where('Trangthai', 'Đã duyệt')
        ->sum('Tongtien');

    $danggiaoRaw = (clone $query)
        ->where('Trangthai', 'Đang giao')
        ->sum('Tongtien');

    $doanhThuThucTeRaw = (clone $query)
        ->where('Trangthai', 'Đã mua')
        ->sum('Tongtien');

    return response()->json([
        'doanhThuDuTinh' => number_format($doanhThuDuTinhRaw, 0, ',', '.'),
        'doanhThuThucTe' => number_format($doanhThuThucTeRaw, 0, ',', '.'),
        'donhanghuy'     => number_format($donhanghuyRaw, 0, ',', '.'),
        'choduyet'       => number_format($choduyetRaw, 0, ',', '.'),
        'daduyet'        => number_format($daduyetRaw, 0, ',', '.'),
        'danggiao'       => number_format($danggiaoRaw, 0, ',', '.'),
    ]);
}
public function thongKeDoanhThuTheoThang(Request $request)
{
    $year = $request->query('year');

    if (!$year || !is_numeric($year)) {
        return response()->json(['error' => 'Vui lòng cung cấp năm hợp lệ.'], 400);
    }

    $result = [];

    for ($month = 1; $month <= 12; $month++) {
        // Doanh thu thực tế: chỉ tính đơn "Đã mua"
        $doanhThuThucTe = DB::table('donhang')
            ->whereYear('Ngaydat', $year)
            ->whereMonth('Ngaydat', $month)
            ->where('Trangthai', 'Đã mua')
            ->sum('Tongtien');

        // Doanh thu dự tính: tính tổng tất cả đơn
        $doanhThuDuTinh = DB::table('donhang')
            ->whereYear('Ngaydat', $year)
            ->whereMonth('Ngaydat', $month)
            ->sum('Tongtien');

        $result[$month] = [
            'du_tinh' => $doanhThuDuTinh,
            'thuc_te' => $doanhThuThucTe
        ];
    }

    return response()->json([
        'year' => $year,
        'data' => $result
    ]);
}

}