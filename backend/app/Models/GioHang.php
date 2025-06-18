<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class GioHang extends Model
{
    protected $table = 'giohang';
    protected $primaryKey = 'IDgiohang';
    public $timestamps = false;

    protected $fillable = [
        'IDuser',
        'Trangthai',
    ];

    public function chiTietGioHang()
    {
        return $this->hasMany(ChiTietGioHang::class, 'IDgiohang', 'IDgiohang');
    }
}
