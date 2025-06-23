<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Kho extends Model
{
    protected $table = 'kho';         // tên bảng trong DB

    protected $primaryKey = 'KhoID'; // nếu bạn dùng 'KhoID' là khóa chính

    public $timestamps = false;      // nếu bảng không có cột created_at, updated_at

    protected $fillable = [
        'SanphamID', 'Soluongton', 'Donvi', 'Ngaycapnhat'
    ];
}
