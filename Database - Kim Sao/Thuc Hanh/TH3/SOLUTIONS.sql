USE QLDonDatHang
GO

-- 1. Kiểm soát giới tính của nhân viên chỉ được nhập giá trị là ‘Nam’ hoặc ‘Nữ’
-- 2. Kiểm soát ngày vào làm (NgayLV) của nhân viên phải sau ngày sinh và đảm bảo nhân viên trên 18 tuổi
-- 3. Thêm trường Đơn vị tính vào bảng Hàng hóa. Kiểm soát đơn vị tính khi nhập hàng hóa chỉ được chứa từ “Cái”, “Hộp”, “Thùng”, “Kg”, “Chiếc”
-- 4. Tạo trigger cập nhật tự động giá của bảng hàng hóa sang bảng chi tiết hóa đơn mỗi khi thêm mới bản ghi
-- 5. Thêm trường ChietKhau vào bảng CT_Hoadon và cập nhật tự động trường này bằng 15% giá bán
-- 6. Thêm Trường ThanhTien và cập nhật tự động cho trường này
-- 7. Cập nhật lại giá của bảng hàng hóa sang bảng chi tiết hóa đơn