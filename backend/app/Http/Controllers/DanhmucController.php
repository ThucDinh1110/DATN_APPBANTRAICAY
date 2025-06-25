<?php

namespace App\Http\Controllers;

use App\Models\Danhmuc;
use Illuminate\Http\Request;

class DanhmucController extends Controller
{
    public function getAll()
    {
        $danhmucs = Danhmuc::all();
        return response()->json($danhmucs);
    }
}
