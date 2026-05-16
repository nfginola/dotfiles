#!/usr/bin/env bash
set -e
nvim --headless "+Lazy! install" +qa
nvim --headless "+TSInstall! c cpp lua bash vim vimdoc odin zig zsh glsl hlsl wgsl markdown markdown_inline cmake make toml yaml json" +qa
echo "Neovim plugins and treesitter parsers installed"
