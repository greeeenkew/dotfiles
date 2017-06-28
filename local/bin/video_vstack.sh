#!/bin/sh

tile_vertical () {
  case $# in
    0|1|2)
      echo "too few arguments"
      echo "usage: $0 <input-movie1> <input-movie2> <output-movie>"
      return 1
    ;;
    *) ;;
  esac

  ffmpeg -i $1 -i $2 -filter_complex \
  '[0:v]pad=iw:ih*2:0:0[int2];
   [int2][1:v]overlay=0:H/2[out]' \
  -map '[out]' -c:v libx264 -crf 23 -preset veryfast $3
}

tile_vertical $@
