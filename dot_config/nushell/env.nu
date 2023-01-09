# Nushell Environment Config File

def create_left_prompt [] {
    let path_segment = ($env.PWD)

    $path_segment
}

def create_right_prompt [] {
    let time_segment = ([
        (date now | date format '%m/%d/%Y %r')
    ] | str collect)

    $time_segment
}

# Use nushell functions to define your right and left prompt
let-env PROMPT_COMMAND = { create_left_prompt }
let-env PROMPT_COMMAND_RIGHT = { create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
let-env PROMPT_INDICATOR = { "〉" }
let-env PROMPT_INDICATOR_VI_INSERT = { ": " }
let-env PROMPT_INDICATOR_VI_NORMAL = { "〉" }
let-env PROMPT_MULTILINE_INDICATOR = { "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
#

def get_home [os] {
    if ($os == "Windows") {
        ($env.USERPROFILE)
    } else {
        ($env.HOME)
    }
}

def get_path [os] {
    if ($os == "Windows") {
        ($env.Path)
    } else {
        ($env.PATH)
    }
}

let OS = ((sys).host.name)
let-env HOME = (get_home $OS)
let-env PATH = (get_path $OS)

let-env ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) }
    to_string: { |v| $v | str collect (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) }
    to_string: { |v| $v | str collect (char esep) }
  }
}

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
let-env NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
let-env NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
let-env DEV_DIR = ($env.HOME | path join 'dev')
let-env ZIG_STAGE1_BIN_DIR = ($env.DEV_DIR | path join 'myzig/build/stage1/bin')
let-env PROGRAMS_DIR = ($env.HOME | path join 'programs')
let-env LINUX_HOMEBREW_BIN_DIR = '/home/linuxbrew/.linuxbrew/bin'
let-env MACOS_HOMEBREW_BIN_DIR = '/opt/homebrew/bin'
let-env ZLS_DIR = ($env.DEV_DIR | path join 'zls/zig-out/bin')
let-env CARGO_BIN_DIR = ($env.HOME | path join '.cargo/bin')
let-env GF_DIR = ($env.DEV_DIR | path join 'gf')
let-env ZIG_LLVM_DIR = '/usr/lib/llvm13/bin'
let-env PATH = ($env.PATH |
    prepend $env.PROGRAMS_DIR |
    prepend $env.ZIG_STAGE1_BIN_DIR |
    prepend $env.LINUX_HOMEBREW_BIN_DIR |
    prepend $env.MACOS_HOMEBREW_BIN_DIR |
    prepend $env.CARGO_BIN_DIR |
    prepend $env.ZLS_DIR |
    prepend $env.ZIG_LLVM_DIR |
    prepend $env.GF_DIR
)
let-env Path = ($env.PATH)
