<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;


class UserController extends Controller
{
    //
    public function profile(Request $request) {
    $userID = $request->user()->id;
    $profile = DB::table('user')
        ->leftJoin('user_thongtinnguoidung', 'user.UserID', '=', 'user_thongtinnguoidung.UserID')
        ->where('user.UserID', $userID)
        ->first();

    return response()->json($profile);
}
}
