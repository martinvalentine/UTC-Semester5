USE QLVanTai

-- ****************************************************************** --
-- Bài 1:QLVanTai.sql

--1. Tạo hàm có đầu vào là lộ trình, đầu ra là số xe, mã trọng tải, số lượng vận tải, ngày đi, ngày đến (SoXe, MaTrongTai, SoLuongVT, NgayDi, NgayDen.)
GO
CREATE FUNCTION Cau1
(
    @lotrinh NVARCHAR(255)
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        ChiTietVanTai.SoXe,
        ChiTietVanTai.MaTrongTai,
        ChiTietVanTai.SoLuongVT,
        ChiTietVanTai.NgayDi,
        ChiTietVanTai.NgayDen
    FROM
        ChiTietVanTai
    WHERE ChiTietVanTai.MaLoTrinh = @lotrinh
)

-- Gọi hàm
SELECT * FROM Cau1('HN')

--2. Thiết lập hàm có đầu vào là số xe, đầu ra là thông tin về lộ trình
GO
CREATE FUNCTION Cau2 
(
	@soxe NVARCHAR(255)
)
RETURNS TABLE
AS
RETURN
(
	SELECT 
		LoTrinh.MaLoTrinh,
		LoTrinh.TenLoTrinh,
		LoTrinh.DonGia,
		LoTrinh.ThoiGianQD,
		ChiTietVanTai.NgayDi,
		ChiTietVanTai.NgayDen
	FROM
		LoTrinh
		INNER JOIN ChiTietVanTai ON ChiTietVanTai.MaLoTrinh = LoTrinh.MaLoTrinh
	WHERE
		ChiTietVanTai.SoXe = @soxe
)

-- Gọi hàm:
SELECT * FROM Cau2('444')

--3. Tạo hàm có đầu vào là trọng tải, đầu ra là các số xe có trọng tải quy định lớn hơn hoặc bằng trọng tải đó
GO
CREATE FUNCTION Cau3
(
	@trongtai INT
)
RETURNS TABLE
AS
RETURN
(
	SELECT
		ChiTietVanTai.SoXe
	FROM
		ChiTietVanTai
		INNER JOIN TrongTai ON TrongTai.MaTrongTai = ChiTietVanTai.MaTrongTai
	WHERE
		TrongTai.TrongTaiQD >= @trongtai
)

SELECT * FROM Cau3(12)

--4. Tạo hàm có đầu vào là trọng tải và mã lộ trình, đầu ra là số lượng xe có trọng tải quy định lớn hơn hoặc bằng trọng tải đó và thuộc lộ trình đó.
GO
CREATE FUNCTION Cau4
(
	@trongtai INT,
	@malotrinh NVARCHAR(255)
)
RETURNS TABLE
AS
RETURN
(
	SELECT
		COUNT(ChiTietVanTai.SoXe) AS SoLuongXe
	FROM
		ChiTietVanTai
		INNER JOIN TrongTai ON TrongTai.MaTrongTai = ChiTietVanTai.MaTrongTai
	WHERE
		TrongTai.TrongTaiQD >= @trongtai AND ChiTietVanTai.MaLoTrinh = @malotrinh
)

SELECT * FROM Cau4 (4, 'HN')

--5. Tạo thủ tục có đầu vào Mã lộ trình đầu ra là số lượng xe thuộc lộ trình đó.
GO
CREATE PROCEDURE Cau5
	@malotrinh NVARCHAR(255),
	@SLXe INT OUTPUT
AS 
BEGIN
	SELECT
		@SLXe = COUNT(ChiTietVanTai.SoXe)
	FROM
		ChiTietVanTai
	WHERE
		ChiTietVanTai.MaLoTrinh = @malotrinh
END

-- Chạy thủ tục
DECLARE @sl INT
EXEC Cau5 'HN', @sl OUTPUT
PRINT 'So luong xe thuoc lo trinh la :' + CONVERT(NVARCHAR(50), @sl)

--6. Tạo thủ tục có đầu vào là mã lộ trình, năm vận tải, đầu ra là số tiền theo mã lộ trình và năm vận tải đó
GO
CREATE PROCEDURE Cau6
	@malotrinh NVARCHAR(255),
	@namvantai INT,
	@sotien MONEY OUTPUT
	AS 
BEGIN
	SELECT 
		@sotien = SUM(LoTrinh.DonGia * ChiTietVanTai.SoLuongVT)
	FROM 
		ChiTietVanTai
	INNER JOIN LoTrinh ON ChiTietVanTai.MaLoTrinh = LoTrinh.MaLoTrinh
	WHERE ChiTietVanTai.MaLoTrinh = @malotrinh AND YEAR(ChiTietVanTai.NgayDi) = @namvantai
END

-- Chạy thủ tục:
DECLARE @tien MONEY
EXEC Cau6 'PK', 2014, @tien OUTPUT
PRINT 'So tien theo lo trinh va nam la: ' + CONVERT(NVARCHAR(50), @tien)

--7. Tạo thủ tục có đầu vào là số xe, năm vận tải, đầu ra là số tiền theo số xe và năm vận tải đó
GO
CREATE PROCEDURE Cau7
	@soxe NVARCHAR(255),
	@namvantai INT,
	@sotien MONEY OUTPUT
AS 
BEGIN
	SELECT 
		@sotien = SUM(LoTrinh.DonGia * ChiTietVanTai.SoLuongVT)
	FROM 
		ChiTietVanTai
		INNER JOIN LoTrinh ON ChiTietVanTai.MaLoTrinh = LoTrinh.MaLoTrinh
	WHERE ChiTietVanTai.SoXe = @soxe AND YEAR(ChiTietVanTai.NgayDi) = @namvantai
END

-- Chạy thủ tục:
DECLARE @tien MONEY
EXEC Cau7 '444', 2014, @tien OUTPUT
PRINT 'So tien theo xe va nam la: ' + CONVERT(NVARCHAR(50), @tien)

--8. Tạo thủ tục có đầu vào là mã trọng tải, đầu ra là số lượng xe vượt quá trọng tải quy định của mã trọng tải đó.
GO
CREATE PROCEDURE Cau8
	@matrongtai NVARCHAR(255),
	@SLxe INT OUTPUT
	AS 
BEGIN
	SELECT 
		@SLxe = COUNT(ChiTietVanTai.SoXe)
	FROM
		ChiTietVanTai
		INNER JOIN TrongTai ON TrongTai.MaTrongTai = ChiTietVanTai.MaTrongTai
	WHERE
		ChiTietVanTai.MaTrongTai = @matrongtai AND ChiTietVanTai.SoLuongVT > TrongTai.TrongTaiQD
END

-- Chạy thủ tục:
DECLARE @sl INT
EXEC Cau8 '50', @sl OUTPUT
PRINT 'So luong xe vuot qua trong tai la: ' + CONVERT(NVARCHAR(50), @sl)

-- ******************************************************************
-- ******************************************************************
-- ******************************************************************
-- ******************************************************************
-- ******************************************************************
-- Bài 2:QLNhanVien.sql

USE QLNhanVien

--1. Tạo hàm với đầu vào là năm, đầu ra là danh sách nhân viên sinh vào năm đó
GO
CREATE FUNCTION Cau1_b2
(
	@nam INT
)
RETURNS TABLE
AS
RETURN
(
	SELECT *
	FROM tNhanVien
	WHERE YEAR(tNhanVien.NTNS) = @nam
)

SELECT * FROM Cau1_b2(1968)

--2. Tạo hàm với đầu vào là số thâm niên (số năm làm việc) đầu ra là danh sách nhân viên có thâm niên đó.
GO
CREATE FUNCTION Cau2_b2
(
	@thamniem INT
)
RETURNS TABLE 
AS 
RETURN 
(
	SELECT *
	FROM tNhanVien
	WHERE DATEDIFF(YEAR, tNhanVien.NgayBD, GETDATE()) = @thamniem
)

SELECT * FROM Cau2_b2(33)

--3. Tạo hàm đầu vào là chức vụ đầu ra là những nhân viên cùng chức vụ đó
GO
CREATE FUNCTION Cau3_b2
(
	@chucvu NVARCHAR(10)
)
RETURNS TABLE
AS
RETURN
(
	SELECT 
		tNhanVien.MaNV,
		tNhanVien.HO,
		tNhanVien.TEN,
		tNhanVien.PHAI,
		tNhanVien.NTNS,
		tNhanVien.NgayBD
	FROM 
		tNhanVien
		INNER JOIN tChiTietNhanVien ON tChiTietNhanVien.MaNV = tNhanVien.MaNV
	WHERE tChiTietNhanVien.ChucVu = @chucvu
)

SELECT * FROM Cau3_b2('GD')

--4. Tạo hàm đưa ra thông tin về nhân viên được tăng lương của ngày hôm nay (giả sử 3 năm lên lương 1 lần)
GO
CREATE FUNCTION Cau4_b2()
RETURNS TABLE
AS
RETURN
(
	SELECT 
		tNhanVien.MaNV,
		tNhanVien.HO,
		tNhanVien.TEN,
		tNhanVien.PHAI,
		tNhanVien.NTNS,
		tNhanVien.NgayBD
	FROM 
		tNhanVien
		INNER JOIN tChiTietNhanVien ON tChiTietNhanVien.MaNV = tNhanVien.MaNV
	WHERE CONVERT(INT,DATEDIFF(YEAR, tNhanVien.NgayBD, GETDATE())) % 3 = 0
		AND DAY(tNhanVien.NgayBD) = DAY(GETDATE())
		AND MONTH(tNhanVien.NgayBD) = MONTH(GETDATE())
)

SELECT * FROM Cau4_b2()

/*
5. Tạo Hàm xây dựng bảng lương của nhân viên gồm các thông tin sau:
- Lương = lương cơ bản * HSLuong + Phụ cấp (Giả sử lương cơ bản=1490000vnd (1.49tr))
- BHXH: 8%*lương (bảo hiểm xã hội)
- BHYT: 1,5% * lương (bảo hiểm y tế)
- BHTN: 1%* lương (Bảo hiểm thất nghiệp)
- Thuế TNCN (Thuế thu nhập cá nhân)
Trong đó: TN= Lương - BHXH - BHYT - BHTN - 11tr (mức chịu thuế) - GTGC*4.4tr (Giảm trừ gia cảnh)
- Phụ cấp: Mức độ công việc là A thì phụ cấp 10tr, mức độ B là 8tr, mức độ C là 5tr
- Thực lĩnh: Lương – (BHXH+BHYT+BHTN + Thuế TNCN)
*/
CREATE FUNCTION Cau5_b2()
RETURNS TABLE
AS
RETURN
(
    WITH tPhucap AS (
        SELECT
            tChiTietNhanVien.MaNV,
            CASE 
                WHEN tChiTietNhanVien.MucDoCV LIKE 'A%' THEN 10000000 
                WHEN tChiTietNhanVien.MucDoCV LIKE 'B%' THEN 8000000
                WHEN tChiTietNhanVien.MucDoCV LIKE 'C%' THEN 5000000
            END AS Phucap
        FROM tChiTietNhanVien
    ),
    tThongTinBH AS (
        SELECT
            tChiTietNhanVien.MaNV,
            1490000 * tChiTietNhanVien.HSLuong + tPhucap.Phucap AS Luong,
            0.08 * (1490000 * tChiTietNhanVien.HSLuong + tPhucap.Phucap) AS BHXH,
            0.015 * (1490000 * tChiTietNhanVien.HSLuong + tPhucap.Phucap) AS BHYT,
            0.01 * (1490000 * tChiTietNhanVien.HSLuong + tPhucap.Phucap) AS BHTN
        FROM tPhucap
        INNER JOIN tChiTietNhanVien ON tChiTietNhanVien.MaNV = tPhucap.MaNV
    ),
    tThue AS (
        SELECT
            tChiTietNhanVien.MaNV,
            CASE
				WHEN (tt.Luong - tt.BHXH - tt.BHYT - tt.BHTN - 11000000 - IsNull(tChiTietNhanVien.GTGC,0) * 4400000) < 0 THEN 0
                WHEN (tt.Luong - tt.BHXH - tt.BHYT - tt.BHTN - 11000000 - IsNull(tChiTietNhanVien.GTGC,0) * 4400000) <= 5000000 THEN (tt.Luong - tt.BHXH - tt.BHYT - tt.BHTN - 11000000 - IsNull(tChiTietNhanVien.GTGC,0) * 4400000) * 0.005
                WHEN (tt.Luong - tt.BHXH - tt.BHYT - tt.BHTN - 11000000 - IsNull(tChiTietNhanVien.GTGC,0) * 4400000) <= 10000000 THEN (tt.Luong - tt.BHXH - tt.BHYT - tt.BHTN - 11000000 - IsNull(tChiTietNhanVien.GTGC,0) * 4400000) * 0.1 - 250000
                WHEN (tt.Luong - tt.BHXH - tt.BHYT - tt.BHTN - 11000000 - IsNull(tChiTietNhanVien.GTGC,0) * 4400000) <= 18000000 THEN (tt.Luong - tt.BHXH - tt.BHYT - tt.BHTN - 11000000 - IsNull(tChiTietNhanVien.GTGC,0) * 4400000) * 0.15 - 750000
                WHEN (tt.Luong - tt.BHXH - tt.BHYT - tt.BHTN - 11000000 - IsNull(tChiTietNhanVien.GTGC,0) * 4400000) <= 32000000 THEN (tt.Luong - tt.BHXH - tt.BHYT - tt.BHTN - 11000000 - IsNull(tChiTietNhanVien.GTGC,0) * 4400000) * 0.2 - 1650000
                WHEN (tt.Luong - tt.BHXH - tt.BHYT - tt.BHTN - 11000000 - IsNull(tChiTietNhanVien.GTGC,0) * 4400000) <= 52000000 THEN (tt.Luong - tt.BHXH - tt.BHYT - tt.BHTN - 11000000 - IsNull(tChiTietNhanVien.GTGC,0) * 4400000) * 0.25 - 3250000
                WHEN (tt.Luong - tt.BHXH - tt.BHYT - tt.BHTN - 11000000 - IsNull(tChiTietNhanVien.GTGC,0) * 4400000) <= 80000000 THEN (tt.Luong - tt.BHXH - tt.BHYT - tt.BHTN - 11000000 - IsNull(tChiTietNhanVien.GTGC,0) * 4400000) * 0.3 - 5850000
                ELSE (tt.Luong - tt.BHXH - tt.BHYT - tt.BHTN - 11000000 - IsNull(tChiTietNhanVien.GTGC,0) * 4400000) * 0.35 - 9850000
            END AS ThueTNCN
        FROM tThongTinBH tt
        INNER JOIN tChiTietNhanVien ON tChiTietNhanVien.MaNV = tt.MaNV
    )
    SELECT
        tNhanVien.MaNV,
        tNhanVien.HO,
        tNhanVien.TEN,
        tt.Luong,
        tt.BHXH,
        tt.BHYT,
        tt.BHTN,
        tThue.ThueTNCN,
        ThucLinh = tt.Luong - (tt.BHXH + tt.BHYT + tt.BHTN + tThue.ThueTNCN)
    FROM tThongTinBH AS tt
    INNER JOIN tNhanVien ON tNhanVien.MaNV = tt.MaNV
    INNER JOIN tThue ON tt.MaNV = tThue.MaNV
)

SELECT * FROM Cau5_b2()

--6. Tạo thủ tục có đầu vào là mã phòng, đầu ra là số nhân viên của phòng đó và tên trưởng phòng
CREATE PROCEDURE Cau6_b2
(
	@maphong NVARCHAR(40),	
	@SLnhanVien INT OUTPUT,
	@TenTP NVARCHAR(20) OUTPUT
)
AS
BEGIN
	SELECT 
		@SLnhanVien = COUNT(tNhanVien.MaNV)
	FROM 
		tNhanVien
	WHERE tNhanVien.MaPB = @maphong

	SELECT 
		@TenTP = tNhanVien.TEN
	FROM
		tNhanVien
		INNER JOIN tPhongBan ON tPhongBan.MaPB = tNhanVien.MaPB
	WHERE tPhongBan.MaPB = @maphong AND tPhongBan.TruongPhong = tNhanVien.MaNV
END

DECLARE @SL INT, @TEN NVARCHAR(50)
EXEC Cau6_b2 'VP', @SL OUTPUT, @TEN OUTPUT
PRINT 'So luong nhan vien cua phong ban do la: ' + CONVERT(NVARCHAR(50), @SL)
PRINT 'Ten truong phong la: ' + CONVERT(NVARCHAR(50), @TEN)

--7. Tạo thủ tục có đầu vào là mã phòng đầu ra là số tiền lương của phòng đó
CREATE PROCEDURE Cau7_b2
(
	@maphong NVARCHAR(40),
	@tongtien INT OUTPUT
)
AS
BEGIN
	SELECT 
		@tongtien = SUM(Cau5_b2.Luong)
	FROM 
		tNhanVien
		INNER JOIN Cau5_b2() ON Cau5_b2.MaNV = tNhanVien.MaNV
	WHERE tNhanVien.MaPB = @maphong
END

DECLARE @Luong MONEY
EXEC Cau7_b2 N'VP', @Luong OUTPUT
PRINT N'Tiền lương của phòng ban: '+ CONVERT(NVARCHAR(20),@Luong)