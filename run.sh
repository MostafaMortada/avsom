#!/usr/bin/bash

self_dir="$(cd "$(dirname "$0")" && pwd)"

cd $self_dir

#"$self_dir/lua/lua54" "$self_dir/src/main.lua" $self_dir

lua "$self_dir/src/main.lua" $self_dir
