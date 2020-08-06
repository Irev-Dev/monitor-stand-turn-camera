# monitor-stand-turn-camera

I made this part during a live stream, partly because I needed it for my camera, as well as to demonstrate the [round-anything library](https://github.com/Irev-Dev/Round-Anything)
An [overview of the library can be found here](https://kurthutten.com/blog/round-anything-a-pragmatic-approach-to-openscad-design/)
[Library docs are here](https://kurthutten.com/blog/round-anything-api/)
The [stream of this part happened here](https://www.youtube.com/watch?v=1Tegarwy69I).

If you want to use this part, you need to know that it expects the round-anything library to be in `lib/Round-Anything`, instead of copying the library in yourself, the easiest way is to let git-submodules handle it.
```
git clone --recurse-submodules git@github.com:Irev-Dev/monitor-stand-turn-camera.git
# or
git clone --recurse-submodules https://github.com/Irev-Dev/monitor-stand-turn-camera.git
```