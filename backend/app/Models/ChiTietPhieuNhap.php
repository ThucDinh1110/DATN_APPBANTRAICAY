<?php

namespace App\Models\NhapHang;

use Illuminate\Database\Eloquent\Model;

class ChiTietPhieuNhap extends Model
{
    protected $table = 'chitietphieunhap';
    protected $primaryKey = 'ChitietphieunhapID';
    public $timestamps = false;

    protected $fillable = [
        'PhieunhapID',
        'SanphamID',
        'Soluongnhap',
        'Dongianhap',
        'Donvi'
    ];
}