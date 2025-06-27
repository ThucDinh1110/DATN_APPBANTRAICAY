<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ChiTietPhieuNhap extends Model
{
    protected $table = 'chitietphieunhap';
    public $timestamps = false;

    protected $fillable = [
        'PhieunhapID',
        'SanphamID',
        'Soluongnhap',
        'Dongianhap',
        'Donvi',
    ];

    public function sanpham()
    {
        return $this->belongsTo(Sanpham::class, 'SanphamID');
    }

    public function phieuNhap()
    {
        return $this->belongsTo(PhieuNhap::class, 'PhieunhapID');
    }
}
