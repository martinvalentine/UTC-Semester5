USE Week2_QLHocSinh
GO
--Bài tập 1: Cho cơ sở dữ liệu về quản lý học sinh (file QLHocSinh.sql):
--1. Viết một Trigger gắn với bảng DIEM dựa trên sự kiện Insert, Update để tự động cập nhật
--điểm trung bình của học sinh khi thêm mới hay cập nhật bảng điểm
--Điểm trung bình= ((Toán +Văn)*2+Lý+Hóa)/6
-- Trigger to update DTB in Diem table after insert or update

CREATE OR ALTER TRIGGER CAU1_1 ON DIEM
AFTER INSERT, UPDATE
AS
BEGIN
	DECLARE @toan FLOAT, @van FLOAT, @ly FLOAT, @hoa FLOAT, @mahs NVARCHAR(20);

	SELECT @toan = TOAN, @van = VAN, @ly = LY, @hoa = HOA, @mahs = MAHS FROM inserted;

	UPDATE DIEM
	SET DTB = ROUND(((@toan + @van) * 2 + @ly + @hoa) / 6, 2)
	WHERE MAHS = @mahs
END
GO

DELETE FROM DIEM WHERE MAHS = N'00003'

INSERT INTO Diem (MAHS, TOAN, Ly, Hoa, Van)
VALUES (N'00003', 8.9, 7.5, 5, 6.5)
SELECT * FROM DIEM WHERE MAHS = N'00003'
DROP TRIGGER CAU1_1
GO
--2. Viết một Trigger gắn với bảng DIEM dựa trên sự kiện Insert, Update để tự động xếp loại
--học sinh, cách thức xếp loại như sau
--- Nếu Điểm trung bình>=5 là lên lớp, ngược lại là lưu ban
-- Trigger to update DTB and XEPLOAI in Diem table after insert or update
-- Trigger to update XEPLOAI in DIEM table after insert or update
CREATE OR ALTER TRIGGER CAU1_2 ON DIEM
AFTER INSERT, UPDATE
AS
BEGIN
    IF TRIGGER_NESTLEVEL() > 1
    RETURN
    DECLARE @mahs NVARCHAR(20)
    SELECT @mahs = MAHS FROM inserted
    UPDATE DIEM
    SET XEPLOAI = IIF(DTB >= 5, N'LEN LOP', N'DUP')
    WHERE MAHS = @mahs;
END
GO

INSERT [dbo].[DIEM] ([MAHS], [TOAN], [LY], [HOA], [VAN], [DTB], [XEPLOAI]) VALUES (N'00004', 10, 10, 5, 7,0,null)
UPDATE DIEM SET TOAN = 9 WHERE MAHS = N'00004'
SELECT * FROM DIEM WHERE MAHS = N'00004'
DROP TRIGGER CAU1_2
GO
--3. Viết một Trigger gắn với bảng DIEM dựa trên sự kiện Insert, Update để tự động xếp loại
--học sinh, cách thức xếp loại như sau
--- Xét điểm thấp nhất (DTN) của các 4 môn
--- Nếu DTB>=5 và DTN>=4 là “Lên Lớp”, ngược lại là lưu ban
-- Trigger to update XEPLOAI in DIEM table after insert or update
CREATE OR ALTER TRIGGER CAU1_3 ON DIEM
AFTER INSERT, UPDATE
AS
BEGIN
    IF TRIGGER_NESTLEVEL() > 1
        RETURN;
    DECLARE @mahs NVARCHAR(20), @dtn FLOAT, @toan FLOAT, @van FLOAT, @ly FLOAT, @hoa FLOAT
    SELECT @mahs = MAHS, @toan = TOAN, @van = VAN, @ly = LY, @hoa = HOA FROM inserted
    SET @dtn = @toan;
    IF @dtn > @van SET @dtn = @van;
    IF @dtn > @ly SET @dtn = @ly;
    IF @dtn > @hoa SET @dtn = @hoa;

    UPDATE DIEM
    SET XEPLOAI = IIF(DTB >= 5 AND @dtn >= 4, N'LEN LOP', N'DUP')
    WHERE MAHS = @mahs
END
GO

DELETE FROM DIEM WHERE MAHS = N'00006'
INSERT INTO [dbo].[DIEM] ([MAHS], [TOAN], [LY], [HOA], [VAN], [DTB], [XEPLOAI])
VALUES (N'00006', 10, 10, 3, 7, NULL, NULL)
SELECT * FROM DIEM WHERE MAHS = N'00006'
GO
--4. Viết một trigger xóa tự động bản ghi về điểm học sinh khi xóa dữ liệu học sinh đó trong
--DSHS
CREATE OR ALTER TRIGGER CAU1_4
ON DSHS
AFTER DELETE
AS
BEGIN
    DECLARE @mahs NVARCHAR(20)

    SELECT @mahs = MaHS FROM deleted

    DELETE FROM DIEM WHERE MAHS = @mahs
END
GO

SELECT * FROM DIEM WHERE MAHS = N'00001'
DELETE FROM DSHS WHERE MAHS = N'00001'
GO

-- ********************************************************************************
--Bài tập 2: Cho file cơ sở dữ liệu QLKhachSan.sql dùng cho quản lý khách sạn như sau:
--1. Viết truy vấn tạo bảng doanh thu (tDoanhThu) gồm các trường
--Table: tDoanhThu
--Tên trường Kiểu dữ liệu Diễn giải
--MaDK Short Text Mã đăng ký
--LoaiPhong Short Text Loại phòng
--SoNgayO Number Số ngày ở
--ThucThu Number Thực thu
CREATE TABLE [dbo].[tDoanhThu](
	[MaDK] [nvarchar](3) NOT NULL,
	[LoaiPhong] [nvarchar](2) NULL,
	[SoNgayO] [int] NULL,
	[ThucThu] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[MaDK] ASC
)
) 
SELECT * FROM tDoanhThu
GO
--2. Tạo Trigger tính tiền và điền tự động vào bảng tDoanhThu như sau:
--Các trường lấy thông tin từ các bảng và các thông tin sau:
--Trong đó: 
--(a) Số Ngày Ở= Ngày Ra – Ngày Vào 
--(b) ThucThu: Tính theo yêu cầu sau: 
--Nếu Số Ngày ở <10 Thành tiền = Đơn Giá * Số ngày ở 
--Nếu 10 <=Số Ngày ở <30 Thành Tiền = Đơn Giá* Số Ngày ở * 0.95 (Giảm5%) 
--Nếu Số ngày ở >= 30 Thành Tiền = Đơn Giá* Số Ngày ở * 0.9 (Giảm10%) 
-- Trigger to update tDoanhThu after insert or update
CREATE OR ALTER TRIGGER CAU2_2
ON tDoanhThu
FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @mdky NVARCHAR(3), 
            @loaiphong NVARCHAR(3),
            @sngayo INT, 
            @thucthu BIGINT
    SELECT @mdky = MaDK, @loaiphong = LoaiPhong FROM inserted
    SELECT @sngayo = DATEDIFF(DAY, NgayVao, NgayRa) FROM tDangKy WHERE MaDK = @mdky
    SELECT @thucthu =
        CASE
            WHEN @sngayo < 10 THEN DonGia * @sngayo
            WHEN @sngayo < 30 THEN DonGia * @sngayo * 0.95
            ELSE DonGia * @sngayo * 0.9
        END
    FROM tLoaiPhong WHERE LoaiPhong = @loaiphong
    UPDATE tDoanhThu
    SET SoNgayO = @sngayo, ThucThu = @thucthu
    WHERE MaDK = @mdky AND LoaiPhong = @loaiphong
END

INSERT [dbo].[tDangKy] ([MaDK], [SoPhong], [LoaiPhong], [NgayVao], [NgayRa]) VALUES (N'017', N'201', N'A', CAST(N'1998-04-15T00:00:00.000' AS DateTime), CAST(N'1998-04-30T00:00:00.000' AS DateTime))
SELECT * FROM tDoanhThu WHERE MaDK = N'017'
GO
--3. Thêm trường DonGia vào bảng tDangKy, tạo trigger cập nhật tự động cho trường này.
ALTER TABLE tDangKy ADD DonGia BIGINT
GO

CREATE OR ALTER TRIGGER CAU2_3 ON tDangKy
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @loaiphong NVARCHAR(3), 
		@dongia BIGINT

	SELECT @loaiphong = LoaiPhong
	FROM inserted;

	SELECT @dongia = DonGia
	FROM tLoaiPhong
	WHERE LoaiPhong = @loaiphong

	UPDATE tDangKy
	SET DonGia = @dongia
	WHERE LoaiPhong = @loaiphong
END
GO

SELECT * FROM tKhachHang
SELECT * FROM tDoanhThu
UPDATE tDangKy
SET LoaiPhong = 'B'
WHERE MaDK = '001'
SELECT * FROM tChiTietKH
SELECT * FROM tDangKy
GO