#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd)

# Load test functions
source $SCRIPT_DIR/functions.sh
source $SCRIPT_DIR/all_colors.sh

#
# Test setup
#

EXAMPLE_DIR="/tmp/dircolors-jellybeans"

EXAMPLES=(
  code
  special
  transient
  audio
  video
  image
  archive
)

ARCHIVE_FILES=(
  .zip .tar .tgz .lzh .z .Z .7z .gz .bz2 .bz
  .deb .rpm .jar .rar .apk .gem
)

CODE_FILES=(
  main.rb main.go main.c main.cpp main.lua
)

SPECIAL_FILES=(
  .torrent .xml .nfo .md .conf .yml
  Rakefile Gemfile README
)

TRANSIENT_FILES=(
  .log .bak .out .part .un~ .swp
  .tmp .o .class .cache
)

AUDIO_FILES=(
  .au .aac .flac .mid .mp3 .ogg .wav .m4a
)

VIDEO_FILES=(
  .mp4 .m4v .mov .mpg .avi .vob .flv .webm
)

IMAGE_FILES=(
  .jpg .JPG .jpeg .gif .bmp .png .svg
  .mng .pcx .eps .CR2 .ico
)

# First clear the screen, then show current date
clearScreenWithTime

# Remove old examples
removeExampleDirs

# Create all the example dirs
createExampleDirs

# Create all example files
createAllExampleFiles

# Create special files, like symlinks etc.
createSpecialFiles

# Reload the dircolors
reloadDircolors

# Show all example dirs
showExampleDirs

# Show all 256 colors
showAllColors

# Real dirs
# showRealDir /dev
# showRealDir /home/peter
