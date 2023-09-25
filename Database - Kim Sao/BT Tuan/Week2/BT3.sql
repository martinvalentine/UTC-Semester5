USE	Week2_QLSinhVien

-- C1. Tạo login Login1, tạo User1 cho Login1
	EXEC sp_addlogin 'Login1', '123'
	USE Week2_QLSinhVien
	CREATE USER User1 FOR LOGIN Login1
-- C2. Phân quyền Select trên bảng DSSinhVien cho User1
	GRANT SELECT ON DSSinhVien TO User1
-- C3. Đăng nhập để kiểm tra
-- C4. Tạo login Login2, tạo User2 cho Login2
	EXEC sp_addlogin 'Login2', '123'
	USE Week2_QLSinhVien
	CREATE USER User2 FOR LOGIN Login2
-- C5. Phân quyền Update trên bảng DSSinhVien cho User2, người này có thể cho phép người khác sử dụng quyền này
	GRANT UPDATE ON DSSinhVien TO User2 WITH GRANT OPTION
-- C6. Đăng nhập dưới Login2 và trao quyền Update trên bảng DSSinhVien cho User 1
-- C7. Đăng nhập Login 1 để kiểm tra
	