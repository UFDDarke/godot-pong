# godot-pong

# what this
This is a quick and dirty implementation of pong for Godot primarily for learning purposes (I used Unity mainly lol)

This is fairly messy, but it is playable, it just feels a little bad in terms of the ball bounces. I probably need to add a degree of randomization, or let the place where the paddle collision happened affect the ball's bounce trajectory, so more tuning is definitely needed still.

# whats missing
I want to separate the logic for winning into a central Game Controller that dictates when a win happens and what happens afterwards.

# future plans
If I was using Unity, I would probably have a Singleton Game Controller script attached to an in-scene GameObject, and then use C# Events to subscribe any relevant listeners to the round start/game won events.

The game controller would invoke 'game won' events whenever a ball gets past one of the paddles

This would allow the ball to subscribe to the 'game won' event and let it reset its position, as well as let other systems interact, like a sound manager that plays a sound whenever a round is completed/ball launched/etc.

As for actually implementing that in Godot, as far as I know, I'll need to use something called Signals, and for my Singleton Game Manager, I hear that I'm instead to use AutoLoad

I don't think these will be very hard to learn to use, but it should let me create ingame text boxes to show the current scores

Also maybe a super basic AI opponent? Right now the player just controls both paddles at the same time, the left one with WASD and the right one with arrow keys

Would also like to add sounds to learn what that process is like

I was also a giant ScriptableObject abuser in Unity, and apparently those are called Resources in Godot, maybe I can find an excuse to work them into the game somehow just so I'm familiar with using them

# future improvements
1. I feel like my naming conventions and such are a little wack, would love to improve it if I ever work on a more serious project
2. I've hardcoded the boundaries of the game to the default Godot 2d viewport, I should probably use another method
3. ???
