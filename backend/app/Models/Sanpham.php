<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Sanpham extends Model
{
    protected $table = 'sanpham';
    protected $primaryKey = 'Idsp';
    public $timestamps = false;

    public function chitiet()
    {
        return $this->hasOne(Chitietsanpham::class, 'Idsp', 'Idsp');
    }
     public function danhmucs()
    {
        return $this->belongsToMany(Danhmuc::class, 'sanpham_danhmuc', 'Idsp', 'DanhmucID');
    }
}

