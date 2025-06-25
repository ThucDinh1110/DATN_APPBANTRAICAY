<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Chitietsanpham extends Model
{
    protected $table = 'chitietsanpham';
    protected $primaryKey = 'Idsp';
    public $timestamps = false;

    protected $fillable = [
        'Gia',
        'Donvi',
        'Hinhanh',
        'Mota',
        'VitaminA',
        'VitaminC',
        'Chatxo',
        'Duong',
        'Tinhbot',
    ];

    public function sanpham()
    {
        return $this->belongsTo(Sanpham::class, 'Idsp', 'Idsp');
    }
}
