USE Week2_QLHocSinh

-- C1: Tạo view DSHS10A1 gồm thông tin Mã học sinh, họ tên, giới tính (là “Nữ” nếu Nu=1, ngược lại là “Nam”), các điểm Toán, Lý, Hóa, Văn của các học sinh lớp 10A1
GO
CREATE VIEW DSHS10A1 AS
SELECT 
    DSHS.MaHS,
    DSHS.Ho + ' ' + DSHS.Ten AS 'HoTen',
    CASE WHEN DSHS.Nu = 1 THEN N'Nữ' ELSE N'Nam' END AS 'GioiTinh',
    DIEM.Toan,
    DIEM.Ly,
    DIEM.Hoa,
    DIEM.Van
FROM 
    DSHS
	INNER JOIN 
	DIEM ON DIEM.MAHS = DSHS.MAHS
WHERE 
    DSHS.MALOP = '10A1'

SELECT * FROM DSHS10A1

-- C2: Tạo login TranThanhPhong, tạo user TranThanhPhong cho TranThanhPhong trên CSDL QLHocSinh
		exec sp_addlogin TranThanhPhong,123
		use Week2_QLHocSinh
		exec sp_adduser TranThanhPhong,TranThanhPhong

	--	Phân quyền Select trên view DSHS10A1 cho TranThanhPhong
		GRANT SELECT ON DSHS10A1 TO TranThanhPhong

	--	Đăng nhập TranThanhPhong để kiểm tra

	--	Tạo login PhamVanNam, tạo PhamVanNam cho PhamVanNam trên CSDL QLHocSinh
		exec sp_addlogin PhamVanNam,123
		use Week2_QLHocSinh
		exec sp_adduser PhamVanNam,PhamVanNam

	--	Đăng nhập PhamVanNam để kiểm tra
		

	--	Tạo view DSHS10A2 tương tự như câu 1
		GO
		CREATE VIEW DSHS10A2 AS
		SELECT 
			DSHS.MaHS,
			DSHS.Ho + ' ' + DSHS.Ten AS 'HoTen',
			CASE WHEN DSHS.Nu = 1 THEN N'Nữ' ELSE N'Nam' END AS 'GioiTinh',
			DIEM.Toan,
			DIEM.Ly,
			DIEM.Hoa,
			DIEM.Van
		FROM 
			DSHS
			INNER JOIN 
			DIEM ON DIEM.MAHS = DSHS.MAHS
		WHERE 
			DSHS.MALOP = '10A2'

		SELECT * FROM DSHS10A2

	--	Phân quyền Select trên view DSHS10A2 cho PhamVanNam
		GRANT SELECT ON DSHS10A2 TO PhamVanNam

	--	Đăng nhập PhamVanNam để kiểm tra

-- C3: Tạo view báo cáo Kết thúc năm học gồm các thông tin: Mã học sinh, Họ và tên, Ngày sinh,
	--	Giới tính, Điểm Toán, Lý, Hóa, Văn, Điểm Trung bình, Xếp loại, Sắp xếp theo xếp loại (chọn 1000 bản ghi đầu). Trong đó:
	--	Điểm trung bình (DTB) = ((Toán + Văn)*2 + Lý + Hóa)/6)
	--	Cách thức xếp loại như sau:
		-- Xét điểm thấp nhất (DTN) của các 4 môn
		-- Nếu DTB>5 và DTN>4 là “Lên Lớp”, ngược lại là lưu ban
	GO
	CREATE VIEW KETTHUCNAMHOC AS
	SELECT TOP 1000 
		DIEM.MAHS,
		DSHS.HO,
		DSHS.TEN,
		DSHS.NGAYSINH,
		CASE WHEN DSHS.Nu = 1 THEN N'Nữ' ELSE N'Nam' END AS 'GioiTinh',
		DIEM.TOAN,
		DIEM.LY,
		DIEM.HOA,
		DIEM.VAN,
		((DIEM.TOAN+DIEM.VAN)*2+DIEM.LY+DIEM.HOA)/6 AS DTB,
		CASE WHEN (((DIEM.TOAN+DIEM.VAN)*2+DIEM.LY+DIEM.HOA)/6>=8.5 AND DIEM.TOAN>=8 AND DIEM.VAN>=8 AND DIEM.LY>=8 AND DIEM.HOA>=8) THEN N'Lên Lớp'
	ELSE N'Lưu Ban' END AS XepLoai
	FROM DSHS 
		INNER JOIN
		DIEM ON DSHS.MAHS = DIEM.MAHS
	ORDER BY DTB DESC

	SELECT * FROM KETTHUCNAMHOC

-- C4: Tạo view danh sách HOC SINH XUAT SAC bao gồm các học sinh có DTB>=8.5 và DTN>=8 với các trường: Lop, Mahs, Hoten, Namsinh (năm sinh), Nu, Toan, Ly, Hoa, Van, DTN, DTB
	GO 
	CREATE VIEW HOCSINHXUATSAC AS
	SELECT 
		DIEM.MAHS,
		DSHS.HO,
		DSHS.TEN,
		DSHS.NGAYSINH,
		CASE WHEN DSHS.Nu = 1 THEN N'Nữ' ELSE N'Nam' END AS 'GioiTinh',
		DIEM.TOAN,
		DIEM.LY,
		DIEM.HOA,
		DIEM.VAN,
		((DIEM.TOAN+DIEM.VAN)*2+DIEM.LY+DIEM.HOA)/6 AS DTB
	FROM DSHS 
		INNER JOIN
		DIEM ON DSHS.MAHS = DIEM.MAHS
	WHERE (((DIEM.TOAN+DIEM.VAN)*2+DIEM.LY+DIEM.HOA)/6>=8.5 AND DIEM.TOAN>=8 AND DIEM.VAN>=8 AND DIEM.LY>=8 AND DIEM.HOA>=8)

	SELECT * FROM HOCSINHXUATSAC

-- C5: Tạo view danh sách HOC SINH DAT THU KHOA KY THI bao gồm các học sinh xuất sắc có DTB lớn nhất với các trường: Lop, Mahs, Hoten, Namsinh, Nu, Toan, Ly, Hoa, Van, DTB
GO	
CREATE VIEW HOCSINHDATTHUKHOAKITHI AS
SELECT  TOP 1 WITH TIES
	DIEM.MAHS,
	DSHS.HO,
	DSHS.TEN,
	YEAR(DSHS.NGAYSINH) AS 'NamSinh',
	CASE WHEN DSHS.Nu = 1 THEN N'Nữ' ELSE N'Nam' END AS 'GioiTinh',
	DIEM.TOAN,
	DIEM.LY,
	DIEM.HOA,
	DIEM.VAN,
	((DIEM.TOAN+DIEM.VAN)*2+DIEM.LY+DIEM.HOA)/6 AS DTB
FROM DSHS 
	INNER JOIN
	DIEM ON DSHS.MAHS = DIEM.MAHS
ORDER BY ((DIEM.TOAN+DIEM.VAN)*2+DIEM.LY+DIEM.HOA)/6 DESC

SELECT * FROM HOCSINHDATTHUKHOAKITHI
