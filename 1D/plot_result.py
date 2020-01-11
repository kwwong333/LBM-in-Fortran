import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

# First set up the figure, the axis, and the plot element we want to animate
fig = plt.figure()
<<<<<<< HEAD
ax = plt.axes(xlim=(0, 2000), ylim=(1.0, 1.5))
=======
ax = plt.axes(xlim=(0, 400), ylim=(1, 1.5))
>>>>>>> parent of c6ca4a9... nth
line, = ax.plot([], [], lw=2)

f = np.loadtxt("1D/density_end.txt")

# initialization function: plot the background of each frame
def init():
    line.set_data([], [])
    return line,

# animation function.  This is called sequentially
def animate(i):
<<<<<<< HEAD
    x = np.linspace(0, 2000, 2000)
    y = f[i,:]
=======
    x = np.linspace(0, 400, 400)
    y = f[:,i]
>>>>>>> parent of c6ca4a9... nth
    line.set_data(x, y)
    return line,

# call the animator.  blit=True means only re-draw the parts that have changed.
anim = animation.FuncAnimation(fig, animate, init_func=init,
<<<<<<< HEAD
                              frames=16000, interval=1, blit=False)
=======
                               frames=400, interval=10, blit=False)
>>>>>>> parent of c6ca4a9... nth

# save the animation as an mp4.  This requires ffmpeg or mencoder to be
# installed.  The extra_args ensure that the x264 codec is used, so that
# the video can be embedded in html5.  You may need to adjust this for
# your system: for more information, see
# http://matplotlib.sourceforge.net/api/animation_api.html
<<<<<<< HEAD
#anim.save('2sc.gif', writer='imagemagick', fps=60)
=======
#anim.save('2osc.gif', writer="ffmpeg")
>>>>>>> parent of c6ca4a9... nth

plt.show()
