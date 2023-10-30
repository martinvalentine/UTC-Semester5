USE QLDonDatHang
GO
--VI. Tạo FUNCTION
--1. Tạo hàm lấy danh sách nhân viên theo quê quán
CREATE OR ALTER FUNCTION CAU1_FUNCT
(
	@QUEQUAN NVARCHAR(50)
)
RETURNS TABLE
AS
RETURN
(
	SELECT *
	FROM NHANVIEN
	WHERE NHANVIEN.QueQuan LIKE @QUEQUAN
)
GO

SELECT * FROM CAU1_FUNCT(N'%Hà Nội')
GO
--2. Tạo hàm lấy danh sách hóa đơn theo nhân viên và ngày (ngày/tháng/năm)
CREATE OR ALTER FUNCTION CAU2_FUNCT
(
	@MANV NVARCHAR(10),
	@DATE DATETIME
)
RETURNS TABLE
AS
RETURN
(
	SELECT *
	FROM HOADON
	WHERE @MANV = HOADON.MaNV AND HOADON.NgayLap=@DATE
)
GO

SELECT * FROM CAU2_FUNCT('0001','2015-03-17')
GO
--3. Tạo hàm tính tổng tiền của từng hóa đơn với mã hóa đơn là tham số đầu vào
CREATE OR ALTER FUNCTION CAU3_FUNCT
(
	@MAHOADON NVARCHAR(50)
)
RETURNS TABLE
AS
RETURN
(
	SELECT 
		CT_HOADON.MaHD,
		SUM(CT_HOADON.SL*HANGHOA.GiaBan) AS TONGTIEN
	FROM 
		CT_HOADON
		INNER JOIN HANGHOA ON HANGHOA.MaHH = CT_HOADON.MaHH
	WHERE @MAHOADON = CT_HOADON.MaHD
	GROUP BY CT_HOADON.MaHD
) 
GO

SELECT * FROM CAU3_FUNCT('0001')
GO

--4. Tạo hàm lấy danh sách nhà cung cấp theo mã HÀNG
CREATE OR ALTER FUNCTION CAU4_FUNCT
(
	@MAHANG NVARCHAR(20)
)
RETURNS TABLE
AS
RETURN
(
	SELECT 
		NHACUNGCAP.TenNCC
	FROM 
		NHACUNGCAP
		INNER JOIN  PHIEUNHAP ON PHIEUNHAP.MaNCC = NHACUNGCAP.MaNCC
		INNER JOIN CT_PHIEUNHAP ON PHIEUNHAP.MaPN = CT_PHIEUNHAP.MaPN
	WHERE @MAHANG = CT_PHIEUNHAP.MaHH
)
GO

SELECT * FROM CAU4_FUNCT('0001')
GO
--5. Tạo hàm lấy danh sách các mặt hàng theo mã nhà cung cấp
CREATE OR ALTER FUNCTION CAU5_FUNCT
(
	@MANCC NVARCHAR(20)
)
RETURNS TABLE
AS
RETURN
(
	SELECT 
		HANGHOA.TenHH
	FROM 
		HANGHOA
		INNER JOIN CT_PHIEUNHAP ON CT_PHIEUNHAP.MAHH = HANGHOA.MaHH
		INNER JOIN  PHIEUNHAP ON PHIEUNHAP.MaPN = CT_PHIEUNHAP.MaPN

	WHERE @MANCC = PHIEUNHAP.MaNCC
)
GO
SELECT * FROM CAU5_FUNCT('0001')
GO

--6. Cho danh sách các khách hàng ở một quận nào đó
CREATE OR ALTER FUNCTION CAU6_FUNCT
(
    @QUAN nvarchar(50)
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
		MaKH,
		TenKH, 
		DiaChi
    FROM KHACHHANG
    WHERE DiaChi LIKE N'%' + @QUAN + N'%'
)
GO

SELECT * FROM CAU6_FUNCT(N'Cầu Giấy')
GO
-- V. Tạo TRIGGER
--1. Kiểm soát giới tính của nhân viên chỉ được nhập giá trị là ‘Nam’ hoặc ‘Nữ’
CREATE OR ALTER TRIGGER CAU1_TRIG
ON NHANVIEN
FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @GENDER NVARCHAR(10)
    SELECT @GENDER =  [Gioi Tinh] FROM inserted
    IF (LOWER(@GENDER) NOT LIKE N'nam' AND @GENDER NOT LIKE N'nữ')
    BEGIN
        ROLLBACK TRAN
        PRINT(N'Giới tính phải là Nam hoặc là Nữ')
    END
END
GO
UPDATE NHANVIEN SET  [Gioi Tinh] = N'nữ' WHERE MaNV = 0001
UPDATE NHANVIEN SET  [Gioi Tinh] = N'J' WHERE MaNV = 0001
GO
--2. Kiểm soát ngày vào làm (NgayLV) của nhân viên phải sau ngày sinh và đảm bảo nhân viên trên 18 tuổi
CREATE OR ALTER TRIGGER CAU2_TRIG
ON NHANVIEN
FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @ngayLV date, @ngaysinh date
    SELECT @ngayLV = NgayLV, @ngaysinh = NgaySinh FROM inserted
    IF (YEAR(@ngayLV) - YEAR(@ngaysinh) < 18 OR
        (YEAR(@ngayLV) - YEAR(@ngaysinh) = 18
            AND (MONTH(@ngaysinh) > MONTH(@ngayLV)
                OR (MONTH(@ngaysinh) = MONTH(@ngayLV) AND DAY(@ngaysinh) > DAY(@ngayLV))
            )
        )
    )
    BEGIN
        ROLLBACK TRAN
        PRINT(N'Nhân viên phải đủ hoặc lớn hơn 18 tuổi')
    END
END
GO
INSERT [dbo].[NHANVIEN] ([MaNV], [HoTen], [QueQuan], [Gioi Tinh], [SDT], [NgaySinh], [NgayLV], [HSL]) 
VALUES (N'1000', N'Ngụy Thế Quang', N'Số 27, Ngách 49, Ngõ 165, Cầu Giấy - Hà Nội', N'Nam', N'09088888888', CAST(N'2019-07-07T00:00:00.000' AS DateTime), CAST(N'2021-07-07T00:00:00.000' AS DateTime), NULL)
GO
--3. Thêm trường Đơn vị tính vào bảng Hàng hóa. Kiểm soát đơn vị tính khi nhập hàng hóa chỉ được chứa từ “Cái”, “Hộp”, “Thùng”, “Kg”, “Chiếc”
ALTER TABLE HANGHOA ADD DONVI nvarchar(10) NULL
GO 
CREATE OR ALTER TRIGGER CAU3_TRIG ON HANGHOA
FOR INSERT, UPDATE AS
BEGIN
    DECLARE @donvi nvarchar(10)
    SELECT @donvi = DONVI FROM inserted
    IF (@donvi NOT LIKE N'Cái' AND @donvi NOT LIKE N'Hộp' AND @donvi NOT LIKE N'Thùng' AND @donvi NOT LIKE N'Kg' AND @donvi NOT LIKE N'Chiếc')
    BEGIN
        ROLLBACK TRAN
        PRINT(N'Đơn vị tính khi nhập hàng hóa chỉ được chứa từ “Cái”, “Hộp”, “Thùng”, “Kg”, “Chiếc”')
    END
END
GO
-- Chèn dữ liệu vào bảng HANGHOA
INSERT INTO HANGHOA (MaHH, HangSX, TenHH, GiaBan, DONVI)
VALUES ('0025', N'Nokia', N'Lumia', 999000, N'KhongRo')

-- Chèn dữ liệu vào bảng HANGHOA
INSERT INTO HANGHOA (MaHH, HangSX, TenHH, GiaBan, DONVI)
VALUES ('0026', N'Apple', N'MacBook M1', 25000000, N'Cái')
GO

--4. Tạo trigger cập nhật tự động giá của bảng hàng hóa sang bảng chi tiết hóa đơn mỗi khi thêm mới bản ghi
ALTER TABLE CT_HOADON ADD GiaBan FLOAT
GO
CREATE OR ALTER TRIGGER CAU4_TRIG
ON CT_HOADON
FOR INSERT
AS
BEGIN
    DECLARE @giaBan FLOAT, @maHH NVARCHAR(50);
    SELECT @maHH = inserted.MaHH FROM inserted;
    SELECT @giaBan = ISNULL(HANGHOA.GiaBan, 0)
    FROM CT_HOADON
    FULL JOIN HANGHOA ON CT_HOADON.MaHH = HANGHOA.MaHH;
    UPDATE CT_HOADON SET GiaBan = @giaBan WHERE MaHH = @maHH;
    
    IF (@giaBan < 0)
    BEGIN
        ROLLBACK TRAN;
        PRINT('Mã hàng hoá này không tồn tại')
    END
END
GO

-- Thêm dữ liệu vào bảng CT_HOADON
INSERT [dbo].[CT_HOADON] ([MaHD], [MaHH], [SL]) VALUES (N'0011', N'0003', 1)

-- Truy vấn dữ liệu từ bảng CT_HOADON dựa trên điều kiện MaHD và MaHH
SELECT * FROM [dbo].[CT_HOADON] WHERE [dbo].[CT_HOADON].[MaHD] = N'0011' AND [dbo].[CT_HOADON].[MaHH] = N'0003'

--5. Thêm trường ChietKhau vào bảng CT_Hoadon và cập nhật tự động trường này bằng 15% giá bán
--6. Thêm Trường ThanhTien và cập nhật tự động cho trường này
--7. Cập nhật lại giá của bảng hàng hóa sang bảng chi tiết hóa đơn