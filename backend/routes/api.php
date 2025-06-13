<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\GiohangController;
use App\Http\Controllers\InfoController;
use App\Http\Controllers\SanphamController;
// Load Sản phẩm
Route::get('/sanpham', [SanphamController::class, 'getAll']);
// Đăng ký
Route::post('/register', [AuthController::class, 'register']);

// Đăng nhập
Route::post('/login', [AuthController::class, 'login']);

//Giỏ hàng
Route::get('/getCart',[GiohangController::class, 'getCart']);

//Đếm số lượng sản phẩm
Route::get('/countCartItems',[GiohangController::class, 'countCartItems']);

//Thông tin
Route::get('/getUserProfile',[InfoController::class, 'getUserProfile']);

//Update thông tin
Route::post('/updateUserProfile',[InfoController::class, 'updateUserProfile']);