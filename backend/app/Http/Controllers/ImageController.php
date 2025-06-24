<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Image;
use Illuminate\Support\Facades\Storage;

class ImageController extends Controller
{
    public function upload(Request $request)
    {
        if (!$request->hasFile('image')) {
            return response()->json(['error' => 'Không có ảnh'], 400);
        }

        $file = $request->file('image');
        $filename = $file->getClientOriginalName(); // ❗ Không dùng time() nữa

        // Xóa ảnh cũ nếu trùng tên trong thư mục public/images
        $existingPath = 'public/images/' . $filename;
        if (Storage::exists($existingPath)) {
            Storage::delete($existingPath);
        }

        // Xóa bản ghi cũ trong database nếu có
        Image::where('name', $filename)->delete();

        // Lưu file mới
        $file->storeAs('images', $filename, 'public');

        // Tạo bản ghi mới trong DB
        $image = Image::create([
            'name' => $filename,
            'path' => 'storage/images/' . $filename,
        ]);

        return response()->json(['message' => 'Upload thành công', 'image' => $image], 200);
    }

    public function index()
    {
        return response()->json(Image::all());
    }

    public function delete($id)
    {
        $image = Image::find($id);
        if (!$image) {
            return response()->json(['error' => 'Không tìm thấy ảnh'], 404);
        }

        $filePath = storage_path('app/public/images/' . $image->name);
        if (file_exists($filePath)) {
            unlink($filePath);
        }

        $image->delete();

        return response()->json(['message' => 'Xóa ảnh thành công']);
    }
}
