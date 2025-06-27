<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PhieuNhap extends Model
{
    protected $table = 'phieunhap';
    protected $primaryKey = 'PhieunhapID';
    public $timestamps = false;

    protected $fillable = [
        'Nhacungcap',
        'Nguoinhap',
        'Tongtiennhap',
        'Ghichu'
    ];

    public function chiTiet()
    {
        return $this->hasMany(ChiTietPhieuNhap::class, 'PhieunhapID');
    }
}
