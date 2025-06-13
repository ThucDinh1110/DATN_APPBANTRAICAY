<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Danhmuc extends Model
{
    protected $table = 'danhmuc';
    protected $primaryKey = 'DanhmucID';
    public $timestamps = false;

    public function sanphams()
    {
        return $this->belongsToMany(Sanpham::class, 'sanpham_danhmuc', 'DanhmucID', 'Idsp');
    }
}


