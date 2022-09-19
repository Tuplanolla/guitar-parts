#! /bin/sh

openscad --camera 2.7,25.7,4.2,60,0,60,150 --imgsize 800,800 \
  --view axes,crosshairs,scales -o nut.png nut.scad && \
openscad --camera -1.4,38.5,3.1,60,0,60,200 --imgsize 800,800 \
  --view axes,crosshairs,scales -o saddle.png saddle.scad && \
montage nut.png saddle.png -geometry '+0+0' -scale '50%' nutsaddle.png
