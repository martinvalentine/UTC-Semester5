# Một tòa nhà cao n tầng được đánh số từ tầng 1 đến tầng n có lắp 1 thang máy. Hiện nay thang máy bị trục trặc do đó mỗi lần có thể di chuyển k khả năng 
#  tầng với 
#  là đi lên và 
#  là đi xuống nếu nó đủ không gian di chuyển tức là xuống không quá tầng 1 và lên không quá tầng n. Thang máy đang ở tầng s một người ở đó muốn di chuyển đến tầng f hỏi số bước di chuyển ít nhất để đến được tầng f, trường hợp không di chuyển được xuất ra -1.

# Input
# Dòng đầu chứa n là số tầng của tòa nhà 
#  và số nguyên dương k là số các khả năng di chuyển 

# Dòng thứ 2 chứa k số nguyên có giá trị tuyệt đối không vượt quá 
#  nếu âm thì thang máy đi xuống, nếu dương là thang máy đi lên

# Dòng thứ 3 chứa s và f (1<=s,f<=n) là vị trí tầng xuất phát và đích đến

# Output
# Số bước ít nhất di chuyển thang máy, nếu không đến được đích xuất ra -1

from collections import deque
def thangmay(n, k, step, s, f):
    a = [False] * (n + 1)
    queue = deque([(s, 0)])

    while queue:
        i, steps = queue.popleft()
        a[i] = True

        if i == f:
            return steps

        for move in step:
            j = i + move
            if 1 <= j <= n and not a[j]:
                queue.append((j, steps + 1))
                a[j] = True 

    return -1

n, k = map(int, input().split())
step = list(map(int, input().split()))
s, f = map(int, input().split())

res = thangmay(n, k, step, s, f)
print(res)