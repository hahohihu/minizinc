bitmap = [
 [False, False, False, False, False,  True,  True, False, False, False],
 [False,  True,  True, False,  True,  True,  True,  True, False, False],
 [True,  True,  True,  True,  True,  True,  True,  True, False, False],
 [True,  True,  True,  True,  True,  True,  True,  True,  True, False],
 [True,  True,  True,  True,  True,  True,  True,  True,  True, False],
 [True,  True,  True,  True,  True,  True, False,  True,  True,  True],
 [True,  True, False, False,  True,  True, False,  True,  True,  True],
 [True,  True, False, False,  True, False, False,  True,  True,  True],
 [False,  True,  True,  True,  True, False, False, False, False, False],
 [True,  True,  True,  True,  True, False, False, False, False, False],
 [False,  True,  True,  True,  True, False, False, False, False, False],
 [False, False, False, False,  True, False, False, False, False, False],
 [False, False, False, False,  True, False, False, False, False, False],
 [False,  True,  True,  True,  True, False, False, False, False, False],
 [True,  True,  True,  True,  True, False, False, False, False, False],
 [False,  True,  True,  True,  True,  True, False, False,  True, False],
 [False, False, False, False,  True,  True, False, False,  True, False],
 [False, False, False, False,  True,  True,  True,  True,  True,  True],
 [False, False, False, False,  True,  True,  True,  True,  True,  True],
 [False, False, False, False,  True,  True,  True,  True,  True,  True],
]


import matplotlib.pyplot as plt
import matplotlib.patches as patches

fig, ax = plt.subplots()


for (x, row) in enumerate(bitmap):
    for (y, cell) in enumerate(row):
        if cell:
            ax.add_patch(patches.Rectangle((x, y), 1, 1, fill=False, edgecolor='r'))

        # ax.add_patch(patches.Rectangle((x+xoff, y+yoff), dx, dy, fill=False, edgecolor=color[i]))
# mist = [0,0,0,3,3,3,6,6,6,6,2,2,2,4,4,4,0,0,5,5]
# for (x, y) in enumerate(mist):
#     ax.add_patch(patches.Rectangle((x, 0), 1, y, fill=False, edgecolor='c'))

plt.plot()
plt.show()