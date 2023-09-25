USE BT2

-- C1: Tạo View danh sách sinh viên, gồm các thông tin sau: Mã sinh viên, Họ sinh viên, Tên sinh viên, Học bổng.
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
CREATE VIEW SOLUTION2 AS
SELECT
	DSSinhVien.HoSV + ' ' + DSSinhVien.TenSV AS N'Họ tên sinh viên',
	DSSinhVien.MaKhoa,
	DSSinhVien.NoiSinh,
	DSSinhVien.HocBong
FROM
	DSSinhVien
WHERE
	DSSinhVien.HocBong >= 150000 AND DSSinhVien.NoiSinh = N'Hà Nội'

SELECT * FROM SOLUTION2