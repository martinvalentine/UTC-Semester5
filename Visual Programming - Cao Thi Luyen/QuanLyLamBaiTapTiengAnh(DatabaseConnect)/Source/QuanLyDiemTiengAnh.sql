
USE QuanLyDiemTiengAnh

CREATE TABLE tHocSinh
(
	MaHS NVARCHAR(5) NOT NULL,
	HoTen NVARCHAR(50),
	Lop NVARCHAR(10),

	CONSTRAINT pk_tHocSinh PRIMARY KEY(MaHS)
)

CREATE TABLE tPhieuDiem
(
	MaHS NVARCHAR(5) NOT NULL,
	Diem INT,
	TGBatDau DATETIME,
	TGKetThuc DATETIME,
	MaBai NVARCHAR(5) NOT NULL,
	SoLanLam INT,

	CONSTRAINT PK_tPhieuDiem PRIMARY KEY CLUSTERED 
	(
		MaHS ASC,
		MaBai ASC
	)
)

CREATE TABLE tDangBaiTap
(
	DangBaiTap NVARCHAR(50),
	TenBai NVARCHAR(50),
	MaBai NVARCHAR(5) NOT NULL,

	CONSTRAINT pk_tDangBaiTap PRIMARY KEY(MaBai)
)

-- Vì ở đây 2 khóa ở tPhieuDiem vừa là khóa chính khóa phụ nên ta sẽ tạo ràng buộc với 2 bảng còn lại

ALTER TABLE [dbo].[tPhieuDiem]  WITH CHECK ADD CONSTRAINT [FK_tPhieuDiem_tHocSinh] FOREIGN KEY([MaHS])
REFERENCES [dbo].[tHocSinh] ([MaHS])

ALTER TABLE [dbo].[tPhieuDiem]  WITH CHECK ADD CONSTRAINT [FK_tPhieuDiem_tDangBaiTap] FOREIGN KEY([MaBai])
REFERENCES [dbo].[tDangBaiTap] ([MaBai])
