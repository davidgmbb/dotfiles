# Dotfiles

Managed with chezmoi. Review `chezmoi diff` before applying changes, especially
when an application has updated its settings locally.

```sh
chezmoi init https://github.com/davidgmbb/dotfiles.git
chezmoi diff
chezmoi apply
chezmoi verify
chezmoi doctor
```

The shared Bash/Zsh setup keeps existing directories in PATH without duplicates
or empty entries. Put user executables in `~/.local/bin` or `~/bin`; avoid adding
versioned download directories. The Vulkan SDK is optional and is loaded from
`/opt/vulkan-sdk/current/setup-env.sh` when present.

Git uses the desktop Secret Service through `git-credential-libsecret` on Linux,
or the macOS keychain through `osxkeychain`. Linux requires Git's libsecret helper
and an unlocked desktop keyring. Credentials belong in the keyring, never in this
repository. On a headless machine, configure an appropriate secure helper locally.

Neovim's `lazy-lock.json` is tracked to retain plugin revisions. Language servers
are enabled when their executables are installed: clangd, rust-analyzer, zls
(also requiring zig), and ols. Installing these tools enables them next startup.
The terminal, shell, and compositor configurations are available for optional
applications; the repository does not install all of them automatically.

The installer scripts can upgrade system packages; run them deliberately. The
LLVM build script retains its existing LLVM 17 choice. For Zig source builds,
set `LLVM_PREFIX_PATH` to the LLVM installation required by the Zig checkout;
the historical default is `~/programs/llvm17-release`. These scripts do not pin
the Zig source revision or guarantee compatibility with the latest Zig checkout.

Chezmoi's temporary files use `~/.local/share`, alongside the source directory,
so hard-link editing also works when `/tmp` is on a different filesystem.
