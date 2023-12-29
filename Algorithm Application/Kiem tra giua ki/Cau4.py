n = int(input())
prices = list(map(int, input().split()))

# Bước 2: Sắp xếp mảng giá tăng dần
prices.sort()

# Bước 3: Tính tổng giá tiền của n cuốn vở
total_price = sum(prices)

# Bước 4: Áp dụng khuyến mại tham lam
# Lựa chọn 1: giảm giá cuốn ít tiền nhất trong mỗi nhóm 3 cuốn.
discount_option_1 = sum(prices[:n // 3])

# Lựa chọn 2: giảm giá tối đa một phần ba tổng giá tiền.
discount_option_2 = total_price // 3

# Chọn lựa chọn tối ưu
discount = max(discount_option_1, discount_option_2)

# Bước 5: In ra số tiền phải trả
print(total_price - discount)