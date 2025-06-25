<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\GiohangController;
use App\Http\Controllers\HomeController;
use App\Http\Controllers\InfoController;
use App\Http\Controllers\SanphamController;
use App\Http\Controllers\DiachiController;
use App\Http\Controllers\NhapHangController;
use App\Http\Controllers\Admincontroller;
use App\Http\Controllers\ImageController;
use App\Http\Controllers\DanhmucController;
//danhthu
Route::get('/thongke/doanhthu', [HomeController::class, 'thongKeDoanhThu']);
//danhmuc
Route::get('/danhmucs', [DanhmucController::class, 'getAll']);
//adminsanpham
Route::get('/sanpham/full', [SanphamController::class, 'getFullData']);
Route::put('/sanpham/{id}', [SanphamController::class, 'update']);

Route::post('/upload-image', [ImageController::class, 'upload']);
Route::get('/images', [ImageController::class, 'index']);
Route::delete('/images/{id}', [ImageController::class, 'delete']);
//nhaphang
Route::post('/nhaphang', [NhapHangController::class, 'nhapHang']);
//
Route::post('/them', [GiohangController::class, 'them']);
// Load Sản phẩm
Route::get('/sanpham', [SanphamController::class, 'getAll']);
// Đăng ký
Route::post('/register', [AuthController::class, 'register']);

// Đăng nhập
Route::post('/login', [AuthController::class, 'login']);

//Giỏ hàng
Route::post('/getCart',[GiohangController::class, 'getCart']);

//Đếm số lượng sản phẩm
Route::get('/countCartItems',[GiohangController::class, 'countCartItems']);

//Thông tin
Route::get('/getUserProfile',[InfoController::class, 'getUserProfile']);

//Update thông tin
Route::post('/updateUserProfile',[InfoController::class, 'updateUserProfile']);

//Route::get('/getDiaChiGiaoHang',[AuthController::class, 'getDiaChiGiaoHang']);

//Đơn hàng
Route::get('/getDanhSachDonHang',[HomeController::class, 'getDanhSachDonHang']);

Route::post('/taoDonHang', [HomeController::class, 'taoDonHang']);

Route::post('/huyDonHang', [HomeController::class, 'huyDonHang']);

Route::get('/getDanhSachDiaChiGiaoID', [DiachiController::class, 'getDanhSachDiaChiGiaoID']);

Route::get('/getDiaChiGiaoID', [DiachiController::class, 'getDiaChiGiaoID']);

Route::get('/getDiaChiMacDinh', [DiachiController::class, 'getDiaChiMacDinh']);

Route::post('/setDefaultAddress', [DiachiController::class, 'setDefaultAddress']);

Route::post('updateOrInsert', [DiaChiController::class, 'updateOrInsert']);

Route::get('/getDanhSachDonHangTatCa', [Admincontroller::class, 'getDanhSachDonHangTatCa']);

Route::post('/capNhatTrangThaiDon', [Admincontroller::class, 'capNhatTrangThaiDon']);

Route::get('/getDanhSachUser', [Admincontroller::class, 'getDanhSachUser']);

Route::post('/khoa_moTaiKhoan', [Admincontroller::class, 'khoa_moTaiKhoan']);