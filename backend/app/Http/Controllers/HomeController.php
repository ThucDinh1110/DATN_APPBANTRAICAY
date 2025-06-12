<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;


class HomeController extends Controller
{
    //
    public function index() {
    $products = DB::table('sanpham')
        ->join('chitietsanpham', 'sanpham.Idsp', '=', 'chitietsanpham.Idsp')
        ->leftJoin('sanpham_danhmuc', 'sanpham.Idsp', '=', 'sanpham_danhmuc.Idsp')
        ->leftJoin('danhmuc', 'sanpham_danhmuc.DanhmucID', '=', 'danhmuc.DanhmucID')
        ->select('sanpham.*', 'chitietsanpham.*', 'danhmuc.Tendanhmuc')
        ->get();

    return response()->json($products);
    }
}
