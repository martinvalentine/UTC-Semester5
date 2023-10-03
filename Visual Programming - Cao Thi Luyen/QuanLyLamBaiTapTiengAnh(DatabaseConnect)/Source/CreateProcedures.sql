CREATE PROCEDURE spInsertHS (@mahs NVARCHAR(5), @hoten NVARCHAR(50), @lop NVARCHAR(10))
AS
BEGIN
    INSERT INTO tHocSinh (MaHS, HoTen, Lop)
    VALUES (@mahs, @hoten, @lop);
END

CREATE PROCEDURE spInsertPhieuDiem (@mahs NVARCHAR(5), @diem INT, @tgBatDau DATETIME, @tgKetThuc DATETIME, @maBai NVARCHAR(5), @soLanLam INT)  
AS
BEGIN
    INSERT INTO tPhieuDiem (MaHS, Diem, TGBatDau, TGKetThuc, MaBai, SoLanLam)
    VALUES (@mahs, @diem, @tgBatDau, @tgKetThuc, @maBai, @soLanLam);
END

CREATE PROCEDURE spInsertDangBaiTap (@dangBaiTap NVARCHAR(50), @tenBai NVARCHAR(50), @maBai NVARCHAR(5))
AS
BEGIN
    INSERT INTO tDangBaiTap (DangBaiTap, TenBai, MaBai)
    VALUES (@dangBaiTap, @tenBai, @maBai);
END

