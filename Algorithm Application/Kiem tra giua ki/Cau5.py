# Người Á Đông quan niệm số gồm các chữ số 6 và 8 là chữ số may mắn. Nhân dịp năm mới Mậu Tuất (2018) một nhóm các sinh viên đến chúc tết thầy Tichpx và được Tichpx mừng tuổi cho các sinh viên của mình là với số tiền là một số tự nhiên nhỏ nhất chỉ gồm các chữ số và chia hết cho tích số tuổi của các sinh viên.


from collections import deque


def bfs_find_number(n):
    queue = deque()
    queue.append(6)
    queue.append(8)

    while queue:
        current_number = queue.popleft()
        if current_number % n == 0:
            return current_number
        if current_number > 1e15: return 0
        queue.append(current_number * 10 + 6)
        queue.append(current_number * 10 + 8)


n = int(input())
result = bfs_find_number(n)
print(result)