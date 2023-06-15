rectoff = [(0,1,2,1),(2,0,3,3),(0,1,1,2),(1,0,4,4),(5,0,2,2),(2,0,1,1),(1,1,3,3),(0,4,5,1)]
_shape = [{1,2},{3,4,5},{6,7,8}]

def get_pos():
    x = [3, 15, 15, 0, 1, 7, 12]
    y = [7, 4, 7, 4, 0, 0, 0]
    k = [1, 1, 1, 2, 2, 3, 3]
    return [(x[i], y[i], _shape[k[i] - 1]) for i in range(len(x))]

pos = [(7, 5, _shape[1])]

import matplotlib.pyplot as plt
import matplotlib.patches as patches

fig, ax = plt.subplots()

color = ['r', 'g', 'b', 'y', 'm', 'k', 'r', 'g', 'b', 'y', 'm', 'k']
for (i, t) in enumerate(pos):
    if t is None:
        continue
    (x, y, shp) = t
    for s in shp:
        roff = rectoff[s - 1]
        xoff = roff[0]
        yoff = roff[1]
        dx = roff[2]
        dy = roff[3]
        ax.add_patch(patches.Rectangle((x+xoff, y+yoff), dx, dy, fill=False, edgecolor=color[i]))

mist = [0,0,0,3,3,3,6,6,6,6,2,2,2,4,4,4,0,0,5,5]
for (x, y) in enumerate(mist):
    ax.add_patch(patches.Rectangle((x, 0), 1, y, fill=False, edgecolor='c'))

plt.plot()
plt.show()