size = 20

xs = 1
ys = 1

axisMax = 127//size

for i in range(0,axisMax):
    x0 = xs + (i * size) 
    if i>0: x0 += 1
    x1 = x0 + size
    for j in range(0,axisMax):
        y0 = ys + (j * size) 
        if j>0: y0 += 1
        y1 = y0 + size
        print([x0,y0,x1,y1])

