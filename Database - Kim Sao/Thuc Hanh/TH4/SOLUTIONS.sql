USE QLKhachSan
GO

--	Câu 1: Tạo thủ tục có đầu vào là số điện thoại khách hàng, năm, đầu ra là số lượng phiếu đặt của khách hàng đó trong năm đó (năm được tính dựa trên ngày đến dự kiến).
CREATE OR ALTER PROCEDURE CAU1_PROC
(
	@SDT NVARCHAR (10),
	@YEAR INT,
	@SLPHIEU INT OUTPUT
)
AS
BEGIN
SELECT
	@SLPHIEU = COUNT(HOADONTT.MaBooking)
FROM HOADONTT
INNER JOIN PHIEUDAT ON PHIEUDAT.MaBooking= HOADONTT.MaBooking
INNER JOIN KHACHHANG ON KHACHHANG.MaKH = PHIEUDAT.MaKH
WHERE YEAR(PHIEUDAT.NgayDenDukien) = @YEAR AND KHACHHANG.Dienthoai = @SDT
END
GO
-- Test 
DECLARE @SDT NVARCHAR(10) = '0987654321'
DECLARE @YEAR INT = 2022 
DECLARE @SLPHIEU INT
EXEC CAU1_PROC @SDT, @YEAR, @SLPHIEU OUTPUT
SELECT @SLPHIEU AS 'BookingCount'
GO
--Câu 2: Tạo hàm có đầu vào là Ngày, đầu ra là danh sách các thông tin chi tiết phòng đặt dự kiến đến trong ngày đó, các thông tin đưa ra như bảng dưới đây (bảng ví dụ dưới có ngày là ‘09/01/2022’)

--Mã booking | Ngày đến dự kiến | Ngày đi dự kiến | Kiểu phòng		|Số lượng phòng
--PD0001     | 2022-01-09       | 2022-01-12      | Deluxe Single   | 3
--PD0001     | 2022-01-09       | 2022-01-12      | Standard Single | 2
--PD0002     | 2022-01-09       | 2022-01-21      | Standard Single | 4
--PD0002     | 2022-01-09       | 2022-01-21	  | Standard Twin   | 1

CREATE OR ALTER PROCEDURE CAU2_PROC
(
	@DATE DATE
)
AS
BEGIN
	SELECT 
		PHIEUDAT.MaBooking, 
		PHIEUDAT.NgayDenDukien,
		PHIEUDAT.NgayDiDukien,
		LOAIPHONG.Kieuphong,
		CHITIETPHONGDAT.SLPhong
	FROM PHIEUDAT
	INNER JOIN CHITIETPHONGDAT ON CHITIETPHONGDAT.MaBooking = PHIEUDAT.MaBooking
	INNER JOIN.LOAIPHONG ON LOAIPHONG.MaLP = CHITIETPHONGDAT.MaLP
	WHERE CAST(PHIEUDAT.NgayDenDukien AS DATE) = @DATE;
END
GO

-- TEST
DECLARE @TestDate DATE = '2022-01-09';  
EXEC CAU2_PROC @DATE = @TestDate;
GO 

--Câu 3: Thêm trường Số ngày thuê vào bảng Phòng. Tạo Trigger cập nhật tự động cho trường
--này mỗi khi thêm, sửa, xóa một bản ghi ở bảng Phiếu thuê, biết:
--số ngày thuê = {
-- = 1, Thời gian checkin và checkout cùng 1 ngày
-- = Thoigiancheckout − Thoigiancheckin, Trường hợp khác


-- Add a new column 'SoNgayThue' to the 'Phong' table
ALTER TABLE Phong
ADD SoNgayThue INT
GO

-- Create or alter a trigger 'cau3_th4' on the 'PhieuThue' table for insert, update, and delete operations
CREATE OR ALTER TRIGGER cau3_th4
ON PhieuThue
FOR INSERT, UPDATE, DELETE
AS
BEGIN
    -- Update 'SoNgayThue' trong table 'Phong'
    UPDATE Phong
    SET SoNgayThue = ISNULL(SoNgayThue, 0) +
        IIF(inserted.Thoigiancheckout = inserted.Thoigiancheckin, 1, DATEDIFF(DAY, inserted.Thoigiancheckin, inserted.Thoigiancheckout))
    FROM Phong
    JOIN PhieuThue ON Phong.MaPhong = PhieuThue.MaPhong
    JOIN inserted ON PhieuThue.MaPT = inserted.MaPT AND Phong.MaPhong = inserted.MaPhong;

    -- Update 'SoNgayThue' trong table 'Phong'
    UPDATE Phong
    SET SoNgayThue = IIF(ISNULL(SoNgayThue, 0) = 0, 0, SoNgayThue -
        IIF(deleted.Thoigiancheckout = deleted.Thoigiancheckin, 1, DATEDIFF(DAY, deleted.Thoigiancheckin, deleted.Thoigiancheckout)))
    FROM Phong
    JOIN PhieuThue ON Phong.MaPhong = PhieuThue.MaPhong
    JOIN deleted ON Phong.MaPhong = deleted.MaPhong;
END
GO

-- INSERT
INSERT [dbo].[PHIEUTHUE] ([MaPT], [MaBooking], [ThoigianlapPT], [Thoigiancheckout], [Thoigiancheckin], [KMPhong], [Maphong]) VALUES (N'PT0025', N'PD0016', CAST(N'2022-01-09T00:00:00.000' AS DateTime), CAST(N'2022-01-12T00:00:00.000' AS DateTime), CAST(N'2022-01-12T00:00:00.000' AS DateTime), 0, N'P404')
SELECT * FROM PHONG
GO 

-- UPDATE
UPDATE [dbo].[PHIEUTHUE]
SET [Thoigiancheckout] = CAST(N'2022-01-14T00:00:00.000' AS DateTime)
WHERE [MaPT] = N'PT0025';
SELECT * FROM PHONG
GO

-- DELETE
DELETE FROM [dbo].[PHIEUTHUE]
WHERE [MaPT] = N'PT0025'
SELECT * FROM PHONG
GO
--Câu 4: Tạo View gồm các thông tin mã khách hàng, tên khách hàng, địa chỉ, điện thoại, mã Booking, tiền đặt cọc, mã loại phòng, số lượng phòng có ngày đến dự kiến từ ngày 12/12/2022 đến ngày 19/12/2022

CREATE OR ALTER  VIEW CAU4_VIEW
AS
SELECT 
	KHACHHANG.MaKH,
	KHACHHANG.TenKH,
	KHACHHANG.Diachi,
	KHACHHANG.Dienthoai,
	PHIEUDAT.MaBooking,
	PHIEUDAT.Tiendatcoc,
	CHITIETPHONGDAT.MaLP,
	CHITIETPHONGDAT.SLPhong
FROM KHACHHANG
	INNER JOIN PHIEUDAT ON PHIEUDAT.MaKH = KHACHHANG.MaKH
	INNER JOIN CHITIETPHONGDAT ON CHITIETPHONGDAT.MaBooking = PHIEUDAT.MaBooking
WHERE PHIEUDAT.NgayDenDukien BETWEEN '2022-12-12' AND  '2022-12-19'
GO

SELECT * FROM CAU4_VIEW
GO

--Câu 5: 
--Tạo login TranHuyHiep, tạo user TranHuyHiep cho login TranHuyHiep trên CSDL đã cho.
exec sp_addlogin TranHuyHiep 
use QLKhachSan
exec sp_adduser TranHuyHiep ,TranHuyHiep
--Phân quyền Select trên view ở câu 4 cho TranHuyHiep, và TranHuyHiep được phép phân quyền cho người khác
GRANT SELECT ON CAU4_VIEW TO TranHuyHiep WITH GRANT OPTION
GO
--Tạo login PhamVietTrung, tạo user PhamVietTrung cho login PhamVietTrung trên CSDL trên.
exec sp_addlogin PhamVietTrung 
use QLKhachSan
exec sp_adduser PhamVietTrung ,PhamVietTrung 
GO
--Từ login TranHuyHiep, phân quyền Select trên view Câu 4 cho PhamVietTrung
GRANT SELECT ON CAU4_VIEW TO PhamVietTrung
GO

-- Câu 6: Tạo view đưa ra danh sách khách hàng có số tiền tiêu dùng nằm trong top(3) số tiền tiêu dùng lớn nhất tại khách sạn.
-- Tiền tiêu dùng của khách là số tiền khách trả cho tiền thuê phòng tại khách sạn.

CREATE OR ALTER VIEW  CAU6_VIEW
AS
SELECT TOP 3 WITH TIES
	KHACHHANG.MaKH,
	KHACHHANG.TenKH,
	SUM(TONGTIEN.TIENTIEUDUNG) AS TIENTHUE,
	KHACHHANG.Diachi,
	KHACHHANG.Dienthoai,
	KHACHHANG.CCCD 
FROM KHACHHANG
	INNER JOIN
	(
		SELECT
			PHIEUDAT.MaKH,
			PHIEUDAT.MaBooking,
			PHIEUTHUE.Maphong,
			LOAIPHONG.MaLP,
			(SUM(IIF(PHIEUTHUE.Thoigiancheckin = PHIEUTHUE.Thoigiancheckout OR DATEDIFF(DAY, PHIEUTHUE.Thoigiancheckin, PHIEUTHUE.Thoigiancheckout) < 0 ,1,DATEDIFF(DAY, PHIEUTHUE.Thoigiancheckin, PHIEUTHUE.Thoigiancheckout)) * LOAIPHONG.Dongiaphong * CHITIETPHONGDAT.SLPhong * (1 - PHIEUTHUE.KMPhong))) AS TIENTIEUDUNG
		FROM PHIEUDAT
			INNER JOIN PHIEUTHUE ON PHIEUTHUE.MaBooking = PHIEUDAT.MaBooking
			INNER JOIN CHITIETPHONGDAT ON CHITIETPHONGDAT.MaBooking = PHIEUDAT.MaBooking
			INNER JOIN LOAIPHONG ON LOAIPHONG.MaLP = CHITIETPHONGDAT.MaLP
			INNER JOIN PHONG ON PHONG.MaLP = CHITIETPHONGDAT.MaLP AND PHONG.Maphong = PHIEUTHUE.Maphong
		GROUP BY PHIEUDAT.MaKH, PHIEUDAT.MaBooking, PHIEUTHUE.Maphong, LOAIPHONG.MaLP
	) AS TONGTIEN ON TONGTIEN.MaKH = KHACHHANG.MaKH
	GROUP BY KHACHHANG.MaKH, KHACHHANG.TenKH,KHACHHANG.Diachi,KHACHHANG.Dienthoai,KHACHHANG.CCCD  
	ORDER BY TIENTHUE DESC
GO

SELECT * FROM CAU6_VIEW
GO

