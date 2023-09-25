USE Week2_QLSinhVien

-- C1: Tạo View danh sách sinh viên, gồm các thông tin sau: Mã sinh viên, Họ sinh viên, Tên sinh viên, Học bổng.
GO
CREATE VIEW SOLUTION1 AS
SELECT
	DSSinhVien.MaSV, 
	DSSinhVien.HoSV,
	DSSinhVien.TenSV,
	DSSinhVien.HocBong
FROM
	DSSinhVien

SELECT * FROM SOLUTION1

-- C2: Tạo view Liệt kê các sinh viên có học bổng từ 150,000 trở lên và sinh ở Hà Nội, gồm các thông tin: Họ tên sinh viên, Mã khoa, Nơi sinh, Học bổng.
GO
CREATE VIEW SOLUTION2 AS
SELECT
	DSSinhVien.HoSV + ' ' + DSSinhVien.TenSV AS N'Họ tên sinh viên',
	DSSinhVien.MaKhoa AS N'Mã Khoa',
	DSSinhVien.NoiSinh AS N'Nơi sinh',
	DSSinhVien.HocBong AS N'Học bổng'
FROM
	DSSinhVien
WHERE
	DSSinhVien.HocBong >= 150000 AND DSSinhVien.NoiSinh = N'Hà Nội'

SELECT * FROM SOLUTION2

-- C3: Tạo view liệt kê những sinh viên nam của khoa Anh văn và khoa tin học, gồm các thông tin: Mã sinh viên, Họ tên sinh viên, tên khoa, Phái.
GO 
CREATE VIEW SOLUTION3 AS
SELECT
	DSSinhVien.MaSV AS N'Mã sinh viên',
	DSSinhVien.HoSV + ' ' + DSSinhVien.TenSV AS N'Họ tên sinh viên',
	DMKhoa.TenKhoa AS N'Tên Khoa',
	DSSinhVien.Phai AS N'Phái'
FROM
	DSSinhVien
	INNER JOIN 
	DMKhoa ON DMKhoa.MaKhoa = DSSinhVien.MaKhoa
WHERE 
	DSSinhVien.Phai = 'Nam' AND (DSSinhVien.MaKhoa = 'AV' OR DSSinhVien.MaKhoa = 'TH')

SELECT * FROM SOLUTION3

-- C4: Tạo view gồm những sinh viên có tuổi từ 20 đến 25, thông tin gồm: Họ tên sinh viên, Tuổi, Tên khoa.
GO 
CREATE VIEW SOLUTION4 AS
SELECT
	DSSinhVien.HoSV + ' ' + DSSinhVien.TenSV AS N'Họ tên sinh viên',
	DATEDIFF(YEAR, DSSinhVien.NgaySinh, GETDATE()) AS N'Tuổi',
	DMKhoa.TenKhoa AS N'Tên Khoa'
FROM
	DSSinhVien
	INNER JOIN 
	DMKhoa ON DMKhoa.MaKhoa = DSSinhVien.MaKhoa
WHERE 
	DATEDIFF(YEAR, DSSinhVien.NgaySinh, GETDATE()) BETWEEN 20 AND 25

SELECT * FROM SOLUTION4


-- C5: Tạo view cho biết thông tin về mức học bổng của các sinh viên, gồm: Mã sinh viên, Phái, Mã khoa, Mức học bổng. Trong đó, mức học bổng sẽ hiển thị là “Học bổng cao” nếu giá trị của field học bổng lớn hơn 500,000 và ngược lại hiển thị là “Mức trung bình”
GO 
CREATE VIEW SOLUTION5 AS
SELECT
	DSSinhVien.MaSV AS N'Mã sinh viên',
	DSSinhVien.Phai AS N'Phái',
	DSSinhVien.MaKhoa AS N'Mã khoa',
	CASE
		WHEN DSSinhVien.HocBong > 500000 THEN N'Học bổng cao'
		WHEN DSSinhVien.HocBong IS NULL THEN N'Không có thông tin học bổng'
		ELSE N'Mức trung bình'
	END AS N'Mức học bổng'
FROM
	DSSinhVien
	INNER JOIN 
	DMKhoa ON DMKhoa.MaKhoa = DSSinhVien.MaKhoa

SELECT * FROM SOLUTION5

-- C6: Tạo view đưa ra thông tin những sinh viên có học bổng lớn hơn bất kỳ học bổng của sinh viên học khóa anh văn
GO
CREATE VIEW SOLUTION6 AS
SELECT *
FROM
    DSSinhVien
WHERE
    DSSinhVien.HocBong > (SELECT MAX(DSSinhVien.HocBong) FROM DSSinhVien WHERE MaKhoa = 'AV')

SELECT * FROM SOLUTION6

-- C7: Tạo view đưa ra thông tin những sinh viên đạt điểm cao nhất trong từng môn.
GO
CREATE VIEW SOLUTION7 AS
SELECT DISTINCT 
	KetQua.MaMH,
	DSSinhVien.MaSV AS N'Mã sinh viên',
	DSSinhVien.HoSV AS N'Họ',
	DSSinhVien.TenSV AS N'Tên', 
	Diem AS N'Điểm'
FROM KetQua
INNER JOIN 
	(
	 SELECT MaMH, MAX(Diem) AS MaxDiem
	 FROM KetQua
	 GROUP BY MaMH
	) 
	AS MaxDiemMon ON KetQua.MaMH = MaxDiemMon.MaMH AND KetQua.Diem = MaxDiemMon.MaxDiem
INNER JOIN DSSinhVien ON KETQUA.MaSV = DSSINHVIEN.MaSV

SELECT * FROM SOLUTION7
ORDER BY MaMH

-- C8: Tạo view đưa ra những sinh viên chưa thi môn cơ sở dữ liệu.
GO
CREATE VIEW SOLUTION8 AS
SELECT
    DSSinhVien.MaSV AS 'Mã sinh viên',
    DSSinhVien.HoSV + ' ' + DSSinhVien.TenSV AS 'Họ tên sinh viên'
FROM
    DSSinhVien
WHERE
    DSSinhVien.MaSV NOT IN (SELECT MaSV FROM KetQua WHERE MaMH = '01')

SELECT * FROM SOLUTION8

-- C9: Tạo view đưa ra thông tin những sinh viên không trượt môn nào.
GO
CREATE VIEW SOLUTION9 AS
SELECT *
FROM 
    DSSinhVien
WHERE 
    NOT EXISTS 
	(
        SELECT 1
        FROM KetQua
        WHERE KetQua.MaSV = DSSinhVien.MaSV AND (KetQua.Diem < 4.5 OR KetQua.LanThi > 1)
    )

SELECT * FROM SOLUTION9


