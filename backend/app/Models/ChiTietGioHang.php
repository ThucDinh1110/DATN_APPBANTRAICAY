<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ChiTietGioHang extends Model
{
    protected $table = 'chitietgiohang';
    protected $primaryKey = 'ChitietgiohangID';
    public $timestamps = false;

    protected $fillable = [
        'IDgiohang',
        'SanphamID',
        'Soluong',
    ];

    public function gioHang()
    {
        return $this->belongsTo(GioHang::class, 'IDgiohang', 'IDgiohang');
    }
}
