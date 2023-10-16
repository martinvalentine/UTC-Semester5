USE QLDuThi
GO
/* 
1. Tạo view KET QUA chứa kết quả thi của từng học sinh bao gồm các thông tin: SoBD, HoTen, Phai, Tuoi, Toan, Van, AnhVan, TongDiem, XepLoai, DTDuThi 
Biết rằng: TongDiem = Toan + Van + AnhVan + DiemUT 
XepLoai học sinh như sau: 
* Giỏi nếu TongDiem>=24 và tất cả các môn >=7 
* Khá nếu TongDiem>=21 và tất cả các môn >=6 
* Trung Bình nếu TongDiem>=15 và tất cả các môn >=4 
* Trượt nếu ngược lại 
*/
CREATE VIEW KETQUA
AS
SELECT
	DanhSach.SoBD,
	(DanhSach.Ho + ' ' + DanhSach.Ten) AS HoTen,
	DanhSach.Phai,
	DATEDIFF(YEAR,DanhSach.NTNS,GETDATE()) AS Tuoi,
	Toan,
	Van,
	AnhVan,
	(Toan + Van + AnhVan + ChiTietDT.DiemUT) AS TongDiem,
	CASE
		WHEN (Toan + Van + AnhVan + ChiTietDT.DiemUT) >= 24 
			AND LEAST(Toan, Van, AnhVan) >= 7 THEN N'Giỏi'
		WHEN (Toan + Van + AnhVan + ChiTietDT.DiemUT) >= 21
			AND LEAST(Toan, Van, AnhVan) >= 5 THEN N'Khá'
		WHEN (Toan + Van + AnhVan + ChiTietDT.DiemUT) >= 15 
			AND LEAST(Toan, Van, AnhVan) >= 4 THEN N'Trung bình'
		ELSE N'Trượt'
	END AS XepLoai,
	DanhSach.DTDuThi
FROM DiemThi
	INNER JOIN DanhSach ON DanhSach.SoBD = DiemThi.SoBD
	INNER JOIN ChiTietDT on ChiTietDT.DTDuThi = DanhSach.DTDuThi

SELECT * FROM KETQUA
GO
/*
2. Tạo view GIOI TOAN – VAN – ANH VAN bao gồm các học sinh có ít nhất 1 môn 10 và có TongDiem>=25 bao gồm các thông tin: SoBD, HoTen, Toan, Van, AnhVan, TongDiem, DienGiaiDT 
*/
CREATE VIEW GIOI_TOAN_VAN_ANHVAN 
AS
SELECT
	KETQUA.SoBD,
	KETQUA.HoTen,
	KETQUA.Toan,
	KETQUA.Van,
	KETQUA.AnhVan,
	KETQUA.TongDiem,
	ChiTietDT.DienGiaiDT
FROM KETQUA
	INNER JOIN ChiTietDT ON ChiTietDT.DTDuThi = KETQUA.DTDuThi
WHERE (KETQUA.Toan = 10 OR KETQUA.Van = 10 OR KETQUA.AnhVan = 10) AND KETQUA.TongDiem >= 25

SELECT * FROM GIOI_TOAN_VAN_ANHVAN
GO
/*
3. Tạo view DANH SACH DAU (ĐẬU) gồm các học sinh có XepLoai là Giỏi, Khá hoặc Trung Bình với các field: SoBD, HoTen, Phai, Tuoi, Toan, Van, AnhVan, TongDiem, XepLoai, DTDuThi
*/
CREATE VIEW DANHSACHDAU
AS
SELECT * FROM KETQUA
WHERE KETQUA.XepLoai = N'Giỏi' OR KETQUA.XepLoai = N'Khá' OR KETQUA.XepLoai = N'Trung Bình'

GO

SELECT * FROM DANHSACHDAU
GO
/*
4. Tạo view HOC SINH DAT THU KHOA KY THI bao gồm các học sinh “ĐẬU” có TongDiem lớn nhất với các field: SoBD, HoTen, Phai, Tuoi, Toan, Van, AnhVan, TongDiem, DienGiaiDT
*/
CREATE VIEW HOCSINHDATTHUKHOAKYTHI
AS
SELECT *
FROM DANHSACHDAU
WHERE DANHSACHDAU.TongDiem = (SELECT MAX(DANHSACHDAU.TongDiem) FROM DANHSACHDAU)
GO

SELECT * FROM HOCSINHDATTHUKHOAKYTHI
GO

-- 5. Tạo thủ tục có đầu vào là số báo danh, đầu ra là các điểm thi, điểm ưu tiên và tổng điểm
CREATE PROCEDURE CAU5
(
	@SBD INT,
	@DIEMTOAN FLOAT OUTPUT,
	@DIEMVAN FLOAT OUTPUT,
	@DIEMANHVAN FLOAT OUTPUT,
	@DIEMDIEMUUTIEN FLOAT OUTPUT,
	@TONGDIEM FLOAT OUTPUT
)
AS
BEGIN
	SELECT
		@DIEMTOAN = KETQUA.Toan,
		@DIEMVAN = KETQUA.Van,
		@DIEMANHVAN = KETQUA.AnhVan,
		@DIEMDIEMUUTIEN = ChiTietDT.DiemUT,
		@TONGDIEM = KETQUA.TongDiem
	FROM
		KETQUA
		INNER JOIN ChiTietDT ON ChiTietDT.DTDuThi = KETQUA.DTDuThi
	WHERE KETQUA.SoBD = @SBD
END

-- Chạy test
DECLARE @TOAN FLOAT , @VAN FLOAT, @ANHVAN FLOAT, @DIEMUT FLOAT,	@TONG FLOAT
EXEC CAU5 '69', @TOAN OUTPUT , @VAN OUTPUT, @ANHVAN OUTPUT, @DIEMUT OUTPUT, @TONG OUTPUT
PRINT N'ĐIỂM TOÁN: ' + CONVERT(NVARCHAR,@TOAN)
PRINT N'ĐIỂM VĂN: ' + CONVERT(NVARCHAR,@VAN)
PRINT N'ĐIỂM ANH: ' + CONVERT(NVARCHAR,@ANHVAN)
PRINT N'TỔNG ĐIỂM: ' + CONVERT(NVARCHAR,@TONG)


-- 6. Tạo trigger kiểm tra xem việc nhập mã đối tượng dự thi trong bảng danh sách có đúng với bảng đối tượng dự thi không
CREATE TRIGGER CAU6 ON DanhSach
AFTER INSERT, UPDATE
AS
BEGIN
	DECLARE @MADT INT
	SELECT @MADT = DTDuThi FROM inserted
	--IF @MADT NOT IN (SELECT ChiTietDT.DTDuThi FROM ChiTietDT)
	IF @MADT != 1 AND @MADT != 2 AND @MADT != 3
	BEGIN
		PRINT N'Mã đối tượng dự thi nhập vào phải nằm trong 1, 2, 3'
		ROLLBACK TRANSACTION
	END
END

UPDATE DanhSach SET DTDuThi = 9 WHERE SoBD = 65

-- 7. Thêm trường điểm ưu tiên và tổng điểm vào bảng Điểm thi. Tạo trigger cập nhật tự động trường ưu tiên và tổng điểm mỗi khi nhập hay chỉnh sửa
ALTER TABLE DiemThi ADD DiemUT FLOAT, TongDiem FLOAT 
GO

CREATE TRIGGER CAU7 ON DiemThi
AFTER INSERT, UPDATE AS
BEGIN
	DECLARE @SBD INT, @DTDuThi INT, @TONGDIEM float, @DiemUuTien float
	SELECT @SBD = SoBD FROM inserted
	SELECT @DTDuThi = DTDuThi FROM DanhSach WHERE @sbd = SoBD
	SELECT @DiemUuTien = DiemUT from ChiTietDT WHERE @DTDuThi = DTDuThi
	SELECT @TONGDIEM = (Toan+Van+AnhVan+ @DiemUuTien) FROM DiemThi WHERE @sbd = SoBD
	UPDATE DiemThi SET DiemUT = @DiemUuTien, TongDiem = @TONGDIEM WHERE @sbd = SoBD
END

SELECT * FROM DiemThi WHERE SoBD = 4
UPDATE DiemThi SET Toan = 9 WHERE SoBD = 4
SELECT * FROM DiemThi WHERE SoBD = 4

-- 8. Tạo trigger xóa tự động bản ghi tương ứng ở bảng điểm khi xóa bản ghi ở danh sách
CREATE TRIGGER CAU8 ON DanhSach
AFTER DELETE
AS
BEGIN
	DECLARE @SBD INT
	SELECT @SBD = SoBD FROM deleted
	DELETE FROM DiemThi WHERE DiemThi.SoBD = @SBD
END 

DELETE FROM DanhSach WHERE DanhSach.SoBD = '69'
SELECT * FROM DanhSach WHERE DanhSach.SoBD = '69'
SELECT * FROM DiemThi WHERE DiemThi.SoBD = '69'

GO
