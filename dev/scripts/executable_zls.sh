#!/bin/bash
git clone --recurse-submodules https://github.com/zigtools/zls.git $HOME/dev/zls
cd /home/david/dev/zls
git checkout 0.9.0
zig build -Drelease-fast

