USE QLDuThi
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
	DiemThi.Toan,
	DiemThi.Van,
	DiemThi.AnhVan,
	(DiemThi.Toan + DiemThi.Van + DiemThi.AnhVan + ChiTietDT.DiemUT) AS TongDiem,
	CASE
		WHEN (DiemThi.Toan + DiemThi.Van + DiemThi.AnhVan + ChiTietDT.DiemUT) >= 24 
			AND LEAST(DiemThi.Toan,DiemThi.Van,DiemThi.AnhVan) >= 7 THEN N'Giỏi'
		WHEN (DiemThi.Toan + DiemThi.Van + DiemThi.AnhVan + ChiTietDT.DiemUT) >= 21
			AND LEAST(DiemThi.Toan,DiemThi.Van,DiemThi.AnhVan) >= 5 THEN N'Khá'
		WHEN (DiemThi.Toan + DiemThi.Van + DiemThi.AnhVan + ChiTietDT.DiemUT) >= 15 
			AND LEAST(DiemThi.Toan,DiemThi.Van,DiemThi.AnhVan) >= 4 THEN N'Trung bình'
		ELSE N'Trượt'
	

/*
2. Tạo view GIOI TOAN – VAN – ANH VAN bao gồm các học sinh có ít nhất 1 môn 10 và có TongDiem>=25 bao gồm các thông tin: SoBD, HoTen, Toan, Van, AnhVan, TongDiem, DienGiaiDT 
*/
/*
3. Tạo view DANH SACH DAU (ĐẬU) gồm các học sinh có XepLoai là Giỏi, Khá hoặc Trung Bình với các field: SoBD, HoTen, Phai, Tuoi, Toan, Van, AnhVan, TongDiem, XepLoai, DTDuThi
*/
/*
4. Tạo view HOC SINH DAT THU KHOA KY THI bao gồm các học sinh “ĐẬU” có TongDiem lớn nhất với các field: SoBD, HoTen, Phai, Tuoi, Toan, Van, AnhVan, TongDiem, DienGiaiDT
*/
-- 5. Tạo thủ tục có đầu vào là số báo danh, đầu ra là các điểm thi, điểm ưu tiên và tổng điểm
-- 6. Tạo trigger kiểm tra xem việc nhập mã đối tượng dự thi trong bảng danh sách có đúng với bảng đối tượng dự thi không


-- 7. Thêm trường điểm ưu tiên và tổng điểm vào bảng Điểm thi. Tạo trigger cập nhật tự động trường ưu tiên và tổng điểm mỗi khi nhập hay chỉnh sửa
ALTER table DiemThi add DiemUT float, TongDiem float 

ALTer trigger Trigger_Cau7 on DiemThi
after INSERT, UPDATE AS
BEGIN
	declare @sbd int, @dtdt tinyint, @dt float, @dut float
	select @sbd = SoBD from inserted
	select @dtdt = DTDuThi from DanhSach where @sbd = SoBD
	select @dut = DiemUT from ChiTietDT where @dtdt = DTDuThi
	select @dt = (Toan+Van+AnhVan+@dut) from DiemThi where @sbd = SoBD
	update DiemThi set DiemUT = @dut, TongDiem = @dt where @sbd = SoBD
END

select * from DiemThi where SoBD = 2
update DiemThi set Toan = 9 where SoBD = 2
select * from DiemThi where SoBD = 2
-- 8. Tạo trigger xóa tự động bản ghi tương ứng ở bảng điểm khi xóa bản ghi ở danh sách