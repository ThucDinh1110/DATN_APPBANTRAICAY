-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th6 27, 2025 lúc 08:26 AM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `bantraicay`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chitietdonhang`
--

CREATE TABLE `chitietdonhang` (
  `ChitietdhID` int(11) NOT NULL,
  `DonhangID` int(11) DEFAULT NULL,
  `SanphamID` int(11) DEFAULT NULL,
  `Soluong` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `chitietdonhang`
--

INSERT INTO `chitietdonhang` (`ChitietdhID`, `DonhangID`, `SanphamID`, `Soluong`) VALUES
(1, 3, 1, 2),
(2, 3, 2, 1),
(3, 3, 4, 1),
(4, 4, 3, 2),
(5, 4, 4, 5),
(6, 5, 1, 4),
(7, 6, 10, 2),
(8, 7, 4, 2),
(9, 8, 5, 2),
(10, 9, 1, 4),
(11, 10, 1, 1),
(12, 11, 1, 1),
(13, 12, 1, 1),
(14, 13, 1, 1),
(15, 14, 1, 1),
(16, 15, 1, 1),
(17, 16, 1, 1),
(18, 17, 1, 1),
(19, 18, 1, 1),
(20, 19, 1, 1),
(21, 20, 1, 1),
(22, 21, 1, 1),
(23, 22, 1, 1),
(24, 23, 1, 1),
(25, 24, 1, 1),
(26, 25, 1, 1),
(27, 26, 1, 1),
(28, 27, 1, 1),
(29, 28, 1, 1),
(30, 29, 1, 1),
(31, 30, 11, 1),
(32, 31, 202, 1),
(33, 32, 5, 1),
(34, 32, 2, 1),
(35, 33, 11, 14),
(36, 34, 1, 13),
(37, 35, 1, 12),
(38, 36, 2, 29),
(39, 37, 2, 1),
(40, 38, 4, 12),
(41, 39, 5, 19),
(42, 40, 1, 5),
(43, 41, 1, 5),
(44, 42, 3, 1),
(45, 43, 5, 21),
(46, 43, 3, 3),
(47, 44, 1, 8),
(48, 45, 1, 2),
(49, 46, 1, 10),
(50, 47, 1, 10),
(51, 48, 3, 20),
(52, 49, 1, 10),
(53, 50, 1, 1),
(54, 51, 2, 1),
(55, 52, 2, 1),
(56, 52, 4, 1),
(57, 53, 3, 1),
(58, 53, 5, 1),
(60, 55, 3, 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chitietgiohang`
--

CREATE TABLE `chitietgiohang` (
  `ChitietgiohangID` int(11) NOT NULL,
  `IDgiohang` int(11) NOT NULL,
  `SanphamID` int(11) NOT NULL,
  `Soluong` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `chitietgiohang`
--

INSERT INTO `chitietgiohang` (`ChitietgiohangID`, `IDgiohang`, `SanphamID`, `Soluong`) VALUES
(37, 6, 1, 0),
(41, 5, 6, 0),
(48, 5, 3, 1),
(50, 6, 2, 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chitietphieunhap`
--

CREATE TABLE `chitietphieunhap` (
  `ChitietphieunhapID` int(11) NOT NULL,
  `PhieunhapID` int(11) DEFAULT NULL,
  `SanphamID` int(11) DEFAULT NULL,
  `Soluongnhap` int(11) DEFAULT NULL,
  `Dongianhap` decimal(18,2) DEFAULT NULL,
  `Donvi` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `chitietphieunhap`
--

INSERT INTO `chitietphieunhap` (`ChitietphieunhapID`, `PhieunhapID`, `SanphamID`, `Soluongnhap`, `Dongianhap`, `Donvi`) VALUES
(1, 1, 201, 12, 18000.00, 'kg'),
(2, 1, 202, 10, 50000.00, 'kg'),
(3, 1, 203, 20, 25000.00, 'kg'),
(4, 2, 1, 12, 18000.00, 'kg'),
(5, 2, 202, 10, 50000.00, 'kg'),
(6, 2, 203, 20, 25000.00, 'kg'),
(7, 3, 1, 12, 18000.00, 'kg'),
(8, 3, 2, 10, 50000.00, 'kg'),
(9, 3, 203, 20, 25000.00, 'kg'),
(10, 4, 1, 12, 18000.00, 'kg'),
(11, 4, 2, 10, 50000.00, 'kg'),
(12, 4, 203, 20, 25000.00, 'kg'),
(13, 5, 1, 12, 18000.00, 'kg'),
(14, 5, 2, 10, 50000.00, 'kg'),
(15, 5, 3, 20, 25000.00, 'kg'),
(16, 5, 4, 12, 18000.00, 'kg'),
(17, 5, 5, 10, 50000.00, 'kg'),
(18, 5, 6, 20, 25000.00, 'kg'),
(24, 7, 7, 12, 18000.00, 'kg'),
(25, 7, 8, 10, 50000.00, 'kg'),
(26, 7, 9, 20, 25000.00, 'kg'),
(27, 7, 10, 12, 18000.00, 'kg'),
(28, 7, 5, 10, 50000.00, 'kg'),
(29, 8, 11, 300, 90000.00, 'hộp'),
(30, 9, 11, 300, 90000.00, 'hộp'),
(31, 10, 11, 300, 90000.00, 'hộp'),
(32, 11, 11, 300, 90000.00, 'hộp');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chitietsanpham`
--

CREATE TABLE `chitietsanpham` (
  `ChitietspID` int(11) NOT NULL,
  `Idsp` int(11) DEFAULT NULL,
  `Hinhanh` longtext DEFAULT NULL,
  `Gia` decimal(18,2) DEFAULT NULL,
  `Donvi` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `Mota` longtext DEFAULT NULL,
  `VitaminA` double DEFAULT NULL,
  `VitaminC` double DEFAULT NULL,
  `Chatxo` double DEFAULT NULL,
  `Duong` double DEFAULT NULL,
  `Tinhbot` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `chitietsanpham`
--

INSERT INTO `chitietsanpham` (`ChitietspID`, `Idsp`, `Hinhanh`, `Gia`, `Donvi`, `Mota`, `VitaminA`, `VitaminC`, `Chatxo`, `Duong`, `Tinhbot`) VALUES
(1, 1, 'tao_do.jpg', 45000.00, 'kg', 'Táo đỏ Mỹ giòn ngọt, nhiều dưỡng chất', 56, 5, 2.4, 10, 13),
(2, 2, 'cam_sanh.jpg', 30000.00, 'kg', 'Cam sành mọng nước, vị ngọt đậm', 225, 48, 2, 9, 12),
(3, 3, 'chuoi.jpg', 25000.00, 'kg', 'Chuối già hương thơm tự nhiên, nhiều kali', 64, 12, 2.6, 14, 22),
(4, 4, 'xoai_cat.jpg', 50000.00, 'kg', 'Xoài cát Hòa Lộc thơm ngọt, vàng ươm', 108, 36, 1.6, 15, 20),
(5, 5, 'dua_hau.jpg', 18000.00, 'kg', 'Dưa hấu đỏ mọng, giải khát mùa hè', 28, 8, 0.4, 6, 8),
(6, 6, 'nho_den.jpg', 65000.00, 'kg', 'Nho đen không hạt giàu chất chống oxy hóa', 66, 10, 0.9, 16, 17),
(7, 7, 'buoi.jpg', 40000.00, 'kg', 'Bưởi da xanh tép to, vị chua ngọt', 58, 38, 1.8, 9, 11),
(8, 8, 'mang_cut.jpg', 80000.00, 'kg', 'Măng cụt Thái Lan ngọt thanh, mềm dịu', 45, 7, 1.5, 17, 21),
(9, 9, 'dua_thom.jpg', 20000.00, 'kg', 'Dứa thơm miền Tây, thơm đậm đà', 68, 47, 1.4, 12, 14),
(10, 10, 'oi_le.jpg', 35000.00, 'kg', 'Ổi lê Đài Loan giòn, ít hạt, nhiều vitamin', 55, 58, 2.8, 8, 10),
(11, 201, 'duahau.jpg', 18000.00, 'kg', 'Dưa ngọt mát lạnh', 0.12, 0.4, 0.8, 8.5, 1.2),
(12, 202, 'kiwi.jpg', 50000.00, 'kg', 'Kiwi xanh nhập từ New Zealand', 0.3, 1, 2.1, 9.1, 1),
(13, 203, 'xoai.jpg', 25000.00, 'kg', 'Xoài thơm ngọt, ít xơ', 0.1, 0.5, 1.5, 11, 0.5),
(14, 11, 'dauhan.jpg', 90000.00, 'hộp', 'taone', 0.015, 58, 2, 5, 1.2);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `danhmuc`
--

CREATE TABLE `danhmuc` (
  `DanhmucID` int(11) NOT NULL,
  `Tendanhmuc` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `danhmuc`
--

INSERT INTO `danhmuc` (`DanhmucID`, `Tendanhmuc`) VALUES
(1, 'Trái Cây Việt Nam'),
(2, 'Trái Cây Nhập Khẩu'),
(3, 'Giàu Vitamin C'),
(4, 'Trái cây mùa hè');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `diachigiaohang`
--

CREATE TABLE `diachigiaohang` (
  `DiachigiaoID` int(11) NOT NULL,
  `Hoten` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `UserID` int(11) DEFAULT NULL,
  `Sodienthoai` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `Diachi` longtext DEFAULT NULL,
  `is_default` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `diachigiaohang`
--

INSERT INTO `diachigiaohang` (`DiachigiaoID`, `Hoten`, `UserID`, `Sodienthoai`, `Diachi`, `is_default`) VALUES
(1, 'Đinh Nhật Thức', 6, '0984544197', 'Xóm mới 2, Xã Trí Bình, Huyện Châu Thành, Tp.Tây Ninh', 0),
(2, 'Lê Khách 1', 2, '0911000002', '118/14/15, Hòa Bình, Tân Phú', 0),
(3, 'Đinh Nhật Thức', 6, '0984544197', '118/14/15, Hòa Bình, Tân Phú', 1),
(4, 'Thức Đinh', 6, '0868890617', 'Tp.Hồ Chí Minh', 0),
(5, 'nam', 8, '0363958371', 'ninhthuan', 1),
(6, 'hai', 9, '0362114365', 'hn', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `donhang`
--

CREATE TABLE `donhang` (
  `DonhangID` int(11) NOT NULL,
  `IDuser` int(11) DEFAULT NULL,
  `KhuyenmaiID` int(11) DEFAULT NULL,
  `ThanhtoanID` int(11) DEFAULT NULL,
  `DiachigiaoID` int(11) DEFAULT NULL,
  `Ngaydat` datetime DEFAULT current_timestamp(),
  `Tongtien` decimal(18,2) DEFAULT NULL,
  `Trangthai` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `GhiChu` text DEFAULT NULL,
  `MaDonHang` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `donhang`
--

INSERT INTO `donhang` (`DonhangID`, `IDuser`, `KhuyenmaiID`, `ThanhtoanID`, `DiachigiaoID`, `Ngaydat`, `Tongtien`, `Trangthai`, `GhiChu`, `MaDonHang`) VALUES
(3, 2, NULL, 2, 2, '2025-06-18 14:14:57', 170000.00, 'Đã mua', NULL, 'OV250618141457897'),
(4, 6, NULL, 2, 1, '2025-06-19 10:32:10', 300000.00, 'Đã hủy', NULL, 'OV250619103210638'),
(5, 6, NULL, 2, 1, '2025-06-19 11:29:46', 180000.00, 'Đã mua', NULL, 'OV250619112946249'),
(6, 6, NULL, 1, 1, '2025-06-20 04:35:22', 70000.00, 'Đã hủy', 'giao sớm nhất có thể nha', 'OV250620043522686'),
(7, 6, NULL, 2, 3, '2025-06-20 09:26:02', 100000.00, 'Đơn hàng đã hủy', NULL, 'OV250620092602219'),
(8, 6, NULL, 1, 3, '2025-06-20 10:50:08', 36000.00, 'Đang giao', NULL, 'OV250620105008187'),
(9, 8, NULL, 1, 5, '2025-06-25 09:38:56', 180000.00, 'Đã duyệt', NULL, 'OV250625093856231'),
(10, 8, NULL, 1, 5, '2025-06-25 10:04:00', 45000.00, 'Hủy tạm thời', NULL, 'OV250625100400206'),
(11, 8, NULL, 1, 5, '2025-06-25 10:08:52', 45000.00, 'Đã hủy', NULL, 'OV250625100852208'),
(12, 8, NULL, 2, 5, '2025-06-25 10:09:06', 45000.00, 'Đã hủy', NULL, 'OV250625100906649'),
(13, 8, NULL, 2, 5, '2025-06-25 10:09:08', 45000.00, 'Đã hủy', NULL, 'OV250625100908629'),
(14, 8, NULL, 2, 5, '2025-06-25 10:09:09', 45000.00, 'Đã hủy', NULL, 'OV250625100909626'),
(15, 8, NULL, 2, 5, '2025-06-25 10:09:10', 45000.00, 'Đã hủy', NULL, 'OV250625100910598'),
(16, 8, NULL, 2, 5, '2025-06-25 10:09:10', 45000.00, 'Đã hủy', NULL, 'OV250625100910626'),
(17, 8, NULL, 2, 5, '2025-06-25 10:09:10', 45000.00, 'Đã hủy', NULL, 'OV250625100910360'),
(18, 8, NULL, 2, 5, '2025-06-25 10:09:11', 45000.00, 'Đã hủy', NULL, 'OV250625100911356'),
(19, 8, NULL, 2, 5, '2025-06-25 10:09:11', 45000.00, 'Đã hủy', NULL, 'OV250625100911787'),
(20, 8, NULL, 2, 5, '2025-06-25 10:09:12', 45000.00, 'Đã hủy', NULL, 'OV250625100912350'),
(21, 8, NULL, 1, 5, '2025-06-25 10:12:57', 45000.00, 'Đã hủy', NULL, 'OV250625101257359'),
(22, 8, NULL, 1, 5, '2025-06-25 10:13:01', 45000.00, 'Đã hủy', NULL, 'OV250625101301359'),
(23, 8, NULL, 1, 5, '2025-06-25 10:13:02', 45000.00, 'Đã hủy', NULL, 'OV250625101302803'),
(24, 8, NULL, 1, 5, '2025-06-25 10:13:04', 45000.00, 'Đã hủy', NULL, 'OV250625101304915'),
(25, 8, NULL, 1, 5, '2025-06-25 10:13:05', 45000.00, 'Đã hủy', NULL, 'OV250625101305263'),
(26, 8, NULL, 1, 5, '2025-06-25 10:13:07', 45000.00, 'Đã hủy', NULL, 'OV250625101307776'),
(27, 8, NULL, 1, 5, '2025-06-25 10:13:08', 45000.00, 'Đã hủy', NULL, 'OV250625101308844'),
(28, 8, NULL, 1, 5, '2025-06-25 10:13:10', 45000.00, 'Đã hủy', NULL, 'OV250625101310884'),
(29, 8, NULL, 1, 5, '2025-06-25 10:19:39', 45000.00, 'Đã hủy', NULL, 'OV250625101939972'),
(30, 8, NULL, 1, 5, '2025-06-25 10:34:37', 90000.00, 'Đã hủy', NULL, 'OV250625103437859'),
(31, 8, NULL, 1, 5, '2025-06-25 10:36:50', 50000.00, 'Đã hủy', NULL, 'OV250625103650102'),
(32, 8, NULL, 1, 5, '2025-06-25 10:37:33', 48000.00, 'Đã hủy', NULL, 'OV250625103733584'),
(33, 8, NULL, 1, 5, '2025-06-25 10:44:42', 1260000.00, 'Đã hủy', NULL, 'OV250625104442547'),
(34, 8, NULL, 1, 5, '2025-06-25 10:45:59', 585000.00, 'Đã hủy', NULL, 'OV250625104559951'),
(35, 8, NULL, 1, 5, '2025-06-25 10:47:13', 540000.00, 'Đã hủy', NULL, 'OV250625104713458'),
(36, 8, NULL, 1, 5, '2025-06-25 10:48:58', 870000.00, 'Đã hủy', NULL, 'OV250625104858534'),
(37, 8, NULL, 1, 5, '2025-06-25 10:49:33', 30000.00, 'Đã hủy', NULL, 'OV250625104933405'),
(38, 8, NULL, 1, 5, '2025-06-25 10:56:45', 600000.00, 'Đã hủy', NULL, 'OV250625105645569'),
(39, 8, NULL, 1, 5, '2025-06-25 11:14:26', 342000.00, 'Đã hủy', NULL, 'OV250625111426734'),
(40, 9, NULL, 1, 6, '2025-06-25 11:22:57', 225000.00, 'Đã hủy', 'h', 'OV250625112257698'),
(41, 8, NULL, 1, 5, '2025-06-25 11:24:05', 225000.00, 'Đã hủy', 're', 'OV250625112405325'),
(42, 9, NULL, 1, 6, '2025-06-25 11:28:28', 25000.00, 'Đã hủy', NULL, 'OV250625112828997'),
(43, 9, NULL, 1, 6, '2025-06-25 11:37:29', 453000.00, 'Đã duyệt', 'cc', 'OV250625113729638'),
(44, 9, NULL, 1, 6, '2025-06-25 13:02:50', 360000.00, 'Đã hủy', NULL, 'OV250625130250540'),
(45, 9, NULL, 1, 6, '2025-06-25 13:32:33', 90000.00, 'Đã duyệt', NULL, 'OV250625133233558'),
(46, 9, NULL, 1, 6, '2025-06-25 13:37:24', 450000.00, 'Chờ duyệt', NULL, 'OV250625133724772'),
(47, 9, NULL, 1, 6, '2025-06-25 13:45:05', 450000.00, 'Đã hủy', NULL, 'OV250625134505357'),
(48, 9, NULL, 1, 6, '2025-06-25 13:59:55', 500000.00, 'Chờ duyệt', NULL, 'OV250625135955635'),
(49, 8, NULL, 1, 5, '2025-06-25 14:10:06', 450000.00, 'Chờ duyệt', NULL, 'OV250625141006128'),
(50, 8, NULL, 1, 5, '2025-06-26 02:51:49', 45000.00, 'Chờ duyệt', NULL, 'OV250626025149391'),
(51, 8, NULL, 1, 5, '2025-06-26 03:03:15', 30000.00, 'Chờ duyệt', NULL, 'OV250626030315972'),
(52, 8, NULL, 1, 5, '2025-06-26 03:12:07', 80000.00, 'Chờ duyệt', NULL, 'OV250626031207111'),
(53, 9, NULL, 1, 6, '2025-06-26 03:19:15', 43000.00, 'Đã duyệt', 'chuoine', 'OV250626031915274'),
(54, 9, NULL, 1, 6, '2025-06-26 03:34:23', 30000.00, 'Đã hủy', NULL, 'OV250626033423341'),
(55, 9, NULL, 1, 6, '2025-06-27 02:35:38', 25000.00, 'Chờ duyệt', 'chuooi', 'OV250627023538530');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `giohang`
--

CREATE TABLE `giohang` (
  `IDgiohang` int(11) NOT NULL,
  `IDuser` int(11) DEFAULT NULL,
  `Trangthai` bit(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `giohang`
--

INSERT INTO `giohang` (`IDgiohang`, `IDuser`, `Trangthai`) VALUES
(1, 2, b'00000000001'),
(3, 6, b'00000000001'),
(4, 7, b'00000000001'),
(5, 8, b'00000000001'),
(6, 9, b'00000000001');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `images`
--

CREATE TABLE `images` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `path` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `images`
--

INSERT INTO `images` (`id`, `name`, `path`, `created_at`, `updated_at`) VALUES
(1, 'cam_sanh.jpg', 'storage/images/cam_sanh.jpg', '2025-06-25 01:56:31', '2025-06-25 01:56:31'),
(2, 'dua_hau.jpg', 'storage/images/dua_hau.jpg', '2025-06-25 02:08:13', '2025-06-25 02:08:13'),
(3, 'qc4.jpg', 'storage/images/qc4.jpg', '2025-06-25 02:22:34', '2025-06-25 02:22:34'),
(4, 'camnavel.jpg', 'storage/images/camnavel.jpg', '2025-06-25 02:35:10', '2025-06-25 02:35:10'),
(5, 'chuoi.jpg', 'storage/images/chuoi.jpg', '2025-06-25 02:35:20', '2025-06-25 02:35:20'),
(6, 'chuoi_laba.jpg', 'storage/images/chuoi_laba.jpg', '2025-06-25 02:35:28', '2025-06-25 02:35:28'),
(7, 'dauhan.jpg', 'storage/images/dauhan.jpg', '2025-06-25 02:35:34', '2025-06-25 02:35:34'),
(8, 'dualuoi_nhat.jpg', 'storage/images/dualuoi_nhat.jpg', '2025-06-25 02:35:42', '2025-06-25 02:35:42'),
(9, 'kiwi.jpg', 'storage/images/kiwi.jpg', '2025-06-25 02:35:49', '2025-06-25 02:35:49'),
(10, 'qc1.jpg', 'storage/images/qc1.jpg', '2025-06-25 02:36:04', '2025-06-25 02:36:04'),
(11, 'qc2.jpg', 'storage/images/qc2.jpg', '2025-06-25 02:36:11', '2025-06-25 02:36:11'),
(12, 'nho_den.jpg', 'storage/images/nho_den.jpg', '2025-06-25 07:23:54', '2025-06-25 07:23:54'),
(14, 'qc3.jpg', 'storage/images/qc3.jpg', '2025-06-25 19:01:47', '2025-06-25 19:01:47');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `kho`
--

CREATE TABLE `kho` (
  `KhoID` int(11) NOT NULL,
  `SanphamID` int(11) DEFAULT NULL,
  `Soluongton` int(11) DEFAULT NULL,
  `Donvi` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `Ngaycapnhat` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `kho`
--

INSERT INTO `kho` (`KhoID`, `SanphamID`, `Soluongton`, `Donvi`, `Ngaycapnhat`) VALUES
(1, 201, 12, 'kg', '2025-06-25'),
(2, 202, 24, 'kg', '2025-06-25'),
(3, 203, 80, 'kg', '2025-06-25'),
(4, 1, 0, 'kg', '2025-06-25'),
(5, 2, 297, 'kg', '2025-06-25'),
(6, 3, 198, 'kg', '2025-06-25'),
(7, 4, 99, 'kg', '2025-06-25'),
(8, 5, 49, 'kg', '2025-06-25'),
(9, 6, 20, 'kg', '2025-06-25'),
(14, 7, 12, 'kg', '2025-06-25'),
(15, 8, 10, 'kg', '2025-06-25'),
(16, 9, 20, 'kg', '2025-06-25'),
(17, 10, 12, 'kg', '2025-06-25'),
(18, 11, 1185, 'hộp', '2025-06-27');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `khuyenmai`
--

CREATE TABLE `khuyenmai` (
  `KhuyenmaiID` int(11) NOT NULL,
  `Tenkhuyenmai` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `Mota` longtext DEFAULT NULL,
  `Phamtramgiamgia` double DEFAULT NULL,
  `Ngaybatdau` date DEFAULT NULL,
  `Ngayketthuc` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2025_06_25_085041_create_images_table', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `phieunhap`
--

CREATE TABLE `phieunhap` (
  `PhieunhapID` int(11) NOT NULL,
  `Ngaynhap` date DEFAULT current_timestamp(3),
  `Nhacungcap` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `Nguoinhap` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `Tongtiennhap` decimal(18,2) DEFAULT NULL,
  `Ghichu` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `phieunhap`
--

INSERT INTO `phieunhap` (`PhieunhapID`, `Ngaynhap`, `Nhacungcap`, `Nguoinhap`, `Tongtiennhap`, `Ghichu`) VALUES
(1, '2025-06-25', 'hai', 'ba', 1216000.00, 'hhahha'),
(2, '2025-06-25', 'h', 's', 1216000.00, NULL),
(3, '2025-06-25', 's', 's', 1216000.00, 's'),
(4, '2025-06-25', 'á', 's', 1216000.00, NULL),
(5, '2025-06-25', 's', 's', 2432000.00, NULL),
(7, '2025-06-25', 'h', 'h', 1932000.00, NULL),
(8, '2025-06-25', 'dau', 'dau', 27000000.00, NULL),
(9, '2025-06-27', 'hai', 'nh', 27000000.00, NULL),
(10, '2025-06-27', 'ss', 's', 27000000.00, NULL),
(11, '2025-06-27', 's', 's', 27000000.00, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sanpham`
--

CREATE TABLE `sanpham` (
  `Idsp` int(11) NOT NULL,
  `Tensp` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `Trangthai` tinyint(4) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `sanpham`
--

INSERT INTO `sanpham` (`Idsp`, `Tensp`, `Trangthai`) VALUES
(1, 'Táo đỏ Mỹ', 1),
(2, 'Cam sành', 1),
(3, 'Chuối già hương', 1),
(4, 'Xoài cát Hòa Lộc', 1),
(5, 'Dưa hấu Long An', 1),
(6, 'Nho đen không hạt', 1),
(7, 'Bưởi da xanh', 0),
(8, 'Măng cụt Thái Lan', 0),
(9, 'Dứa (thơm) miền Tây', 0),
(10, 'Ổi lê Đài Loan', 0),
(11, 'Dâu Hàn', 1),
(201, 'Dưa hấu Long An', 0),
(202, 'Kiwi Zespri', 1),
(203, 'Xoài cát Hòa Lộc', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sanpham_danhmuc`
--

CREATE TABLE `sanpham_danhmuc` (
  `Idsp` int(11) NOT NULL,
  `DanhmucID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `sanpham_danhmuc`
--

INSERT INTO `sanpham_danhmuc` (`Idsp`, `DanhmucID`) VALUES
(1, 2),
(2, 1),
(2, 3),
(2, 4),
(3, 1),
(3, 4),
(4, 1),
(4, 3),
(4, 4),
(5, 1),
(6, 2),
(6, 4),
(7, 1),
(8, 2),
(9, 1),
(10, 2),
(11, 1),
(11, 2),
(202, 2),
(202, 3),
(203, 1),
(203, 3),
(203, 4);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `thanhtoan`
--

CREATE TABLE `thanhtoan` (
  `ThanhtoanID` int(11) NOT NULL,
  `Phuongthuc` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `Dathanhtoan` tinyint(4) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `thanhtoan`
--

INSERT INTO `thanhtoan` (`ThanhtoanID`, `Phuongthuc`, `Dathanhtoan`) VALUES
(1, 'Thanh toán khi nhận hàng', 0),
(2, 'Chuyển khoản', 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user`
--

CREATE TABLE `user` (
  `UserID` int(11) NOT NULL,
  `AccountPhone` varchar(20) NOT NULL,
  `Sodienthoai` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `Matkhau` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `Email` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `Hoten` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `Gioitinh` tinyint(4) DEFAULT NULL,
  `Ngaytao` date DEFAULT current_timestamp(3),
  `Phanquyen` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT 'khach',
  `Trangthai` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `user`
--

INSERT INTO `user` (`UserID`, `AccountPhone`, `Sodienthoai`, `Matkhau`, `Email`, `Hoten`, `Gioitinh`, `Ngaytao`, `Phanquyen`, `Trangthai`) VALUES
(1, '0868890617', '0868890617', '$2y$12$VXc6HmKA45pxikMbxuSXQOoexT5PeVmq5v.F/VJd3EEdCF9oOCJ/m', 'admin@example.com', 'Nguyễn Admin', NULL, '2025-06-10', 'Admin', 1),
(2, 'kh001', '0911000002', '$2y$12$TbNPuPsWPGJtRxalKKXNZOZ7LUnSKQ3N/1vsJileGxAeU2KFR8eJ6', 'kh1@example.com', 'Lê Khách 1', 1, '2025-06-10', 'Customer', 0),
(6, '0984544197', '0984544197', '$2y$12$Cwfx0XpPKW2IpT0Vz5u/5OdSJ6xmKZ9EsSS4q51SerzYnZVeXRQey', 'dthuc771@gmail.com', 'Đinh Nhật Thức', 1, '2025-06-12', 'Customer', 1),
(7, '1111111111', '1111111111', '$2y$12$kvXb48cdi9D2m65Kk67zdOhfaSH.38fI.JOE1KdxDFk53U9Do1ehm', 'hai@123gmail.com', 'hai', NULL, '2025-06-25', 'Admin', 1),
(8, '0363958888', '0363958888', '$2y$12$ipaW9bvophvcppG1cMhU4.W/ialQ3HNB6/lWMPi1FQAQcGpJjtNYm', 'nam@gmail.com', 'nam', 1, '2025-06-25', 'Customer', 1),
(9, '0362114365', '0362114365', '$2y$12$8q0yjv49npk1xZF.BwgRyuZfkrMlXWsPJhJ8kdUFX.UqTOZspocnS', 'tr@gmail.com', 't', NULL, '2025-06-25', 'Customer', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user_thongtinnguoidung`
--

CREATE TABLE `user_thongtinnguoidung` (
  `UserID` int(11) NOT NULL,
  `Chieucao` int(11) DEFAULT NULL,
  `Cannang` int(11) DEFAULT NULL,
  `Diachi` longtext DEFAULT NULL,
  `Nhucau` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `user_thongtinnguoidung`
--

INSERT INTO `user_thongtinnguoidung` (`UserID`, `Chieucao`, `Cannang`, `Diachi`, `Nhucau`) VALUES
(2, 0, 0, '118/14/15, Hòa Bình, Tân Phú', NULL),
(6, 175, 95, 'Xóm mới 2, Trí Bình, Châu Thành,  Tây Ninh', NULL),
(8, 165, 55, 'ninhthuan', 'Giảm cân');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `chitietdonhang`
--
ALTER TABLE `chitietdonhang`
  ADD PRIMARY KEY (`ChitietdhID`),
  ADD KEY `DonhangID` (`DonhangID`),
  ADD KEY `SanphamID` (`SanphamID`);

--
-- Chỉ mục cho bảng `chitietgiohang`
--
ALTER TABLE `chitietgiohang`
  ADD PRIMARY KEY (`ChitietgiohangID`),
  ADD KEY `IDgiohang` (`IDgiohang`),
  ADD KEY `SanphamID` (`SanphamID`);

--
-- Chỉ mục cho bảng `chitietphieunhap`
--
ALTER TABLE `chitietphieunhap`
  ADD PRIMARY KEY (`ChitietphieunhapID`),
  ADD KEY `PhieunhapID` (`PhieunhapID`),
  ADD KEY `SanphamID` (`SanphamID`);

--
-- Chỉ mục cho bảng `chitietsanpham`
--
ALTER TABLE `chitietsanpham`
  ADD PRIMARY KEY (`ChitietspID`),
  ADD KEY `FK__Chitietsan__Idsp__2A4B4B5E` (`Idsp`);

--
-- Chỉ mục cho bảng `danhmuc`
--
ALTER TABLE `danhmuc`
  ADD PRIMARY KEY (`DanhmucID`);

--
-- Chỉ mục cho bảng `diachigiaohang`
--
ALTER TABLE `diachigiaohang`
  ADD PRIMARY KEY (`DiachigiaoID`),
  ADD KEY `FK_Diachigiaohang_User` (`UserID`);

--
-- Chỉ mục cho bảng `donhang`
--
ALTER TABLE `donhang`
  ADD PRIMARY KEY (`DonhangID`),
  ADD KEY `DiachigiaoID` (`DiachigiaoID`),
  ADD KEY `KhuyenmaiID` (`KhuyenmaiID`),
  ADD KEY `ThanhtoanID` (`ThanhtoanID`),
  ADD KEY `FK_Donhang_User` (`IDuser`);

--
-- Chỉ mục cho bảng `giohang`
--
ALTER TABLE `giohang`
  ADD PRIMARY KEY (`IDgiohang`),
  ADD KEY `FK_Giohang_User` (`IDuser`);

--
-- Chỉ mục cho bảng `images`
--
ALTER TABLE `images`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `kho`
--
ALTER TABLE `kho`
  ADD PRIMARY KEY (`KhoID`),
  ADD KEY `SanphamID` (`SanphamID`);

--
-- Chỉ mục cho bảng `khuyenmai`
--
ALTER TABLE `khuyenmai`
  ADD PRIMARY KEY (`KhuyenmaiID`);

--
-- Chỉ mục cho bảng `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `phieunhap`
--
ALTER TABLE `phieunhap`
  ADD PRIMARY KEY (`PhieunhapID`);

--
-- Chỉ mục cho bảng `sanpham`
--
ALTER TABLE `sanpham`
  ADD PRIMARY KEY (`Idsp`);

--
-- Chỉ mục cho bảng `sanpham_danhmuc`
--
ALTER TABLE `sanpham_danhmuc`
  ADD PRIMARY KEY (`Idsp`,`DanhmucID`),
  ADD KEY `DanhmucID` (`DanhmucID`);

--
-- Chỉ mục cho bảng `thanhtoan`
--
ALTER TABLE `thanhtoan`
  ADD PRIMARY KEY (`ThanhtoanID`);

--
-- Chỉ mục cho bảng `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `AccountPhone` (`AccountPhone`),
  ADD UNIQUE KEY `Email` (`Email`);

--
-- Chỉ mục cho bảng `user_thongtinnguoidung`
--
ALTER TABLE `user_thongtinnguoidung`
  ADD PRIMARY KEY (`UserID`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `chitietdonhang`
--
ALTER TABLE `chitietdonhang`
  MODIFY `ChitietdhID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT cho bảng `chitietgiohang`
--
ALTER TABLE `chitietgiohang`
  MODIFY `ChitietgiohangID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT cho bảng `chitietphieunhap`
--
ALTER TABLE `chitietphieunhap`
  MODIFY `ChitietphieunhapID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT cho bảng `chitietsanpham`
--
ALTER TABLE `chitietsanpham`
  MODIFY `ChitietspID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT cho bảng `danhmuc`
--
ALTER TABLE `danhmuc`
  MODIFY `DanhmucID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `diachigiaohang`
--
ALTER TABLE `diachigiaohang`
  MODIFY `DiachigiaoID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `donhang`
--
ALTER TABLE `donhang`
  MODIFY `DonhangID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- AUTO_INCREMENT cho bảng `giohang`
--
ALTER TABLE `giohang`
  MODIFY `IDgiohang` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `images`
--
ALTER TABLE `images`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT cho bảng `kho`
--
ALTER TABLE `kho`
  MODIFY `KhoID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT cho bảng `khuyenmai`
--
ALTER TABLE `khuyenmai`
  MODIFY `KhuyenmaiID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `phieunhap`
--
ALTER TABLE `phieunhap`
  MODIFY `PhieunhapID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT cho bảng `sanpham`
--
ALTER TABLE `sanpham`
  MODIFY `Idsp` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=204;

--
-- AUTO_INCREMENT cho bảng `thanhtoan`
--
ALTER TABLE `thanhtoan`
  MODIFY `ThanhtoanID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `user`
--
ALTER TABLE `user`
  MODIFY `UserID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `chitietdonhang`
--
ALTER TABLE `chitietdonhang`
  ADD CONSTRAINT `chitietdonhang_ibfk_1` FOREIGN KEY (`DonhangID`) REFERENCES `donhang` (`DonhangID`),
  ADD CONSTRAINT `chitietdonhang_ibfk_2` FOREIGN KEY (`SanphamID`) REFERENCES `sanpham` (`Idsp`);

--
-- Các ràng buộc cho bảng `chitietgiohang`
--
ALTER TABLE `chitietgiohang`
  ADD CONSTRAINT `chitietgiohang_ibfk_1` FOREIGN KEY (`IDgiohang`) REFERENCES `giohang` (`IDgiohang`),
  ADD CONSTRAINT `chitietgiohang_ibfk_2` FOREIGN KEY (`SanphamID`) REFERENCES `sanpham` (`Idsp`);

--
-- Các ràng buộc cho bảng `chitietphieunhap`
--
ALTER TABLE `chitietphieunhap`
  ADD CONSTRAINT `chitietphieunhap_ibfk_1` FOREIGN KEY (`PhieunhapID`) REFERENCES `phieunhap` (`PhieunhapID`),
  ADD CONSTRAINT `chitietphieunhap_ibfk_2` FOREIGN KEY (`SanphamID`) REFERENCES `sanpham` (`Idsp`);

--
-- Các ràng buộc cho bảng `chitietsanpham`
--
ALTER TABLE `chitietsanpham`
  ADD CONSTRAINT `FK__Chitietsan__Idsp__2A4B4B5E` FOREIGN KEY (`Idsp`) REFERENCES `sanpham` (`Idsp`);

--
-- Các ràng buộc cho bảng `diachigiaohang`
--
ALTER TABLE `diachigiaohang`
  ADD CONSTRAINT `FK_Diachigiaohang_User` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`);

--
-- Các ràng buộc cho bảng `donhang`
--
ALTER TABLE `donhang`
  ADD CONSTRAINT `FK_Donhang_User` FOREIGN KEY (`IDuser`) REFERENCES `user` (`UserID`),
  ADD CONSTRAINT `donhang_ibfk_1` FOREIGN KEY (`DiachigiaoID`) REFERENCES `diachigiaohang` (`DiachigiaoID`),
  ADD CONSTRAINT `donhang_ibfk_2` FOREIGN KEY (`KhuyenmaiID`) REFERENCES `khuyenmai` (`KhuyenmaiID`),
  ADD CONSTRAINT `donhang_ibfk_3` FOREIGN KEY (`ThanhtoanID`) REFERENCES `thanhtoan` (`ThanhtoanID`);

--
-- Các ràng buộc cho bảng `giohang`
--
ALTER TABLE `giohang`
  ADD CONSTRAINT `FK_Giohang_User` FOREIGN KEY (`IDuser`) REFERENCES `user` (`UserID`);

--
-- Các ràng buộc cho bảng `kho`
--
ALTER TABLE `kho`
  ADD CONSTRAINT `kho_ibfk_1` FOREIGN KEY (`SanphamID`) REFERENCES `sanpham` (`Idsp`);

--
-- Các ràng buộc cho bảng `sanpham_danhmuc`
--
ALTER TABLE `sanpham_danhmuc`
  ADD CONSTRAINT `sanpham_danhmuc_ibfk_1` FOREIGN KEY (`DanhmucID`) REFERENCES `danhmuc` (`DanhmucID`) ON DELETE CASCADE,
  ADD CONSTRAINT `sanpham_danhmuc_ibfk_2` FOREIGN KEY (`Idsp`) REFERENCES `sanpham` (`Idsp`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `user_thongtinnguoidung`
--
ALTER TABLE `user_thongtinnguoidung`
  ADD CONSTRAINT `FK_User_thongtinnguoidung_User` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
