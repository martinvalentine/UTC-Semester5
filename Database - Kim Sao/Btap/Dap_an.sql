USE BT1CSDL

-- Câu 1: In ra danh sách các sách chỉ lấy (MaSach,TenSach) do Nhà xuất bản Giáo Dục xuất bản.
SELECT tSach.MaSach, tSach.TenSach FROM tSach 
INNER JOIN tNhaXuatBan on tSach.MaNXB = tNhaXuatBan.MaNXB 
WHERE tNhaXuatBan.TenNXB = N'NXB Giáo Dục'

-- 2: In ra danh sách các sách có tên bắt đầu là “Ngày”.
SELECT * FROM tSach
WHERE tSach.TenSach LIKE N'Ngày%'

-- 3.     In ra danh sách các sách (MaSach,TenSach) do Nhà xuất bản Giáo Dục có giá từ 100.000 đến 150.000.
SELECT tSach.MaSach, tSach.TenSach FROM tSach 
INNER JOIN tNhaXuatBan on tSach.MaNXB = tNhaXuatBan.MaNXB 
WHERE tNhaXuatBan.TenNXB = N'NXB Giáo Dục' AND tSach.DonGiaBan <= 100000 AND tSach.DonGiaBan <= 150000 
-- 4.     In ra danh sách các các sách (MaSach,TenSach) do Nhà xuất bản Giáo Dục hoặc Nhà Xuất Bản Trẻ sản xuất có giá từ 90.000 đến 140.000.
SELECT tSach.MaSach, tSach.TenSach FROM tSach 
INNER JOIN tNhaXuatBan on tSach.MaNXB = tNhaXuatBan.MaNXB 
WHERE tNhaXuatBan.TenNXB = N'NXB Giáo Dục' OR tNhaXuatBan.TenNXB = N'NXB Trẻ'
-- 5.     In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 1/1/2014 và ngày 31/12/2014.
SELECT
    tHoaDonBan.SoHDB,
    tHoaDonBan.NgayBan,
    SUM(tSach.DonGiaBan * tChiTietHDB.SLBan * (100 - CAST(COALESCE(tChiTietHDB.KhuyenMai, 0) AS INT)) / 100) AS "Tri gia hoa don"
FROM
    tChiTietHDB
INNER JOIN
    tHoaDonBan ON tHoaDonBan.SoHDB = tChiTietHDB.SoHDB 
INNER JOIN
    tSach ON tSach.MaSach = tChiTietHDB.MaSach
WHERE
    tHoaDonBan.NgayBan IN ('2014-01-01', '2014-12-31')
	GROUP BY tHoaDonBan.SoHDB,tHoaDonBan.NgayBan --Select cai nao thi group by het

-- 6.In ra các số hóa đơn, trị giá hóa đơn trong tháng 4/2014, sắp xếp theo ngày (tăng dần) và trị giá của hóa đơn (giảm dần).
SELECT
    tHoaDonBan.SoHDB,
    tHoaDonBan.NgayBan,
    SUM(tSach.DonGiaBan * tChiTietHDB.SLBan * (100 - CAST(COALESCE(tChiTietHDB.KhuyenMai, 0) AS INT)) / 100) AS "Tri gia hoa don"
FROM
    tChiTietHDB
INNER JOIN
    tHoaDonBan ON tHoaDonBan.SoHDB = tChiTietHDB.SoHDB
INNER JOIN
    tSach ON tSach.MaSach = tChiTietHDB.MaSach
WHERE
	YEAR(tHoaDonBan.NgayBan) = 2014 and Month(tHoaDonBan.NgayBan) = 4 
	GROUP BY tHoaDonBan.SoHDB,tHoaDonBan.NgayBan
	ORDER BY tHoaDonBan.NgayBan ASC, "Tri gia hoa don" DESC

-- 7.     In ra danh sách các khách hàng (MaKH, TenKH) đã mua hàng trong ngày 10/4/2014.
SELECT 
	tHoaDonBan.MaKH,
	tKhachHang.TenKH
FROM
	tHoaDonBan
INNER JOIN
	tKhachHang ON tKhachHang.MaKH = tHoaDonBan.MaKH
WHERE 
	tHoaDonBan.NgayBan = '2014-04-10'

-- 8.     In ra số hóa đơn, trị giá các hóa đơn do nhân viên có tên “Trần Huy” lập trong ngày “11/8/2014”
SELECT
	tHoaDonBan.SoHDB,
	tNhanVien.TenNV,
	SUM(tSach.DonGiaBan * tChiTietHDB.SLBan * (100 - CAST(COALESCE(tChiTietHDB.KhuyenMai, 0) AS INT)) / 100) AS "Tri gia hoa don"
FROM
	tChiTietHDB
INNER JOIN 
	tSach ON tSach.MaSach = tChiTietHDB.MaSach
INNER JOIN 
	tHoaDonBan ON tHoaDonBan.SoHDB = tChiTietHDB.SoHDB
INNER JOIN
	tNhanVien ON tNhanVien.MaNV = tHoaDonBan.MaNV
WHERE
	tNhanVien.TenNV = N'Trần Huy'
AND 
	tHoaDonBan.NgayBan = '2014-08-11'
GROUP BY
	tHoaDonBan.SoHDB,
	tNhanVien.TenNV
	
-- 9.     In ra danh sách các sách (MaSach,TenSach) được khách hàng có tên “Nguyễn Đình Sơn” mua trong tháng 8/2014.
SELECT
	tSach.MaSach,
	tSach.TenSach
FROM
	tChiTietHDB
INNER JOIN 
	tSach ON tSach.MaSach = tChiTietHDB.MaSach
INNER JOIN 
	tHoaDonBan ON tHoaDonBan.SoHDB = tChiTietHDB.SoHDB
INNER JOIN
	tKhachHang ON tKhachHang.MaKH = tHoaDonBan.MaKH
WHERE
	tKhachHang.TenKH = N'Nguyễn Đình Sơn'
AND
	YEAR(tHoaDonBan.NgayBan) = 2014 and Month(tHoaDonBan.NgayBan) = 8

-- 10.   Tìm các số hóa đơn đã mua sách “Cấu trúc dữ liệu và giải thuật” 
SELECT
	tChiTietHDB.SoHDB,
	tSach.TenSach
FROM
	tChiTietHDB
INNER JOIN
	tSach ON tSach.MaSach = tChiTietHDB.MaSach
WHERE
	tSach.TenSach = N'Cấu trúc dữ liệu và giải thuật'

-- 11.   Tìm các số hóa đơn đã mua sản phẩm có mã số “S01” hoặc “S02”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
SELECT
	tChiTietHDB.SoHDB,
	tChiTietHDB.SLBan,
	tChiTietHDB.MaSach
FROM
	tChiTietHDB
INNER JOIN
	tHoaDonBan ON tHoaDonBan.SoHDB = tChiTietHDB.SoHDB
WHERE
	tChiTietHDB.MaSach IN ('S01','S02') 
AND
	tChiTietHDB.SLBan
BETWEEN 
	10 AND 20

-- 12. Tìm các số hóa đơn mua cùng lúc 2 sản phẩm có mã số “S10” và “S11”, mỗi sản phẩm mua với số lượng từ 5 đến 10.
SELECT 
	tChiTietHDB.SoHDB
FROM 
	tChiTietHDB
INNER JOIN
	tSach ON tSach.MaSach= tChiTietHDB.MaSach
WHERE 
	tChiTietHDB.MaSach = 'S10'
AND 
	tChiTietHDB.SLBan 
BETWEEN
	5 AND 10
AND EXISTS
(
	SELECT 
		tChiTietHDB.SoHDB
	FROM 
		tChiTietHDB
	INNER JOIN
		tSach ON tSach.MaSach= tChiTietHDB.MaSach
	WHERE 
		tChiTietHDB.MaSach = 'S11'
	AND 
		tChiTietHDB.SLBan	
	BETWEEN
		5 AND 10
)

-- 13.   In ra danh sách các sách không bán được.
SELECT 
	tsach.masach,
	tSach.TenSach
FROM
(
	SELECT 
		masach 
	FROM 
		tsach 
	EXCEPT
	(
		SELECT 
			tChiTietHDB.MaSach 
		FROM 
			tChiTietHDB
	)
) AS kodcban
INNER JOIN
	tSach on tsach.MaSach = kodcban.MaSach

-- 14.   In ra danh sách các sách không bán được trong năm 2014.
SELECT tSach.MaSach, tSach.TenSach
FROM tSach
WHERE tSach.MaSach NOT IN(SELECT tChiTietHDB.MaSach 
FROM tChiTietHDB INNER JOIN tHoaDonBan
ON tChiTietHDB.SoHDB = tHoaDonBan.SoHDB
WHERE YEAR(tHoaDonBan.NgayBan) = 2014)

-- 15.   In ra danh sách các sách của NXB Giáo Dục không bán được trong năm 2014.
SELECT tSach.MaSach, TenSach
FROM tSach 
INNER JOIN tNhaXuatBan on tNhaXuatBan.MaNXB = tSach.MaNXB
WHERE tNhaXuatBan.TenNXB = N'NXB Giáo Dục' AND tSach.MaSach NOT IN(SELECT tChiTietHDB.MaSach 
FROM tChiTietHDB INNER JOIN tHoaDonBan
ON tChiTietHDB.SoHDB = tHoaDonBan.SoHDB
WHERE YEAR(tHoaDonBan.NgayBan) = 2014)

-- 16.   Tìm số hóa đơn đã mua tất cả các sách của NXB Giáo Dục.
SELECT tHoaDonBan.SoHDB
FROM tHoaDonBan
WHERE NOT EXISTS(SELECT *
FROM tSach INNER JOIN tNhaXuatBan on tNhaXuatBan.MaNXB = tSach.MaNXB
WHERE tNhaXuatBan.TenNXB = N'NXB Giáo Dục'
AND NOT EXISTS(SELECT * 
FROM tChiTietHDB
WHERE tChiTietHDB.SoHDB = tHoaDonBan.SoHDB
AND tChiTietHDB.MaSach = tSach.MaSach))

-- 17.   Có bao nhiêu đầu sách khác nhau được bán ra trong năm 2014.
SELECT COUNT(DISTINCT MaSach) AS SLSachBanDuoc
FROM tChiTietHDB
INNER JOIN tHoaDonBan ON tHoaDonBan.SoHDB = tChiTietHDB.SoHDB
WHERE YEAR(tHoaDonBan.NgayBan) = '2014'

-- 18.   Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu?
SELECT MAX(kq.tri_gia),MIN(kq.tri_gia) 
FROM (
	SELECT 
		tChiTietHDB.SoHDB, 
		sum(tChiTietHDB.SLBan*tSach.DonGiaBan) AS tri_gia 
	FROM tChiTietHDB
	INNER JOIN	tSach on tChiTietHDB.MaSach = tSach.MaSach
	GROUP BY tChiTietHDB.SoHDB) AS kq

-- 19.   Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2014 là bao nhiêu?
SELECT AVG(kq.tri_gia) AS TriGiaTrungBinh2014
FROM (
	SELECT 
		tChiTietHDB.SoHDB, 
		sum(tChiTietHDB.SLBan*tSach.DonGiaBan) AS tri_gia 
	FROM tChiTietHDB
	INNER JOIN	tSach on tChiTietHDB.MaSach = tSach.MaSach
	INNER JOIN tHoaDonBan ON tHoaDonBan.SoHDB = tChiTietHDB.SoHDB
	WHERE tHoaDonBan.NgayBan >= '2014-01-01' AND tHoaDonBan.NgayBan <= '2014-12-31'
	GROUP BY tChiTietHDB.SoHDB
	) AS kq

		-- c2:
	SELECT SUM(SLBan*DonGiaBan)/COUNT(DISTINCT tChiTietHDB.SoHDB) AS TB_2014
	FROM tHoaDonBan JOIN tChiTietHDB ON tHoaDonBan.SoHDB = tChiTietHDB.SoHDB
	JOIN tSach ON tSach.MaSach = tChiTietHDB.MaSach
	WHERE YEAR(NgayBan) = 2014

-- 20.   Tính doanh thu bán hàng trong năm 2014.
	SELECT SUM(tChiTietHDB.SLBan*tSach.DonGiaBan) AS tri_gia 
	FROM tChiTietHDB
	INNER JOIN	tSach on tChiTietHDB.MaSach = tSach.MaSach
	INNER JOIN tHoaDonBan ON tHoaDonBan.SoHDB = tChiTietHDB.SoHDB
	WHERE tHoaDonBan.NgayBan >= '2014-01-01' AND tHoaDonBan.NgayBan <= '2014-12-31'
	GROUP BY tChiTietHDB.SoHDB


-- 21.   Tìm số hóa đơn có trị giá cao nhất trong năm 2014.
-- Đầu tiên tạo bảng tạm thời tên là trị giá hoá đơn chứa trị giá các hoá đơn của năm 2014
SELECT
    tChiTietHDB.SoHDB,
	tHoaDonBan.maKH,
	tChiTietHDB.SLBan,
    SUM(tChiTietHDB.SLBan * tSach.DonGiaBan) AS tri_gia 
INTO #TriGiaHoaDon2014
FROM tChiTietHDB
INNER JOIN tSach ON tChiTietHDB.MaSach = tSach.MaSach
INNER JOIN tHoaDonBan ON tHoaDonBan.SoHDB = tChiTietHDB.SoHDB
WHERE tHoaDonBan.NgayBan >= '2014-01-01' AND tHoaDonBan.NgayBan <= '2014-12-31'
GROUP BY tChiTietHDB.SoHDB, tHoaDonBan.MaKH, tChiTietHDB.SLBan

-- Tìm số hoá đơn có trị giá cao nhất trong năm 2014
SELECT #TriGiaHoaDon2014.SoHDB
FROM #TriGiaHoaDon2014
WHERE #TriGiaHoaDon2014.tri_gia = (SELECT MAX(#TriGiaHoaDon2014.tri_gia) FROM #TriGiaHoaDon2014)

-- 22.   Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2014.
SELECT tKhachHang.TenKH, #TriGiaHoaDon2014.maKH
FROM tKhachHang
INNER JOIN #TriGiaHoaDon2014 ON #TriGiaHoaDon2014.maKH = tKhachHang.MaKH  
WHERE #TriGiaHoaDon2014.tri_gia = (SELECT MAX(#TriGiaHoaDon2014.tri_gia) FROM #TriGiaHoaDon2014)


-- 23.   In ra danh sách 3 khách hàng (MaKH, TenKH) có doanh số cao nhất.
SELECT 
    TOP 3
    tHoaDonBan.MaKH,
    tKhachHang.TenKH,
    SUM(tChiTietHDB.SLBan * tSach.DonGiaBan) AS doanhSoKhachHang
FROM tHoaDonBan
INNER JOIN tChiTietHDB ON tChiTietHDB.SoHDB = tHoaDonBan.SoHDB
INNER JOIN tKhachHang ON tKhachHang.MaKH = tHoaDonBan.MaKH
INNER JOIN tSach ON tSach.MaSach = tChiTietHDB.MaSach
GROUP BY tHoaDonBan.MaKH, tKhachHang.TenKH
ORDER BY doanhSoKhachHang DESC;

-- 24.   In ra danh sách các sách có giá bán bằng 1 trong 3 mức giá cao nhất.
SELECT tSach.TenSach,
		tSach.DonGiaBan
FROM tSach
WHERE tSach.DonGiaBan IN (
	SELECT DISTINCT TOP 3
		tSach.DonGiaBan
	FROM tSach
	ORDER BY tSach.DonGiaBan DESC
)
ORDER BY tSach.DonGiaBan DESC

-- 25.   In ra danh sách các sách do NXB Giáo Dục sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của tất cả các sản phẩm).
SELECT 
	tSach.TenSach,
	tSach.DonGiaBan
FROM tSach
INNER JOIN tNhaXuatBan ON tNhaXuatBan.MaNXB = tSach.MaNXB
WHERE tSach.DonGiaBan IN (
	SELECT DISTINCT TOP 3
		tSach.DonGiaBan
	FROM tSach
	ORDER BY tSach.DonGiaBan DESC
) AND tNhaXuatBan.TenNXB = N'NXB Giáo Dục'
-- AND tNhaXuatBan.TenNXB = N'NXB ĐH QGHN' sẽ cho kết quả

-- 26.   Tính tổng số đầu sách do NXB Giáo Dục xuất bản.
SELECT COUNT(tSach.MaSach) AS SoDauSach
FROM tSach
INNER JOIN tNhaXuatBan ON tNhaXuatBan.MaNXB = tSach.MaNXB
WHERE tNhaXuatBan.TenNXB = N'NXB Giáo Dục'

-- 27.   Tính tổng số sách của từng NXB.
SELECT 
	tSach.MaNXB,
	COUNT(tSach.MaSach) AS SoDauSach
FROM tSach
INNER JOIN tNhaXuatBan ON tNhaXuatBan.MaNXB = tSach.MaNXB
GROUP BY tSach.MaNXB

-- 28.   Với từng NXB, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm.
SELECT
	tSach.MaNXB,
	MAX(tSach.DonGiaBan) AS MaxPrice,
	MIN (tSach.DonGiaBan) AS MinPrice,
	AVG (tSach.DonGiaBan) AS AVGPrice
FROM tSach
GROUP BY tSach.MaNXB

-- 29.   Tính doanh thu bán hàng mỗi ngày.
SELECT 
	tHoaDonBan.NgayBan,
	SUM(tChiTietHDB.SLBan*tSach.DonGiaBan) AS tri_gia
FROM tChiTietHDB
INNER JOIN tSach ON tSach.MaSach = tChiTietHDB.MaSach
INNER JOIN tHoaDonBan ON tHoaDonBan.SoHDB = tChiTietHDB.SoHDB
GROUP BY tHoaDonBan.NgayBan

-- 30.   Tính tổng số lượng của từng sách bán ra trong tháng 10/2014.
SELECT
    tSach.MaSach,
    tSach.TenSach,
    SUM(tChiTietHDB.SLBan) AS total_quantity
FROM tChiTietHDB
INNER JOIN tSach ON tChiTietHDB.MaSach = tSach.MaSach
INNER JOIN tHoaDonBan ON tHoaDonBan.SoHDB = tChiTietHDB.SoHDB
WHERE
    tHoaDonBan.NgayBan >= '2014-05-01' AND tHoaDonBan.NgayBan <= '2014-05-31'
GROUP BY
    tSach.MaSach, tSach.TenSach
ORDER BY
    total_quantity DESC;

-- 31.   Tính doanh thu bán hàng của từng tháng trong năm 2014 (kể cả những tháng không có doanh thu, VD: Tháng 1: 0; Tháng 2: 12000000; Tháng 3: 0; Tháng ….)
SELECT 
    DATENAME(MONTH, DATEADD(MONTH, Months.MonthNumber - 1, '1900-01-01')) AS MonthName,
    SUM(ISNULL(tChiTietHDB.SLBan * tSach.DonGiaBan, 0)) AS total_revenue
FROM (
    SELECT 1 AS MonthNumber UNION ALL
    SELECT 2 UNION ALL
    SELECT 3 UNION ALL
    SELECT 4 UNION ALL
    SELECT 5 UNION ALL
    SELECT 6 UNION ALL
    SELECT 7 UNION ALL
    SELECT 8 UNION ALL
    SELECT 9 UNION ALL
    SELECT 10 UNION ALL
    SELECT 11 UNION ALL
    SELECT 12
) AS Months
LEFT JOIN tHoaDonBan ON MONTH(tHoaDonBan.NgayBan) = Months.MonthNumber AND YEAR(tHoaDonBan.NgayBan) = 2014
LEFT JOIN tChiTietHDB ON tHoaDonBan.SoHDB = tChiTietHDB.SoHDB
LEFT JOIN tSach ON tSach.MaSach = tChiTietHDB.MaSach
GROUP BY Months.MonthNumber
ORDER BY Months.MonthNumber

-- 32.   Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.
SELECT tChiTietHDB.SoHDB
FROM tChiTietHDB
GROUP BY tChiTietHDB.SoHDB
HAVING COUNT(DISTINCT tChiTietHDB.MaSach) >= 4

-- 33.   Tìm hóa đơn có mua 3 sách do NXB Giáo Dục xuất bản (3 sách khác nhau).
SELECT
	tChiTietHDB.SoHDB
FROM tSach
INNER JOIN tChiTietHDB ON tChiTietHDB.MaSach = tSach.MaSach
INNER JOIN tNhaXuatBan ON tNhaXuatBan.MaNXB = tSach.MaNXB
WHERE tNhaXuatBan.TenNXB = N'NXB Thăng Long'
GROUP BY tChiTietHDB.SoHDB
HAVING COUNT(DISTINCT tChiTietHDB.MaSach) = 3
	
-- 34.   Tìm khách hàng (MaKH, TenKH) có số lần mua hàng nhiều nhất.
SELECT TOP 1
    tKhachHang.MaKH,
    tKhachHang.TenKH,
    COUNT(DISTINCT tHoaDonBan.SoHDB) AS PurchaseCount
FROM tKhachHang
INNER JOIN tHoaDonBan ON tKhachHang.MaKH = tHoaDonBan.MaKH
GROUP BY tKhachHang.MaKH, tKhachHang.TenKH
ORDER BY PurchaseCount DESC;

-- c2:
WITH PurchaseCounts AS (
    SELECT
        tKhachHang.MaKH,
        tKhachHang.TenKH,
        COUNT(DISTINCT tHoaDonBan.SoHDB) AS PurchaseCount
    FROM tKhachHang
    INNER JOIN tHoaDonBan ON tKhachHang.MaKH = tHoaDonBan.MaKH
    GROUP BY tKhachHang.MaKH, tKhachHang.TenKH
)
SELECT
    MaKH,
    TenKH,
    PurchaseCount
FROM PurchaseCounts
WHERE PurchaseCount = (
    SELECT MAX(PurchaseCount) FROM PurchaseCounts
);

-- 35.   Tháng mấy trong năm 2014, doanh số bán hàng cao nhất ?
-- Find the month with the highest sales revenue in 2014
SELECT TOP 1
    DATEPART(MONTH, tHoaDonBan.NgayBan) AS MonthNumber,
    SUM(tChiTietHDB.SLBan * tSach.DonGiaBan) AS TotalRevenue
FROM tChiTietHDB
INNER JOIN tSach ON tChiTietHDB.MaSach = tSach.MaSach
INNER JOIN tHoaDonBan ON tHoaDonBan.SoHDB = tChiTietHDB.SoHDB
WHERE YEAR(tHoaDonBan.NgayBan) = 2014
GROUP BY DATEPART(MONTH, tHoaDonBan.NgayBan)
ORDER BY TotalRevenue DESC;

-- 36.   Tìm sách có tổng số lượng bán ra thấp nhất trong năm 2014.
SELECT
	TOP 1
    tSach.MaSach,
    tSach.TenSach,
    SUM(tChiTietHDB.SLBan) AS total_quantity
FROM tChiTietHDB
INNER JOIN tSach ON tChiTietHDB.MaSach = tSach.MaSach
INNER JOIN tHoaDonBan ON tHoaDonBan.SoHDB = tChiTietHDB.SoHDB
WHERE
    tHoaDonBan.NgayBan >= '2014-01-01' AND tHoaDonBan.NgayBan <= '2014-12-31'
GROUP BY
    tSach.MaSach, tSach.TenSach
ORDER BY
    total_quantity ASC

--c2 
-- Find books with the lowest total quantity sold in 2014

SELECT
    MaSach,
    TenSach,
    total_quantity
FROM (
    SELECT
        tSach.MaSach,
        tSach.TenSach,
        SUM(tChiTietHDB.SLBan) AS total_quantity
    FROM tChiTietHDB
    INNER JOIN tSach ON tChiTietHDB.MaSach = tSach.MaSach
    INNER JOIN tHoaDonBan ON tHoaDonBan.SoHDB = tChiTietHDB.SoHDB
    WHERE
        tHoaDonBan.NgayBan >= '2014-01-01' AND tHoaDonBan.NgayBan <= '2014-12-31'
    GROUP BY
        tSach.MaSach, tSach.TenSach
) as BookQuantities
WHERE total_quantity = (
    SELECT MIN(total_quantity) FROM (
    SELECT
        tSach.MaSach,
        tSach.TenSach,
        SUM(tChiTietHDB.SLBan) AS total_quantity
    FROM tChiTietHDB
    INNER JOIN tSach ON tChiTietHDB.MaSach = tSach.MaSach
    INNER JOIN tHoaDonBan ON tHoaDonBan.SoHDB = tChiTietHDB.SoHDB
    WHERE
        tHoaDonBan.NgayBan >= '2014-01-01' AND tHoaDonBan.NgayBan <= '2014-12-31'
    GROUP BY
        tSach.MaSach, tSach.TenSach
) as BookQuantities
);


-- 37.   Mỗi NXB, tìm sách (MaSach,TenSach) có giá bán cao nhất.
SELECT 
	tSach.MaNXB,
	tNhaXuatBan.TenNXB,
	tSach.MaSach,
	tSach.TenSach,
	MAX(tSach.DonGiaBan) AS GIATRIMAX
FROM tSach
INNER JOIN tNhaXuatBan ON tNhaXuatBan.MaNXB = tSach.MaNXB
GROUP BY 
	tNhaXuatBan.TenNXB,
	tSach.MaNXB,
	tSach.MaSach,
	tSach.TenSach

-- 38.   Giảm giá sách 10% cho các sách của NXB Giáo Dục 
-- 39.   Thêm trưởng tổng tiền cho bảng tHoaDonBan rồi cập nhật tổng tiền của hóa đơn cho trường này.
-- 40. Giảm 10% trên tổng hóa đơn cho các hóa đơn có trị giá trên 500.000 trong tháng 9/2014
-- 41.   Tính tổng số lượng sách nhập trong năm 2014
-- 42.   Tính tổng số lượng sách bán trong năm 2014
-- 43.   Tính tổng tiền đã nhập trong năm 2014
-- 44.   Xóa những hóa đơn do nhân viên "Trần Huy" lập (lưu ý xóa chi tiết hóa đơn trước)
-- 45.   Đổi tên "NXB Thăng Long" thành "NXB Văn học
-- 46.   Đưa ra thông tin toàn bộ sách, nếu sách được bán trong năm 2014 thì đưa ra SL bán