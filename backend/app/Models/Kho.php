<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Kho extends Model
{
    protected $table = 'kho';
    protected $primaryKey = 'KhoID';
    public $timestamps = false;

    protected $fillable = [
        'SanphamID', 'Soluongton', 'Donvi', 'Ngaycapnhat'
    ];
}
