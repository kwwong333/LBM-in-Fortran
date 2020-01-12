import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

# First set up the figure, the axis, and the plot element we want to animate
fig = plt.figure()
f = np.loadtxt("density_end.txt")
ax = plt.axes(xlim= (0, 800), ylim=(1.0, 1.5))
x = np.linspace(0, 800, 800)
y = f[3999,:]

plt.plot(x,y)
"""
line, = ax.plot(x,y)


# initialization function: plot the background of each frame
def init():
    line.set_data([],[])
    return line,

# animation function.  This is called sequentially
def animate(i):
    line.set_data(np.linspace(0, 800, 800),f[i,:])
    return line,

# call the animator.  blit=True means only re-draw the parts that have changed.
anim = animation.FuncAnimation(fig, animate, init_func=init,
                             interval=1.0, blit=True, frames=4000)

# save the animation as an mp4.  This requires ffmpeg or mencoder to be
# installed.  The extra_args ensure that the x264 codec is used, so that
# the video can be embedded in html5.  You may need to adjust this for
# your system: for more information, see
# http://matplotlib.sourceforge.net/api/animation_api.html
#anim.save('2sc.gif', writer='imagemagick', fps=240)
"""
plt.show()

