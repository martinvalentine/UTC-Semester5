# Trong cuộc trò chuyện, rất phổ biến ở thanh thiếu niên và thanh thiếu niên sử dụng chuỗi ký tự, thường có vẻ ngẫu nhiên để đại diện cho tiếng cười. Một số ví dụ phổ biến là:
# Huaauhahhuahau
# Hehehehe
# Ahahahaha
# Jaisjjkasjksjjskjakijs
# Huehuehue

# Claudia là một lập trình viên trẻ, người đã bị mê hoặc bởi tiếng "tiếng cười kỹ thuật số". Một số người trong số họ thậm chí cô ấy thậm chí không thể phát âm! Nhưng cô ấy nhận ra rằng một số trong số họ có vẻ tốt hơn chuyển tải cảm giác cười so với những người khác. Điều đầu tiên cô nhận thấy là các phụ âm không can thiệp vào tiếng cười kỹ thuật số ảnh hưởng như thế nào đến cảm giác. Điều thứ hai cô nhận ra là tiếng cười vui nhộn nhất là tiếng cười có các nguyên âm mà khi đọc từ trái qua phải hay từ phải qua trái đều giống nhau (bỏ qua phụ âm).

# Ví dụ: "hahaha" và "huaauhahhuahau" là những cười vui nhộn nhất trong khi "riajkjdhhihhjak" và "huehuehue" thì không.
# Claudia rất bận rộn với việc phân tích thống kê tiếng cười kỹ thuật số và nhờ sự giúp đỡ của bạn để viết một chương trình xác định một tiếng cười kỹ thuật số có phải tiếng cười vui nhộn hay không.

# Đầu vào
# Đầu vào bao gồm một dòng có chứa một chuỗi gồm tối đa 50 ký tự, được tạo thành chỉ bởi các chữ cái nhỏ không có dấu. Nguyên âm là chữ 'a', 'e', ​​'i', 'o', 'u'. Trình tự chứa ít nhất một nguyên âm.

# Đầu ra
# Chương trình của bạn nên tạo ra một dòng có chứa một nhân vật, "S" nếu tiếng cười vui nhộn, hoặc "N" nếu không.

# VÍ DỤ 1
# INPUT 1
# Hahaha

# OUTPUT 1
# S

# VÍ DỤ 2
# INPUT 2
# Riajkjdhhihhjak

# OUTPUT 2
# N

# VÍ DỤ 3
# INPUT 3
# a

# OUTPUT 3
# S

# VÍ DỤ 4
# INPUT 4
# Huaauhahhuahau

# OUTPUT 4
# S

def funnyCheck(v):
    a = set("aeiou")
    b = [c for c in v if c in a]
    return b == b[::-1]

v = input("Nhập chuỗi tiếng cười kỹ thuật số: ")

if funnyCheck(v):
    print("S")
else:
    print("N")