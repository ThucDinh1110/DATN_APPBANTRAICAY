<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class User extends Model
{
    protected $table = 'user';              // Tên bảng trong database
    protected $primaryKey = 'UserID';       // Khóa chính của bảng

    public $timestamps = false;             // Bảng không có cột created_at và updated_at

    protected $fillable = [
        'AccountPhone',
        'Sodienthoai',
        'Matkhau',
        'Hoten',
        'Email',
        'Giotinh',
        'Phanquyen'
    ];

    protected $hidden = [
        'Matkhau', // Ẩn mật khẩu khi trả về JSON
    ];
}
