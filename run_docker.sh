#!/bin/bash

docker run --rm -it --user builder -v $(pwd):/build -v ~/.gitconfig:/home/builder/.gitconfig silabs-builder $*
