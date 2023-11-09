USE QLKhachSan
GO
--Câu 1: Tạo thủ tục có đầu vào là mã khách hàng, năm, đầu ra là số lượng hóa đơn của mã mã khách hàng trong năm đó (năm được tính dựa trên ngày thanh toán).
CREATE OR ALTER PROCEDURE CAU1_PROC
(
	@MAKH NVARCHAR(20),
	@YEAR INT,
	@SL INT OUTPUT
)
AS 
BEGIN
	SELECT
		@SL = COUNT(HOADONTT.MaHDTT)
	FROM 
		HOADONTT
		INNER JOIN PHIEUDAT ON PHIEUDAT.MaBooking = HOADONTT.MaBooking
	WHERE PHIEUDAT.MaKH = @MAKH AND YEAR(HOADONTT.NgayTT) = @YEAR
END
GO

DECLARE @S INT
EXEC CAU1_PROC 'KH0003', 2022 , @S OUTPUT
PRINT N'SO LUONG HOA DON CUA MA KHACH HANG TRONG NAM DO LA: ' + CONVERT(NVARCHAR, @S)
GO

--Câu 2: Tạo hàm có đầu vào là mã loại phòng, đầu ra là danh sách các thông tin chi tiết các phòng của mã loại phòng đó, các thông tin đưa ra như bảng dưới đây (bảng ví dụ dưới có mã loại phòng là ‘Standard01’)

--Mã loại phòng | Kiểu phòng		| Diện tích	| Đơn giá phòng | Mã phòng
--Standard01	| Standard Single	| 20.1		| 2000000.00	| P101
--Standard01	| Standard Single	| 20.1		| 2000000.00	| P102
--Standard01	| Standard Single	| 20.1		| 2000000.00	| P501
--Standard01	| Standard Single	| 20.1		| 2000000.00	| P502

CREATE OR ALTER FUNCTION CAU2_FUNC 
(
	@MALP NVARCHAR(20)
)
RETURNS TABLE 
AS
RETURN
(
	SELECT 
		LOAIPHONG.MaLP,
		LOAIPHONG.Kieuphong,
		LOAIPHONG.Dientich,
		LOAIPHONG.Dongiaphong,
		PHONG.Maphong
	FROM 
		LOAIPHONG
		INNER JOIN PHONG ON PHONG.MaLP = LOAIPHONG.MaLP
	WHERE 
		LOAIPHONG.MaLP = @MALP
)
GO

SELECT * FROM CAU2_FUNC ('Standard01')
GO

--Câu 3: Thêm trường Số lượng phòng đặt vào bảng Phiếu đặt. Tạo Trigger cập nhật tự động cho trường này mỗi khi thêm, sửa, xóa một bản ghi ở bảng Chi tiết phòng đặt.


--Câu 4: Tạo View gồm các thông tin mã nhân viên, tên nhân viên, mã HDTT, Ngày lập HD, Ngày thanh toán, phương thức thanh toán, mã booking, ngày đến dự kiến, ngày đi dự kiến có ngày đến dự kiến từ ngày 12/12/2022 đến ngày 19/12/2022
CREATE OR ALTER VIEW CAU4_VIEW
AS
SELECT
	HOADONTT.MaNV,
	NHANVIEN.TenNV,
	HOADONTT.MaHDTT,
	HOADONTT.NgayLapHD,
	HOADONTT.NgayTT,
	HOADONTT.PhuongthucTT,
	HOADONTT.MaBooking,
	PHIEUDAT.NgayDenDukien,
	PHIEUDAT.NgayDiDuKien
FROM HOADONTT
	INNER JOIN NHANVIEN ON NHANVIEN.MaNV = HOADONTT.MaNV
	INNER JOIN PHIEUDAT ON PHIEUDAT.MaBooking = HOADONTT.MaBooking
WHERE PHIEUDAT.NgayDenDukien BETWEEN '2022-12-12' AND '2022-12-19' 
GO

SELECT * FROM CAU4_VIEW
GO
--Câu 5: 
--Tạo login NguyenDucThuan, tạo user NguyenDucThuan cho login NguyenDucThuan trên CSDL đã cho.
exec sp_addlogin NguyenDucThuan, 123
exec sp_adduser NguyenDucThuan, NguyenDucThuan
GO
--Phân quyền Select, Insert, update trên Bảng phiếu đặt cho NguyenDucThuan, và NguyenDucThuan được phép phân quyền cho người khác
grant select, insert, update on PhieuDat to NguyenDucThuan with grant option
GO
--Tạo login NguyenTienTai, tạo user NguyenTienTai cho login NguyenTienTai trên CSDL trên.
exec sp_addlogin NguyenTienTai, 123
exec sp_adduser NguyenTienTai, NguyenTienTai
GO
--Từ login NguyenDucThuan, phân quyền Select, update trên Bảng phiếu đặt cho NguyenTienTai.
grant select, update on PhieuDat to NguyenDucThuan
GO
--Câu 6: Tạo thủ tục có đầu vào là năm bắt đầu, năm kết thúc, đầu ra là ba tháng trong năm có tổng doanh thu cao nhất (ví dụ từ năm 2020 đến năm 2022 thì tháng 6, 7, 8 là những tháng có doanh thu cao nhất, tháng lấy theo ngày thanh toán).

--CREATE OR ALTER PROCEDURE CAU6_PROC
--(
--	@STARTYEAR INT,
--	@ENDYEAR INT
--)
--AS
--BEGIN
--	SELECT TOP 3
--END

SELECT
	MONTH(HOADONTT.NgayTT) AS THANG,
	SUM(LOAIPHONG.Dongiaphong* DATEDIFF(DAY, PHIEUTHUE.Thoigiancheckin,PHIEUTHUE.Thoigiancheckout)) AS DOANHTHU
FROM 
	PHIEUTHUE
	INNER JOIN PHIEUDAT ON PHIEUDAT.MaBooking = PHIEUTHUE.MaBooking
	INNER JOIN HOADONTT ON HOADONTT.MaBooking = PHIEUDAT.MaBooking
	INNER JOIN PHONG ON PHONG.Maphong = PHIEUTHUE.Maphong
	INNER JOIN LOAIPHONG ON LOAIPHONG.MaLP = PHONG.MaLP
WHERE (YEAR(Thoigiancheckout) BETWEEN 2020 AND 2022)
group by month(NgayTT)
ORDER BY SUM(LOAIPHONG.Dongiaphong* DATEDIFF(DAY, PHIEUTHUE.Thoigiancheckin,PHIEUTHUE.Thoigiancheckout)) DESC
