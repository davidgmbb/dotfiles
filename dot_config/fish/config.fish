function ls
    command ls --color=auto $argv
end

function start
    command xdg-open $argv
end

function gst
    command git status
end

function ssh
    command kitty +kitten ssh $argv
end

function cdir
    command mkdir $argv && cd $argv
end

set MYHOME "/home/david"

set GIT_DIR "$MYHOME/dev"
set PROGRAMS_DIR "$MYHOME/programs"
set HOMEBREW_BIN_DIR "/home/linuxbrew/.linuxbrew/bin"
set ZIG_DIR "$PROGRAMS_DIR/zig-master"
set RISCV_TOOLCHAIN_BIN_DIR "$PROGRAMS_DIR/riscv/bin"
set PATH "$PATH:$HOMEBREW_BIN_DIR:$MYHOME/.cargo/bin:$PROGRAMS_DIR:$GIT_DIR/zls/zig-out/bin:$GIT_DIR/gf:$ZIG_DIR:$RISCV_TOOLCHAIN_BIN_DIR"

