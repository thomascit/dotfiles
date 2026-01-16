#!/bin/sh

BLANK='#00000000'
CLEAR='#00000000'
DEFAULT='#6272A4'
TEXT='#8BE9FD'
WRONG='#FF5555'
VERIFYING='#FF79C6'
RIGHT='#50FA7B'

i3lock \
  --insidever-color=$CLEAR \
  --ringver-color=$VERIFYING \
  \
  --insidewrong-color=$CLEAR \
  --ringwrong-color=$WRONG \
  \
  --inside-color=$BLANK \
  --ring-color=$DEFAULT \
  --line-color=$BLANK \
  --separator-color=$DEFAULT \
  \
  --verif-color=$TEXT \
  --wrong-color=$TEXT \
  --time-color=$TEXT \
  --date-color=$TEXT \
  --keyhl-color=$RIGHT \
  --bshl-color=$WRONG \
  \
  --screen 1 \
  --blur 5 \
  --clock \
  --indicator \
  --time-str="%I:%M %p" \
  --date-str="%m-%d-%Y"
